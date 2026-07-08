---
name: notetaking
description: >
  Convert Markdown, articles, and web pages into concise, reviewable notes that
  preserve the source’s thesis, key claims, evidence, concepts, and open questions.
---

Use this skill to turn Markdown, web pages, articles, or document text into
concise, useful notes that preserve the source's main ideas and make them
reviewable later.

The goal is not to summarize everything. Capture what is worth remembering,
questioning, and reusing.

Regardless of the project you're asked to use this skill in, focus on the source
content. Do not force connections back to the current repository unless the user
asks for that.

## Core rules

1. **Capture the thesis.** Identify the source's central point in one sentence.
2. **Extract important claims.** Record what the author says, what supports it,
   and any caveats.
3. **Prefer paraphrase over copying.** Use quotes only when exact wording matters.
4. **Make notes reviewable.** Generate active-recall questions for important
   ideas.
5. **Preserve provenance.** Keep source URL, title, author, date, and section
   references when available. When notes are based on URL sources, write
   `Source` as a YAML list of URLs.
6. **Separate fact, inference, and uncertainty.** Do not mix source claims with
   your synthesis.

## Output format

```markdown
---
title: <title>
sources:
  - <url>
  - <url>
author: author if available
Date: published/updated date if available, if not: captured
captured: capture date, optional
tags: 
  - <tag>
  - <tag>
---

## Summary

<One sentence explaining the source's main point.>

## Key Ideas

- **<Idea 1>:** <Plain-language explanation.>
- **<Idea 2>:** <Plain-language explanation.>
- **<Idea 3>:** <Plain-language explanation.>

## Claims & Evidence

### <claim>

<support: evidence, example, reasoning>

<caveat/confidence: high, medium, or low>

## Important Terms

| Term     | Meaning                       |
| -------- | ----------------------------- |
| `<term>` | `<plain-language definition>` |

## Questions for Review

- <Question that tests recall of the main thesis?>
- <Question that tests understanding of a key mechanism?>
- <Question that asks how the idea applies?>
- <Question that asks when the idea might fail?>

## Connections

- Related ideas:
- Related sources:
- Contradictions or tensions:
- Useful applications:

## Open Questions

- <Question the source does not answer>
- <Claim that needs verification>
- <Follow-up research direction>

## Notable Quotes

> "<short quote only if worth preserving>"

## Takeaways

- <Most important takeaway>
- <Second takeaway>
- <Third takeaway>
```

## Procedure

1. Read the title, metadata, headings, and conclusion first.
2. Identify the source type: tutorial, opinion, research, reference,
   announcement, or essay.
3. Extract the central thesis.
4. Capture only the strongest ideas, claims, terms, and examples.
5. Add caveats where support is weak or missing.
6. Generate review questions that require recall or explanation.
7. End with three compressed takeaways.

## Quality checklist

A good note should answer:

- What is this source mainly saying?
- What are the most important ideas?
- What claims does it make?
- What evidence supports those claims?
- What terms or concepts matter?
- What should I be able to recall later?
- What remains uncertain?
- Where can this connect to other knowledge?

## Avoid

- Long generic summaries.
- Copying large passages.
- Capturing every detail.
- Treating unsupported claims as facts.
- Mixing source claims with interpretation.
- Creating shallow yes/no questions.
- Losing the source URL or metadata.

## Self-update

This is a living skill. When a notetaking session reveals a reusable lesson,
update this `SKILL.md` or add a reference file with the smallest rule that would
improve future notes.

Update when:

- the user asks for a recurring note structure change;
- notes miss an important source detail, caveat, or provenance field;
- review questions are too shallow or too numerous;
- a better template or metadata convention proves useful repeatedly;
- the distinction between source claims and synthesis needs to be clearer.

Do not add one-off preferences from a single source. Keep updates concrete and
focused on note quality.
