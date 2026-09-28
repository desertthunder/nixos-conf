import subprocess
from pathlib import Path

import pytest

from dotscripts.dots import (
    Action,
    DotsError,
    Link,
    Run,
    State,
    adopt,
    apply_actions,
    latest_run,
    link_state,
    load_manifest,
    plan,
    repo_state,
    restore,
)


@pytest.fixture
def home(tmp_path, monkeypatch):
    home = tmp_path / "home"
    home.mkdir()
    monkeypatch.setenv("HOME", str(home))
    return home


@pytest.fixture
def repo(tmp_path):
    repo = tmp_path / "repo"
    (repo / "modules" / "skills" / "writing").mkdir(parents=True)
    (repo / "modules" / "skills" / "css").mkdir()
    (repo / "modules" / "skills" / ".DS_Store").write_text("")
    (repo / "modules" / "zshrc").write_text("repo zshrc\n")
    return repo


def write_manifest(repo: Path, body: str) -> Path:
    path = repo / "dots.toml"
    path.write_text(body)
    return path


def manifest_for(repo: Path, body: str):
    return load_manifest(write_manifest(repo, body), repo)


ZSHRC = """
[[link]]
source = "modules/zshrc"
target = "~/.zshrc"
"""


def test_each_links_every_visible_child(repo, home):
    manifest = manifest_for(
        repo,
        """
[[link]]
source = "modules/skills"
target = "~/.claude/skills"
each = true
""",
    )
    assert [link.target for link in manifest.links] == [
        home / ".claude/skills/css",
        home / ".claude/skills/writing",
    ]


def test_missing_key_names_the_entry(repo, home):
    with pytest.raises(DotsError, match="no 'target'"):
        manifest_for(repo, '[[link]]\nsource = "modules/zshrc"\n')


@pytest.mark.parametrize(
    ("setup", "expected"),
    [
        (lambda target, source: None, State.MISSING),
        (lambda target, source: target.symlink_to(source), State.OK),
        (lambda target, source: target.write_text("local\n"), State.DIFFERS),
        (lambda target, source: target.symlink_to(target.parent / "gone"), State.DIFFERS),
    ],
    ids=["missing", "linked", "local-file", "broken-symlink"],
)
def test_link_state(repo, home, setup, expected):
    link = Link(repo / "modules/zshrc", home / ".zshrc")
    setup(link.target, link.source)
    assert link_state(link) is expected


def test_plan_rejects_missing_source(repo, home):
    manifest = manifest_for(repo, '[[link]]\nsource = "nope"\ntarget = "~/.nope"\n')
    with pytest.raises(DotsError, match="does not exist"):
        plan(manifest)


def test_plan_filters_with_only(repo, home):
    manifest = manifest_for(repo, ZSHRC + '[[link]]\nsource = "modules/skills"\ntarget = "~/.skills"\n')
    assert [action.target for action in plan(manifest, only="zshrc")] == [home / ".zshrc"]


def test_apply_backs_up_and_restore_reverts(repo, home):
    (home / ".zshrc").write_text("local zshrc\n")
    (home / ".gitconfig").write_text("[user]\n")
    manifest = manifest_for(repo, 'retire = ["~/.gitconfig"]\n' + ZSHRC)
    state_dir = home / ".local/state/dots"

    run = Run(state_dir, home)
    apply_actions(plan(manifest), run)

    assert (home / ".zshrc").resolve() == (repo / "modules/zshrc").resolve()
    assert not (home / ".gitconfig").exists()
    assert (run.dir / "files/.zshrc").read_text() == "local zshrc\n"
    assert plan(manifest) == []

    restore(latest_run(state_dir), home)

    assert not (home / ".zshrc").is_symlink()
    assert (home / ".zshrc").read_text() == "local zshrc\n"
    assert (home / ".gitconfig").read_text() == "[user]\n"
    with pytest.raises(DotsError):
        latest_run(state_dir)


def test_adopt_copies_local_file_into_repo(repo, home):
    (home / ".zshrc").write_text("local zshrc\n")
    link = Link(repo / "modules/zshrc", home / ".zshrc")

    adopt(link, Run(home / "state", home))

    assert (repo / "modules/zshrc").read_text() == "local zshrc\n"
    assert link_state(link) is State.OK


def test_adopt_refuses_when_already_linked(repo, home):
    link = Link(repo / "modules/zshrc", home / ".zshrc")
    link.target.symlink_to(link.source)
    with pytest.raises(DotsError, match="nothing to adopt"):
        adopt(link, Run(home / "state", home))


def git(*args: str) -> None:
    subprocess.run(["git", *args], check=True, capture_output=True)


def test_clone_repo_and_detect_foreign_checkout(tmp_path, home):
    upstream = tmp_path / "upstream"
    git("init", "-q", str(upstream))
    git("-C", str(upstream), "-c", "user.name=t", "-c", "user.email=t@t", "commit", "-q", "--allow-empty", "-m", "init")
    manifest = manifest_for(tmp_path, f'[[repo]]\nurl = "{upstream}"\ntarget = "~/.config/nvim"\n')

    (home / ".config/nvim").mkdir(parents=True)
    assert repo_state(manifest.repos[0]) is State.DIFFERS

    actions = plan(manifest)
    assert actions == [Action("clone", home / ".config/nvim", url=str(upstream), replaces=True)]
    apply_actions(actions, Run(home / "state", home))
    assert repo_state(manifest.repos[0]) is State.OK
