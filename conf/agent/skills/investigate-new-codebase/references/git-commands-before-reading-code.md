---
Notes: The Git Commands I Run Before Reading Any Code
Source: https://piechowski.io/post/git-commands-before-reading-code/
Author: Ally Piechowski
Date: 2026-04-08
Captured: 2026-07-03
Tags: git, legacy-code, codebase-audit, technical-debt
---

## Summary

Before reading files in a new codebase, use a short set of git history queries to
identify churn hotspots, ownership risk, bug clusters, project momentum, and
firefighting patterns.

## Key Ideas

- **History points to where to read first:** Commit history can show which files
  change often, who built the system, where fixes cluster, and whether the team
  appears to be shipping steadily or reacting to crises.
- **Churn is a signal, not a verdict:** A frequently changed file may be healthy
  active work, but high churn combined with fear, bug fixes, or unclear ownership
  is a strong warning sign.
- **Ownership changes matter:** Comparing all-time contributors with recent
  contributors exposes bus-factor and knowledge-transfer risk.
- **Bug keywords create a rough heat map:** Filtering commit history for fix/bug
  language can reveal files that repeatedly break, as long as commit messages are
  descriptive enough.
- **Team behavior appears in history:** Monthly commit volume and hotfix/revert
  language can indicate momentum loss, release batching, or deploy instability.

## Claims & Evidence

### Churn hotspots are a good first-read list

The author recommends listing the most changed source files from the past year
and ignoring root-level noise such as lockfiles, changelogs, and generated code.
The top files are often the same files teams warn outsiders about.

Caveat/confidence: High. The article frames churn as diagnostic, not inherently
bad; it becomes more meaningful when crossed with bug hotspots or team concern.

### Churn plus bug frequency marks the highest-risk code

The author cross-references the top changed files with files appearing in
bug-related commits. Files appearing in both lists are described as the biggest
risk because they keep changing and keep breaking.

Caveat/confidence: Medium-high. This depends on commit message discipline and
can miss bugs hidden behind vague messages such as "update stuff."

### Contributor concentration exposes bus factor

`git shortlog -sn --no-merges` shows commit counts by contributor. If one person
accounts for most commits, or the historical top contributor is absent from the
recent six-month window, the project may have serious knowledge risk.

Caveat/confidence: Medium. Squash-merge workflows can distort authorship by
showing who merged rather than who wrote the code.

### Commit velocity reflects team history as much as code history

Grouping commit dates by month can reveal steady development, sudden drop-offs,
declining momentum, or batched release patterns. The author treats this as team
data rather than a direct measure of code quality.

Caveat/confidence: Medium. Release practices, repository splits, holidays, and
process changes can affect the shape.

### Reverts and hotfixes indicate deploy trust problems

Searching recent commits for revert, hotfix, emergency, and rollback language can
show whether the team is regularly firefighting. Frequent results may point to
weak tests, missing staging, or a risky deploy/rollback process.

Caveat/confidence: Medium. Zero matches can mean stability, but it can also mean
poorly described commits.

## Important Terms

| Term                 | Meaning                                                              |
| -------------------- | -------------------------------------------------------------------- |
| Churn hotspot        | A file or area changed repeatedly over a chosen period.              |
| Bus factor           | The risk that critical knowledge depends on one or very few people.  |
| Bug cluster          | A file or area repeatedly touched by bug-fix commits.                |
| Commit velocity      | Commit volume over time, used as a rough signal of project momentum. |
| Firefighting pattern | Repeated emergency, rollback, hotfix, or revert activity.            |

## Questions for Review

- What five project risks do the suggested git commands try to reveal?
- Why should churn hotspots be compared with bug hotspots before drawing a
  conclusion?
- How can squash merging change the interpretation of contributor counts?
- What might a sudden drop in monthly commits indicate?
- Why can zero hotfix or rollback matches still be ambiguous?

## Connections

- Related ideas: code churn analysis, socio-technical code analysis, technical
  due diligence, incident history, ownership mapping.
- Related sources: Adam Tornhill's churn-based code analysis work; research on
  relative code churn and defect prediction.
- Contradictions or tensions: Git history can reveal risk quickly, but weak team
  process or commit discipline can hide the same risk.
- Useful applications: onboarding, audit scoping, choosing first files to read,
  prioritizing refactors, preparing stakeholder questions.

## Open Questions

- How should these commands be adjusted for monorepos with many independent
  products?
- What thresholds should count as unusually high churn or unusually frequent
  hotfixes for different team sizes?
- How should generated code and broad formatting commits be filtered reliably in
  each stack?

## Notable Quotes

> "This is team data, not code data."

## Takeways

- Run git history diagnostics before wandering through source files.
- Treat overlap between churn, bugs, ownership gaps, and crisis commits as the
  strongest signal.
- Use the output to decide what to read first, not as a substitute for reading
  code and asking the team what is actually happening.
