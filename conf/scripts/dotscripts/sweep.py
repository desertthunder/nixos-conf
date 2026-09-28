"""Report free disk space and triage Git projects for cleanup. Never deletes.

`sweep` finds every Git repository under the scan roots and records what Mole
cannot see: the date of the last commit, uncommitted changes, stashes, commits
on any local branch that no remote has, and whether a remote exists at all.
Each repository then falls into one of four verdicts:

- local work: changes, stashes, or commits exist only on this machine. Push or
  archive them before removing anything.
- stale: clean, fully pushed, and untouched for `--stale-days`. It can be
  removed and cloned again later.
- active: clean, pushed, and recently committed.
- no commits: an empty repository.

Build artifacts are sized for reference only. `mo purge` removes them.
"""

from __future__ import annotations

import os
import shutil
import subprocess
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
from datetime import date
from enum import Enum
from pathlib import Path

import click
from rich.console import Console
from rich.table import Table

ARTIFACT_DIRS = frozenset(
    {
        ".build",
        ".dart_tool",
        ".gradle",
        ".next",
        ".svelte-kit",
        ".venv",
        ".zig-cache",
        "DerivedData",
        "_build",
        "build",
        "dist",
        "node_modules",
        "target",
        "zig-cache",
    }
)

console = Console()


class Verdict(Enum):
    LOCAL_WORK = "local work"
    STALE = "stale"
    ACTIVE = "active"
    EMPTY = "no commits"


VERDICT_STYLES = {
    Verdict.LOCAL_WORK: "red",
    Verdict.STALE: "yellow",
    Verdict.ACTIVE: "green",
    Verdict.EMPTY: "dim",
}


@dataclass(frozen=True)
class RepoReport:
    path: Path
    last_commit: date | None
    has_remote: bool
    changed_files: int
    stashes: int
    unpushed_commits: int
    size_bytes: int
    artifact_bytes: int


def find_repos(root: Path, max_depth: int) -> list[Path]:
    """Find Git repositories under `root` without descending into one."""
    if (root / ".git").exists():
        return [root]
    if max_depth == 0:
        return []
    repos: list[Path] = []
    for child in sorted(root.iterdir()):
        if child.is_dir() and not child.is_symlink() and child.name not in ARTIFACT_DIRS:
            repos += find_repos(child, max_depth - 1)
    return repos


def _git(repo: Path, *args: str) -> str:
    result = subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True)
    if result.returncode != 0:
        raise click.ClickException(f"git {' '.join(args)} failed in {repo}: {result.stderr.strip()}")
    return result.stdout


def _last_commit(repo: Path) -> date | None:
    if subprocess.run(["git", "-C", str(repo), "rev-parse", "--verify", "-q", "HEAD"], capture_output=True).returncode != 0:
        return None
    return date.fromisoformat(_git(repo, "log", "-1", "--format=%cs").strip())


def _count_lines(text: str) -> int:
    return len(text.splitlines())


def _du_bytes(path: Path) -> int:
    result = subprocess.run(["du", "-sk", str(path)], capture_output=True, text=True)
    return int(result.stdout.split()[0]) * 1024 if result.stdout else 0


def _artifact_dirs(repo: Path) -> list[Path]:
    found: list[Path] = []
    for current, dirs, _files in os.walk(repo):
        for name in list(dirs):
            if name in ARTIFACT_DIRS:
                found.append(Path(current) / name)
                dirs.remove(name)
            elif name == ".git":
                dirs.remove(name)
    return found


def inspect_repo(repo: Path) -> RepoReport:
    """Collect Git state and sizes for one repository.

    Unpushed commits count every commit on a local branch that no remote
    branch contains, so work on branches other than the current one counts.
    """
    return RepoReport(
        path=repo,
        last_commit=_last_commit(repo),
        has_remote=bool(_git(repo, "remote").strip()),
        changed_files=_count_lines(_git(repo, "status", "--porcelain")),
        stashes=_count_lines(_git(repo, "stash", "list")),
        unpushed_commits=_count_lines(_git(repo, "log", "--branches", "--not", "--remotes", "--oneline")),
        size_bytes=_du_bytes(repo),
        artifact_bytes=sum(_du_bytes(path) for path in _artifact_dirs(repo)),
    )


def classify(report: RepoReport, today: date, stale_days: int) -> Verdict:
    if report.last_commit is None:
        return Verdict.EMPTY
    local_only = (
        not report.has_remote or report.changed_files or report.stashes or report.unpushed_commits
    )
    if local_only:
        return Verdict.LOCAL_WORK
    if (today - report.last_commit).days >= stale_days:
        return Verdict.STALE
    return Verdict.ACTIVE


def local_work_reasons(report: RepoReport) -> str:
    reasons = [
        "no remote" if not report.has_remote else "",
        f"{report.changed_files} changed" if report.changed_files else "",
        f"{report.stashes} stashed" if report.stashes else "",
        f"{report.unpushed_commits} unpushed" if report.unpushed_commits else "",
    ]
    return ", ".join(reason for reason in reasons if reason)


def human_size(size: int) -> str:
    for unit in ("B", "K", "M", "G"):
        if size < 1024:
            return f"{size:.0f}{unit}" if unit == "B" else f"{size:.1f}{unit}"
        size /= 1024
    return f"{size:.1f}T"


def _print_free_space(target_gb: int) -> None:
    free = shutil.disk_usage(Path.home()).free
    style = "green" if free >= target_gb * 1024**3 else "red"
    console.print(f"Free space: [{style}]{human_size(free)}[/] (target {target_gb}G)")


def _print_reports(reports: list[RepoReport], today: date, stale_days: int, home: Path) -> None:
    table = Table()
    for column in ("Project", "Verdict", "Last commit", "Size", "Artifacts", "Why"):
        table.add_column(column, justify="right" if column in ("Size", "Artifacts") else "left")
    for report in sorted(reports, key=lambda r: r.size_bytes, reverse=True):
        verdict = classify(report, today, stale_days)
        table.add_row(
            "~/" + str(report.path.relative_to(home)) if report.path.is_relative_to(home) else str(report.path),
            f"[{VERDICT_STYLES[verdict]}]{verdict.value}[/]",
            str(report.last_commit or ""),
            human_size(report.size_bytes),
            human_size(report.artifact_bytes),
            local_work_reasons(report),
        )
    console.print(table)


def _print_totals(reports: list[RepoReport], today: date, stale_days: int) -> None:
    stale = [r for r in reports if classify(r, today, stale_days) is Verdict.STALE]
    console.print(f"Build artifacts: {human_size(sum(r.artifact_bytes for r in reports))}. Preview removal with: mo purge --dry-run")
    console.print(f"Stale projects: {len(stale)}, {human_size(sum(r.size_bytes for r in stale))} in total.")
    console.print("System caches and app leftovers: mo clean --dry-run. Interactive explorer: mo analyze")


@click.command()
@click.option(
    "--root",
    "roots",
    multiple=True,
    type=click.Path(exists=True, file_okay=False, path_type=Path),
    help="Directory to scan. Repeatable. Defaults to ~/Projects.",
)
@click.option("--depth", default=4, show_default=True, help="How many directory levels to search for repositories.")
@click.option("--stale-days", default=180, show_default=True, help="Days since the last commit before a clean project counts as stale.")
@click.option("--target-free", default=150, show_default=True, help="Free space goal in gigabytes.")
def cli(roots: tuple[Path, ...], depth: int, stale_days: int, target_free: int) -> None:
    """Report free space and which projects are safe to clean up. Deletes nothing."""
    home = Path.home()
    repos = [repo for root in roots or (home / "Projects",) for repo in find_repos(root.resolve(), depth)]
    with console.status(f"Inspecting {len(repos)} repositories"), ThreadPoolExecutor() as pool:
        reports = list(pool.map(inspect_repo, repos))
    today = date.today()
    _print_free_space(target_free)
    _print_reports(reports, today, stale_days, home)
    _print_totals(reports, today, stale_days)
