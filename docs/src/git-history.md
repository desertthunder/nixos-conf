# Inspect Git History Before Reading Code

Git history can help you choose which parts of an unfamiliar repository to read
first. Use it to find files that change often, areas associated with bug fixes,
knowledge concentrated among a few contributors, and signs of repeated release
failures.

These signals guide investigation. They do not prove that code is defective.
Exclude generated files, lockfiles, vendored code, dependency updates, and broad
formatting commits where possible.

## Churn hotspots

List the files changed most often during the past year:

```bash
git log --format=format: --name-only --since="1 year ago" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -20
```

Run this against an application source directory when the repository root
contains substantial generated or administrative files. A frequently changed
file may be under healthy active development. Give it more attention when it
also appears in bug-fix commits, lacks tests, or has unclear ownership.

## Contributor concentration

Compare all-time authorship with recent authorship:

```bash
git shortlog -sn --no-merges
git shortlog -sn --no-merges --since="6 months ago"
```

A large concentration of commits under one author can indicate that important
knowledge depends on one person. An historically prominent author who is absent
from recent work may indicate a knowledge-transfer risk.

Contributor counts need context. Squash merges and repository migrations can
attribute work to the merger or omit earlier history.

## Bug clusters

Find files touched by commits whose messages mention common bug-fix terms:

```bash
git log -i -E --grep="fix|bug|broken" --name-only --format='' \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -20
```

Compare these results with the churn list. Files near the top of both lists are
good candidates for closer inspection. This search depends on descriptive
commit messages and can miss fixes recorded under vague or project-specific
terms.

## Commit activity

Count commits by month:

```bash
git log --format='%ad' --date=format:'%Y-%m' \
  | sort \
  | uniq -c
```

Changes in monthly volume can reflect development pauses, release batching,
holidays, repository splits, or process changes. Treat the result as team and
project history rather than a code-quality score.

## Reverts and emergency fixes

Search recent commit subjects for release failures and emergency work:

```bash
git log --oneline --since="1 year ago" \
  | grep -iE 'revert|hotfix|emergency|rollback'
```

Frequent results may point to weak tests, missing staging coverage, or a risky
deployment process. No matches may indicate stable releases or merely different
commit-message vocabulary.

## Choosing what to read first

Prioritize files or areas where several signals overlap:

- high churn and repeated bug-fix commits;
- core code with few tests;
- ownership concentrated under an inactive contributor;
- repeated rollback, hotfix, or revert history;
- recent changes in authentication, billing, permissions, migrations, or data
  deletion.

Use the results to form questions and select files. Confirm each suspected risk
by reading the code, tests, issue history, and deployment documentation.

Adapted from Ally Piechowski, [The Git Commands I Run Before Reading Any
Code](https://piechowski.io/post/git-commands-before-reading-code/).
