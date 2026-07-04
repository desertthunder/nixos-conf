---
name: css
description: Write, refactor, and review well-structured vanilla CSS. Use when replacing utility CSS, organizing stylesheets, naming component classes, defining tokens, choosing accessible colours, or improving CSS architecture without a utility-first framework.
---

# CSS

Use this skill when writing or refactoring plain CSS. The goal is CSS that is
boring to maintain: semantic HTML, named components, explicit tokens, flexible
layouts, and small files with clear responsibilities.

This skill consolidates the local CSS notes with the former `styling-with-css`
skill.

## References

Read these when the task needs more detail:

- `references/jvns-css-notes.md`: source notes from Julia Evans on moving away
  from Tailwind and structuring CSS.
- `references/structure.md`: file responsibilities, component rules, spacing,
  responsive layout, and build notes.
- `references/colors.md`: Reasonable Colors usage and contrast heuristics.
- `references/reasonable-colors.css`: full Reasonable Colors variables.

## Default approach

1. Start with semantic HTML.
2. Add classes as styling hooks, not as property descriptions.
3. Put shared design decisions in CSS custom properties.
4. Put most styling in component files.
5. Keep reset, base, and utilities small.
6. Let parent layout containers own spacing.
7. Prefer grid, intrinsic sizing, and container/media queries over breakpoint
   sprawl.
8. Use a build step only when it earns its keep.

## File structure

Start with this shape and adapt only when the project demands it:

```text
styles/
  style.css
  reset.css
  base.css
  utilities.css
  tokens/
    colors.css
    type.css
    spacing.css
  components/
    card.css
    site-header.css
```

`style.css` should compose the system in this order:

```css
@import "reset.css";
@import "tokens/colors.css";
@import "tokens/type.css";
@import "tokens/spacing.css";
@import "base.css";
@import "utilities.css";
@import "components/card.css";
```

A smaller project can use one `tokens.css` file instead of a `tokens/`
directory. Native CSS imports and nesting are fine during development. Bundle
for production only if needed.

## Layers of responsibility

- **Reset:** Known browser baseline, including `box-sizing: border-box`, sensible
  line height, form normalization, and accessibility defaults.
- **Tokens:** Colours, type, spacing, radii, shadows, and z-index values.
- **Base:** Site-wide element rules you truly want everywhere.
- **Utilities:** Rare helpers such as `.sr-only`, `.stack`, or `.cluster`.
- **Components:** Most CSS. Each component gets one root class and one file.
- **Layouts:** Parent containers arrange children and own spacing.

## Component naming

Use BEM-style naming when it helps clarity. Treat it as a convention, not
ceremony.

```html
<article class="card card--featured">
  <h2 class="card__title">Title</h2>
  <p class="card__summary">Summary text</p>
</article>
```

```css
.card {
  display: grid;
  gap: var(--space-3);
  padding: var(--space-4);
  color: var(--text);
  background: var(--surface);
}

.card__title {
  font-size: var(--size-lg);
  line-height: var(--line-lg);
}

.card--featured {
  border: 2px solid var(--accent);
}
```

Rules:

- Block: `.card`, `.site-header`, `.zine-list`.
- Element: `.card__title`, `.site-header__nav`.
- Modifier: `.card--featured`, `.site-header--compact`.
- Do not chain unrelated blocks, such as `.sidebar .card`, unless a layout
  component is intentionally arranging its children.
- Avoid appearance-only names such as `.blue-box` or `.big-text` unless they are
  true utilities.
- Nested CSS is fine when it stays inside the component root.

## Tokens and colour

Keep repeated values in tokens. Use semantic aliases in components.

```css
:root {
  --surface: var(--color-gray-1);
  --surface-raised: white;
  --text: var(--color-gray-6);
  --muted: var(--color-gray-4);
  --accent: var(--color-blue-4);
  --accent-bg: var(--color-blue-1);

  --size-base: 1rem;
  --line-base: 1.5rem;
  --size-lg: 1.125rem;
  --line-lg: 1.75rem;

  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;

  --radius-md: 0.5rem;
}
```

When colour design is not the task, use a known palette. Prefer Reasonable
Colors by default in this skill. For readable text/background pairs, choose
shade differences of at least 3, or at least 4 for stronger contrast.

Check text, focus, hover, active, disabled, visited, and dark-mode states when
those states exist.

## Base and utilities

Keep `base.css` small:

```css
body {
  margin: 0;
  font-family: system-ui, sans-serif;
  color: var(--text);
  background: var(--surface);
}

a {
  color: var(--accent);
}
```

Move repeated component styles into base only after the repetition is clear.

Keep utilities few and stable. Good utilities are generic, accessible, and used
across components. Avoid recreating a utility framework one class at a time. If
`utilities.css` keeps growing, move styles back into components or tokens.

## Layout and spacing

Let layout containers own spacing where possible.

```css
.section {
  --inner-width: 60rem;
  padding: var(--space-6) max(var(--space-4), (100% - var(--inner-width)) / 2);
}

.stack > * + * {
  margin-block-start: var(--space-4);
}
```

For responsive layouts, try grid before adding breakpoints.

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 20rem), 1fr));
  gap: var(--space-6);
}
```

Use media or container queries when the design actually changes at a breakpoint.
Do not add breakpoints just to copy a framework pattern.

## Refactoring workflow

1. Identify the semantic structure of the HTML.
2. Choose block classes for the main components.
3. Move scattered utility classes into component CSS.
4. Extract repeated values into tokens.
5. Put shared spacing on layout containers.
6. Replace breakpoint-heavy layout rules with grid or intrinsic sizing when it is
   clearer.
7. Check that editing a component file cannot restyle unrelated components.
8. Remove unused classes and duplicated declarations.

## Review checklist

- Does every component have one clear block class?
- Are element and modifier names tied to the component they belong to?
- Are colours, type, sizes, and spacing tokenized?
- Is `base.css` still small?
- Are utilities genuinely shared and generic?
- Are margins owned by layout containers where possible?
- Could grid, `minmax()`, `auto-fit`, or `grid-template-areas` remove media
  queries?
- Are focus, hover, active, disabled, and visited states covered where needed?
- Is the CSS easy to delete when the component is deleted?

## Self-update

This is a living skill. When CSS work reveals a reusable lesson, update this
`SKILL.md` or its references with the smallest rule that would prevent the same
issue next time.

Update when:

- a file structure, naming rule, or token pattern works repeatedly;
- a rule causes awkward CSS and should be softened;
- a palette, contrast rule, or accessibility check catches a real issue;
- a refactor exposes a better way to separate base, utilities, layouts, and
  components;
- the user corrects the preferred CSS style.

Keep updates project-local, concrete, and free of one-off page details.
