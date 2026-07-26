---
name: frontend-design
description: Create, redesign, review, and polish production frontend interfaces. Use for websites, landing pages, dashboards, app shells, components, forms, settings, onboarding, empty states, responsive layouts, visual hierarchy, typography, color, spacing, motion, interaction states, accessibility, UX copy, or requests to make a UI feel distinctive, coherent, bolder, quieter, clearer, or less generic.
---

# Frontend Design

Create working interfaces with a clear point of view, strong usability, and
polished details. Match the project's framework and conventions. Improve existing
work without replacing its identity unless the user asks for a redesign.

## References

Read only the files needed for the task:

- `references/typography.md`: type selection, hierarchy, wrapping, font loading,
  and numeric alignment.
- `references/color-and-contrast.md`: palettes, semantic tokens, dark mode, and
  contrast.
- `references/spatial-design.md`: spacing, grids, hierarchy, surfaces, radii,
  shadows, and optical alignment.
- `references/motion-design.md`: timing, easing, enter and exit motion,
  reduced-motion behavior, and animation performance.
- `references/interaction-design.md`: states, focus, forms, overlays, loading,
  destructive actions, and hit areas.
- `references/responsive-design.md`: content-driven breakpoints, input modes,
  container queries, safe areas, and responsive media.
- `references/ux-writing.md`: labels, errors, empty states, terminology,
  translation, and accessible copy.

Read all seven for a broad build or review.

## Establish the direction

Before editing:

1. Inspect the target and one representative source of visual truth: tokens,
   theme, stylesheet, component, brand asset, or existing screen.
2. Identify the surface mode:

   | Mode       | Typical surfaces                 | Priority                        |
   | ---------- | -------------------------------- | ------------------------------- |
   | Persuade   | Marketing, campaigns, pricing    | Attention, trust, action        |
   | Operate    | Dashboards, settings, editors    | Task completion and scanability |
   | Read       | Documentation, articles, guides  | Comprehension and wayfinding    |
   | Experience | Portfolios, galleries, showcases | The work itself                 |

3. Name the purpose, audience, desired action or task, constraints, and the one
   visual idea that should remain memorable.
4. Decide whether to preserve, extend, or replace the existing visual system.
   A local component change inherits its surrounding system.

Ask for missing information when it would change the result.
Do not ask the user to choose arbitrary CSS values or canned style labels.

## Choose a direction

- Let the brief and existing product truth outrank personal taste.
- Choose a coherent direction instead of collecting fashionable effects.
- Derive visual choices from the subject, audience, content, and use scene.
- Match expression to the surface mode. Product UI may benefit from familiar
  patterns and system fonts; a campaign may need stronger art direction.
- Use real content and assets when available. Label illustrative data.
  Never invent customers, prices, benchmarks, capabilities, or factual claims.
- Preserve semantics, accessibility, responsiveness, performance, and working
  behavior.
- Match implementation complexity to the direction.

## Avoid reflex design

Avoid these defaults when the brief leaves the choice open:

- generic hero plus evenly sized feature-card grids;
- cards used as the default grouping device or cards nested inside cards;
- purple-blue gradients, gradient text, decorative glass, or neon glows;
- gray text on colored backgrounds;
- pure black and untinted gray used as the whole palette;
- rounded-square icon tiles above every heading;
- tracked uppercase eyebrows repeated across every section;
- monospace used as a costume for technical products;
- category-default font choices with no project-specific reason;
- identical entrance animations on every section;
- bounce or elastic easing;
- decoration that obscures tasks, state, hierarchy, or copy.

Use one when the brief gives you a reason.

## Implement and verify

- Implement real behavior. Controls must work.
- Cover relevant default, hover, focus, active, disabled, loading, error, empty,
  and success states.
- Make the first viewport communicate the surface's purpose within seconds.
- Use spacing, alignment, type, and content before adding containers.
- Keep one component vocabulary across the surface.
- Use one authored motion idea when motion helps. Keep product motion short and
  state-driven.
- Test real copy at narrow and wide widths. Fix overflow rather than hiding it.
- Compose for mobile instead of shrinking the desktop layout.
- Keep interactive targets at least 44 by 44 CSS pixels when practical.

Inspect the rendered result once at representative desktop and mobile sizes.
Check:

- the request and required behavior are covered;
- hierarchy remains clear when squinting at the page;
- text, controls, headings, and body measure remain readable;
- controls expose keyboard focus and all important states;
- overlays escape clipping and remain within the viewport;
- no horizontal overflow or touch-only/hover-only dead ends remain;
- motion respects `prefers-reduced-motion`;
- the result matches the chosen direction and product truth.

Fix findings together, then confirm once.

Do not spend unbounded rounds polishing minor details.

## Self-update

Update this skill when repeated frontend work reveals a durable design or
verification rule. Keep workflow rules here and domain guidance in the relevant
reference. Exclude one-off preferences, framework boilerplate, command suites,
and temporary trends.
