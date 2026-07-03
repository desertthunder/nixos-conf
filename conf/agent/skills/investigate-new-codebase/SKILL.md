---
name: investigate-new-codebase
description: >
    Investigate an unfamiliar or legacy codebase before making changes.
    Use for first-pass repository audits, onboarding to new code, legacy rescue, due
    diligence, risk mapping, git-history analysis, identifying hotspots, bus factor,
    bug clusters, dependency risk, test risk, and producing a prioritized triage
    instead of a long findings dump.
---

Use this skill when entering an unfamiliar repository and the user wants to
understand it, audit it, or decide where to look first. The goal is a risk map,
not a tour of every file.

Read `references/git-commands-before-reading-code.md` when doing the git history pass.

## Principles

- Start with signals before deep reading. History, structure, tests, deployment,
  and stakeholder fear usually point to the files worth opening first.
- Prefer read-only commands. Do not mutate source, the database, dependency
  lockfiles, or git state during investigation unless the user explicitly asks.
  If a tool writes reports or coverage, send output to `/tmp` or `.sandbox/` when
  possible.
- Separate what looks ugly from what is dangerous. Messy code is not always the
  bottleneck; lost knowledge, risky deploys, missing tests, and security exposure
  often matter more.
- Corroborate before concluding. A high-churn file is not automatically bad; a
  high-churn file that also has bug commits, no owner, high complexity, or no
  tests is a real hotspot.
- Exclude noise: generated code, lockfiles, vendored code, build outputs, and
  broad formatting commits.
- Produce priorities. The useful deliverable is what to fix now, what to plan,
  and what to ignore for the moment.

## Investigation workflow

### 1. Establish context

If people are available, ask a few diagnostic questions before code reading:

- What is the one area nobody wants to touch?
- What broke in production recently that tests did not catch?
- When did the team last deploy confidently?
- What feature or migration has been blocked the longest?
- Which features are quietly disabled or no longer promised to customers?

If people are not available, infer context from `README`, docs, issue templates,
CI config, deploy config, package manifests, and recent commits.

### 2. Run the git history pass

Prefer app source directories over the repository root when possible.

```bash
# Churn hotspots: files changed most in the last year
git log --format=format: --name-only --since="1 year ago" \
  | sort | uniq -c | sort -nr | head -20

# Bus factor: who authored most of the non-merge commits?
git shortlog -sn --no-merges
git shortlog -sn --no-merges --since="6 months ago"

# Bug clusters: files mentioned in bug/fix commits
git log -i -E --grep="fix|bug|broken" --name-only --format='' \
  | sort | uniq -c | sort -nr | head -20

# Momentum: commits per month
git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c

# Firefighting: crisis language in recent history
git log --oneline --since="1 year ago" \
  | grep -iE 'revert|hotfix|emergency|rollback'
```

Interpret with caveats:

- Squash-merge workflows may show mergers instead of original authors.
- Weak commit messages can hide bug clusters and firefighting.
- Monthly commit counts reflect team and release habits, not code quality alone.
- Churn from generated files, dependency bumps, and formatting changes should be
  filtered out.

### 3. Inspect structure before individual files

Look for the system’s shape:

- Entry points, routes, handlers, commands, jobs, and background workers.
- Domain models, database schema, migrations, queues, and external integrations.
- Dependency manifests and outdated or duplicated responsibilities.
- Test layout, coverage configuration, skipped/commented-out tests, and test
  runtime.
- CI/CD, rollback path, observability, error tracking, alerts, and deploy cadence.
- Directories that dominate the codebase, such as most business logic living in a
  model layer or one service directory.

Open individual files only after this pass has suggested where the risk is.

### 4. Choose the first files to read

Prioritize files that overlap multiple signals:

- High churn and frequent bug/fix commits.
- Core domain code with low or zero test coverage.
- High complexity plus recent change activity.
- Code owned historically by a departed or inactive contributor.
- Production incident, rollback, or hotfix history.
- Business-critical paths: auth, billing, checkout, permissions, data deletion,
  migrations, and external payment or messaging integrations.

When using AI on a file, ask narrow questions: list responsibilities, map side
effects, identify missing tests, or find extraction seams. Do not outsource
business judgment; the model cannot know which complexity is load-bearing
without context.

## Deliverable template

Return a compact triage rather than an exhaustive report.

```markdown
## Codebase investigation

### Read first

- `<file>` — why it matters, evidence, confidence

### Fix now / this week

- Risk, evidence, suggested next step

### Fix this quarter

- Risk, evidence, suggested next step

### Do not worry about yet

- Finding and why it is lower priority

### Parallel low-interruption work

- Upgrades, security patches, dead code removal, docs, tests, or cleanup that can
  happen without blocking current feature work

### Caveats

- Missing access, weak commit messages, no coverage data, squash merges, or tools
  not run
```

If the user asks for implementation after the investigation, make the smallest
safe change that addresses the highest-evidence risk.
