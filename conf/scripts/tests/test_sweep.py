import subprocess
from dataclasses import replace
from datetime import date
from pathlib import Path

import pytest

from dotscripts.sweep import RepoReport, Verdict, classify, find_repos, inspect_repo, local_work_reasons

TODAY = date(2026, 9, 27)
PUSHED = RepoReport(
    path=Path("/p"),
    last_commit=date(2026, 9, 1),
    has_remote=True,
    changed_files=0,
    stashes=0,
    unpushed_commits=0,
    size_bytes=0,
    artifact_bytes=0,
)


@pytest.mark.parametrize(
    ("changes", "expected"),
    [
        ({}, Verdict.ACTIVE),
        ({"last_commit": date(2025, 1, 1)}, Verdict.STALE),
        ({"last_commit": None}, Verdict.EMPTY),
        ({"has_remote": False, "last_commit": date(2025, 1, 1)}, Verdict.LOCAL_WORK),
        ({"changed_files": 3}, Verdict.LOCAL_WORK),
        ({"stashes": 1}, Verdict.LOCAL_WORK),
        ({"unpushed_commits": 2, "last_commit": date(2025, 1, 1)}, Verdict.LOCAL_WORK),
    ],
    ids=["active", "stale", "empty", "no-remote", "changed", "stashed", "unpushed"],
)
def test_classify(changes, expected):
    assert classify(replace(PUSHED, **changes), TODAY, stale_days=180) is expected


def test_local_work_reasons_lists_every_cause():
    report = replace(PUSHED, has_remote=False, changed_files=2, unpushed_commits=1)
    assert local_work_reasons(report) == "no remote, 2 changed, 1 unpushed"


def git(repo: Path, *args: str) -> None:
    subprocess.run(
        ["git", "-C", str(repo), "-c", "user.name=t", "-c", "user.email=t@t", *args],
        check=True,
        capture_output=True,
    )


def test_find_repos_stops_at_repositories_and_skips_artifacts(tmp_path):
    (tmp_path / "group" / "app" / ".git").mkdir(parents=True)
    (tmp_path / "group" / "app" / "vendor" / ".git").mkdir(parents=True)
    (tmp_path / "node_modules" / "pkg" / ".git").mkdir(parents=True)
    (tmp_path / "deep" / "a" / "b" / ".git").mkdir(parents=True)

    assert find_repos(tmp_path, max_depth=2) == [tmp_path / "group" / "app"]


def test_inspect_repo_counts_work_missing_from_the_remote(tmp_path):
    remote = tmp_path / "remote.git"
    repo = tmp_path / "repo"
    subprocess.run(["git", "init", "-q", "--bare", str(remote)], check=True)
    subprocess.run(["git", "init", "-q", str(repo)], check=True)
    git(repo, "commit", "-q", "--allow-empty", "-m", "one")
    git(repo, "remote", "add", "origin", str(remote))
    git(repo, "push", "-q", "origin", "HEAD")
    git(repo, "switch", "-q", "-c", "feature")
    git(repo, "commit", "-q", "--allow-empty", "-m", "two")
    (repo / "target").mkdir()
    (repo / "target" / "bin").write_bytes(b"x" * 8192)
    (repo / "notes.txt").write_text("draft")

    report = inspect_repo(repo)

    assert report.has_remote
    assert report.unpushed_commits == 1
    assert report.changed_files == 2
    assert report.artifact_bytes >= 8192
    assert classify(report, date.today(), stale_days=180) is Verdict.LOCAL_WORK
