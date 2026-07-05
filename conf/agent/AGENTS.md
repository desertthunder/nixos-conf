# AGENT Guide

## Code Quality

- Don't make documentation too verbose. ~80ch width (save for tables,
  footnotes & links - which should be single, long lines, which can be long) and
  ~200-250 lines is good before considering if it can be reworded or split up.

---

- Prefer simple over complex and follow the rule of three for refactoring/abstracting.
  For helpers, let's not needlessly recycle code and use shared helpers when we can.
  - Inline helpers that have only one call site.
- Avoid inline or function-scoped imports

## Git

Git in general should be read-only.

Multiple actors may be running in this cwd at the same time, each modifying different files.
Only focus (run diffs for example) on files you've touched.
