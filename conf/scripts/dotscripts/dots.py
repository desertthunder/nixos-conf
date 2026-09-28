"""Link this repository's dotfiles into place on machines without Home Manager.

`conf/dots.toml` lists three kinds of entries:

- `[[link]]` symlinks a repository file or directory to a target path. With
  `each = true`, every child of the source directory gets its own link inside
  the target directory, so entries that other tools own there are left alone.
- `[[repo]]` clones a Git repository to a target path.
- `retire` lists files that shadow managed config, such as `~/.gitconfig`
  shadowing `~/.config/git/config`.

Every command that changes the home directory is a dry run until `--apply` is
passed. An applied run moves each replaced file into
`~/.local/state/dots/runs/<timestamp>/files/` and writes `journal.json` beside
it, so `dots restore` can put the previous files back.
"""

from __future__ import annotations

import json
import shutil
import subprocess
import tomllib
from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from pathlib import Path

import click
from rich.console import Console
from rich.table import Table

REPO_ROOT = Path(__file__).resolve().parents[3]
MANIFEST_PATH = REPO_ROOT / "conf" / "dots.toml"
BREWFILE_PATH = REPO_ROOT / "conf" / "packages" / "Brewfile"

console = Console()


class DotsError(click.ClickException):
    """An error that stops the command and is shown to the user as is."""


class State(Enum):
    OK = "ok"
    MISSING = "missing"
    DIFFERS = "differs"
    SOURCE_MISSING = "source missing"


@dataclass(frozen=True)
class Link:
    source: Path
    target: Path


@dataclass(frozen=True)
class Repo:
    url: str
    target: Path


@dataclass(frozen=True)
class Manifest:
    links: tuple[Link, ...]
    repos: tuple[Repo, ...]
    retire: tuple[Path, ...]


@dataclass(frozen=True)
class Action:
    """One change to the home directory.

    `kind` is "link", "clone", or "retire". When `replaces` is true, whatever
    occupies `target` moves into the run's backup directory first.
    """

    kind: str
    target: Path
    source: Path | None = None
    url: str | None = None
    replaces: bool = False


def load_manifest(path: Path, repo_root: Path) -> Manifest:
    """Parse the manifest and expand `each = true` links into one link per child."""
    data = tomllib.loads(path.read_text())
    links = tuple(
        link for entry in data.get("link", []) for link in _expand_link(entry, repo_root)
    )
    repos = tuple(
        Repo(_require(entry, "url", "repo"), _home_path(_require(entry, "target", "repo")))
        for entry in data.get("repo", [])
    )
    retire = tuple(_home_path(raw) for raw in data.get("retire", []))
    return Manifest(links, repos, retire)


def _require(entry: dict, key: str, kind: str) -> str:
    if key not in entry:
        raise DotsError(f"A [[{kind}]] entry in the manifest has no '{key}': {entry}")
    return entry[key]


def _home_path(raw: str) -> Path:
    return Path(raw).expanduser()


def _expand_link(entry: dict, repo_root: Path) -> list[Link]:
    source = repo_root / _require(entry, "source", "link")
    target = _home_path(_require(entry, "target", "link"))
    if not entry.get("each", False):
        return [Link(source, target)]
    if not source.is_dir():
        raise DotsError(f"{source} must be a directory because its entry sets each = true")
    return [
        Link(child, target / child.name)
        for child in sorted(source.iterdir())
        if not child.name.startswith(".")
    ]


def _occupied(path: Path) -> bool:
    """Report whether anything, including a broken symlink, sits at `path`."""
    return path.exists() or path.is_symlink()


def link_state(link: Link) -> State:
    if not link.source.exists():
        return State.SOURCE_MISSING
    if link.target.is_symlink() and link.target.resolve() == link.source.resolve():
        return State.OK
    if not _occupied(link.target):
        return State.MISSING
    return State.DIFFERS


def repo_state(repo: Repo) -> State:
    """A repo is OK when the target is a checkout whose origin is `repo.url`."""
    if not _occupied(repo.target):
        return State.MISSING
    origin = subprocess.run(
        ["git", "-C", str(repo.target), "remote", "get-url", "origin"],
        capture_output=True,
        text=True,
    )
    if origin.returncode == 0 and origin.stdout.strip() == repo.url:
        return State.OK
    return State.DIFFERS


def retire_state(path: Path) -> State:
    return State.DIFFERS if _occupied(path) else State.OK


def plan(manifest: Manifest, only: str | None = None) -> list[Action]:
    """List the actions that bring the home directory in line with the manifest.

    `only` keeps the actions whose target path contains that text.
    """
    actions: list[Action] = []
    for link in manifest.links:
        state = link_state(link)
        if state is State.SOURCE_MISSING:
            raise DotsError(f"{link.source} does not exist. Fix its entry in the manifest.")
        if state is not State.OK:
            actions.append(
                Action("link", link.target, source=link.source, replaces=state is State.DIFFERS)
            )
    for repo in manifest.repos:
        state = repo_state(repo)
        if state is not State.OK:
            actions.append(
                Action("clone", repo.target, url=repo.url, replaces=state is State.DIFFERS)
            )
    for path in manifest.retire:
        if retire_state(path) is State.DIFFERS:
            actions.append(Action("retire", path, replaces=True))
    return [action for action in actions if only is None or only in str(action.target)]


class Run:
    """The backup directory and journal for one applied set of actions.

    Replaced files keep their path relative to the home directory under
    `files/`, so the backup directory reads like a sparse copy of home.
    """

    def __init__(self, state_dir: Path, home: Path):
        self.dir = state_dir / "runs" / datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        self.home = home
        self.entries: list[dict] = []

    def set_aside(self, path: Path, area: str = "files") -> Path:
        backup = self.dir / area / _relative_to_home(path, self.home)
        backup.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(path, backup)
        return backup

    def record(self, action: Action, backup: Path | None) -> None:
        self.entries.append(
            {"kind": action.kind, "target": str(action.target), "backup": str(backup) if backup else None}
        )

    def save(self) -> None:
        self.dir.mkdir(parents=True, exist_ok=True)
        (self.dir / "journal.json").write_text(json.dumps(self.entries, indent=2) + "\n")


def _relative_to_home(path: Path, home: Path) -> Path:
    return path.relative_to(home) if path.is_relative_to(home) else path.relative_to(path.anchor)


def apply_actions(actions: list[Action], run: Run) -> None:
    """Apply `actions` in order. The journal is saved even when one fails."""
    try:
        for action in actions:
            backup = run.set_aside(action.target) if action.replaces else None
            _perform(action)
            run.record(action, backup)
    finally:
        run.save()


def _perform(action: Action) -> None:
    if action.kind == "retire":
        return
    action.target.parent.mkdir(parents=True, exist_ok=True)
    if action.kind == "link":
        action.target.symlink_to(action.source)
        return
    clone = subprocess.run(["git", "clone", action.url, str(action.target)])
    if clone.returncode != 0:
        raise DotsError(f"git clone {action.url} failed with exit code {clone.returncode}")


def restore(run_dir: Path, home: Path) -> None:
    """Undo a run: remove what it created and move its backups back into place.

    A clone or other real directory created by the run is moved to
    `restored-away/` inside the run directory instead of being deleted. The
    journal is renamed afterwards so the run is not restored twice.
    """
    journal = run_dir / "journal.json"
    entries = json.loads(journal.read_text())
    for entry in reversed(entries):
        target = Path(entry["target"])
        if target.is_symlink():
            target.unlink()
        elif target.exists():
            away = run_dir / "restored-away" / _relative_to_home(target, home)
            away.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(target, away)
        if entry["backup"]:
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(entry["backup"], target)
    journal.rename(run_dir / "journal.restored.json")


def latest_run(state_dir: Path) -> Path:
    runs = sorted(path.parent for path in (state_dir / "runs").glob("*/journal.json"))
    if not runs:
        raise DotsError(f"No runs to restore in {state_dir / 'runs'}")
    return runs[-1]


def adopt(link: Link, run: Run) -> None:
    """Copy a local target into the repository, then replace it with a link."""
    state = link_state(link)
    if state is not State.DIFFERS:
        raise DotsError(f"{link.target} has nothing to adopt ({state.value})")
    _copy_over(link.target, link.source)
    apply_actions([Action("link", link.target, source=link.source, replaces=True)], run)


def _copy_over(source: Path, destination: Path) -> None:
    if source.is_dir():
        if destination.exists():
            shutil.rmtree(destination)
        shutil.copytree(source, destination, symlinks=True)
        return
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)


def _refuse_on_nixos() -> None:
    if Path("/etc/NIXOS").exists():
        raise DotsError("This is a NixOS host. Home Manager owns these files; run nixos-rebuild instead.")


def _state_dir() -> Path:
    return Path.home() / ".local" / "state" / "dots"


def _display(path: Path | None) -> str:
    if path is None:
        return ""
    home = str(Path.home())
    text = str(path)
    if text.startswith(str(REPO_ROOT)):
        return text[len(str(REPO_ROOT)) + 1 :]
    return "~" + text[len(home) :] if text.startswith(home) else text


STATE_STYLES = {
    State.OK: "green",
    State.MISSING: "yellow",
    State.DIFFERS: "red",
    State.SOURCE_MISSING: "bold red",
}


def _status_rows(manifest: Manifest) -> list[tuple[str, Path, str, State]]:
    rows = [("link", link.target, _display(link.source), link_state(link)) for link in manifest.links]
    rows += [("repo", repo.target, repo.url, repo_state(repo)) for repo in manifest.repos]
    rows += [("retire", path, "", retire_state(path)) for path in manifest.retire]
    return rows


def _show_diff(link: Link) -> None:
    console.rule(_display(link.target))
    subprocess.run(
        ["git", "--no-pager", "diff", "--no-index", "--color=always", str(link.target), str(link.source)]
    )


def _print_plan(actions: list[Action]) -> None:
    table = Table(title="Planned changes")
    for column in ("Action", "Target", "From", "Existing target"):
        table.add_column(column)
    for action in actions:
        origin = _display(action.source) if action.source else action.url or ""
        table.add_row(action.kind, _display(action.target), origin, "backed up" if action.replaces else "")
    console.print(table)


@click.group()
def cli() -> None:
    """Manage this repository's dotfiles on machines without Home Manager."""


@cli.command()
@click.option("--diff", "show_diff", is_flag=True, help="Show how each differing file compares with the repository copy.")
def status(show_diff: bool) -> None:
    """Show each managed path and whether it matches the manifest."""
    manifest = load_manifest(MANIFEST_PATH, REPO_ROOT)
    table = Table()
    for column in ("Kind", "Target", "Source", "State"):
        table.add_column(column)
    for kind, target, source, state in _status_rows(manifest):
        label = "present" if kind == "retire" and state is State.DIFFERS else state.value
        table.add_row(kind, _display(target), source, f"[{STATE_STYLES[state]}]{label}[/]")
    console.print(table)
    if not show_diff:
        return
    for link in manifest.links:
        if link_state(link) is State.DIFFERS:
            _show_diff(link)


@cli.command()
@click.option("--apply", "apply_changes", is_flag=True, help="Make the changes instead of only listing them.")
@click.option("--only", metavar="TEXT", help="Limit to targets whose path contains TEXT.")
def link(apply_changes: bool, only: str | None) -> None:
    """Link, clone, and retire paths to match the manifest."""
    _refuse_on_nixos()
    actions = plan(load_manifest(MANIFEST_PATH, REPO_ROOT), only)
    if not actions:
        console.print("Nothing to do.")
        return
    _print_plan(actions)
    if not apply_changes:
        console.print("Dry run. Re-run with --apply to make these changes.")
        return
    run = Run(_state_dir(), Path.home())
    apply_actions(actions, run)
    console.print(f"Applied. Backups are in {_display(run.dir)}. Undo with: dots restore {run.dir.name}")


@cli.command(name="restore")
@click.argument("run_name", required=False)
def restore_command(run_name: str | None) -> None:
    """Undo a run. Defaults to the most recent run that has not been restored."""
    _refuse_on_nixos()
    state_dir = _state_dir()
    run_dir = state_dir / "runs" / run_name if run_name else latest_run(state_dir)
    if not (run_dir / "journal.json").exists():
        raise DotsError(f"{run_dir} has no journal to restore")
    restore(run_dir, Path.home())
    console.print(f"Restored {run_dir.name}.")


@cli.command(name="adopt")
@click.argument("target", type=click.Path(exists=True, file_okay=True, dir_okay=True, path_type=Path))
def adopt_command(target: Path) -> None:
    """Copy a local config into the repository and link it back.

    Review the result with git diff and keep or revert it there.
    """
    _refuse_on_nixos()
    target = target.expanduser().absolute()
    manifest = load_manifest(MANIFEST_PATH, REPO_ROOT)
    matches = [link for link in manifest.links if link.target == target]
    if not matches:
        raise DotsError(f"{target} is not a link target in the manifest")
    run = Run(_state_dir(), Path.home())
    adopt(matches[0], run)
    console.print(f"Adopted {_display(target)} into {_display(matches[0].source)}. Review with: git diff")


@cli.command()
@click.option("--install", is_flag=True, help="Install missing Brewfile packages. Never upgrades or removes anything.")
def doctor(install: bool) -> None:
    """Check that the tools the dotfiles expect are installed."""
    brew = shutil.which("brew")
    if brew is None:
        raise DotsError(
            "Homebrew is not installed. Install it from https://brew.sh, or install the "
            f"packages in {_display(BREWFILE_PATH)} with your distribution's package manager."
        )
    command = [brew, "bundle", "install", "--no-upgrade"] if install else [brew, "bundle", "check", "--verbose", "--no-upgrade"]
    bundle = subprocess.run([*command, "--file", str(BREWFILE_PATH)])
    oh_my_zsh = (Path.home() / ".oh-my-zsh").is_dir()
    if not oh_my_zsh:
        console.print("[red]oh-my-zsh is missing.[/] Install it from https://ohmyz.sh; the zshrc requires it.")
    if bundle.returncode != 0 and not install:
        console.print("Install the missing packages with: dots doctor --install")
    if bundle.returncode != 0 or not oh_my_zsh:
        raise SystemExit(1)
