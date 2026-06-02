---
name: css
description: Write and refactor well-structured vanilla CSS using BEM-style component classes, CSS custom properties, small utilities, semantic HTML, accessible colour palettes, and flexible layouts. Use when replacing utility CSS, organizing stylesheets, naming classes, or reviewing CSS architecture.
---

# Vanilla CSS

Use this skill when writing or refactoring plain CSS. The goal is CSS that is
boring to maintain: named components, predictable files, shared tokens, and few
surprises across the site.

Read `references/jvns-css-notes.md` for the source notes behind this approach.

## Principles

- Use semantic HTML first. Add classes for styling hooks, not to describe every
  property applied to the element.
- Organize most CSS by component. A component has one block class and one file.
- Keep components isolated by convention: a component stylesheet should not reach
  into unrelated components.
- Put design choices in custom properties: colours, font sizes, line heights,
  spacing steps, radii, shadows, and z-index values.
- Start with a reset, a palette, a type scale, a tiny base file, component files,
  and a small utilities file.
- Prefer plain CSS features before a framework: imports, nesting, custom
  properties, grid, container queries, cascade layers, and scope when available.
- Use a build step only when it earns its keep. Native CSS imports and nesting are
  fine during development; bundling for production is optional.

## Suggested file structure

```text
styles/
  main.css
  reset.css
  tokens.css
  base.css
  utilities.css
  components/
    card.css
    site-header.css
    zine-list.css
```

`main.css` imports files in this order:

```css
@import "reset.css";
@import "tokens.css";
@import "base.css";
@import "utilities.css";
@import "components/card.css";
@import "components/site-header.css";
```

## BEM-style naming

Use BEM as a naming convention, not as ceremony.

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
  border-radius: var(--radius-md);
  background: var(--color-surface);
}

.card__title {
  font-size: var(--size-lg);
  line-height: var(--line-height-lg);
}

.card__summary {
  color: var(--color-text-muted);
}

.card--featured {
  border: 2px solid var(--color-accent);
}
```

Rules:

- Block: `.card`, `.site-header`, `.zine-list`.
- Element: `.card__title`, `.site-header__nav`.
- Modifier: `.card--featured`, `.site-header--compact`.
- Do not chain unrelated blocks, such as `.sidebar .card`, unless the layout
  component is intentionally arranging its children.
- Avoid class names based on appearance alone, such as `.blue-box` or
  `.big-text`, unless they are true utilities.

## Tokens

Keep shared values in `tokens.css`.

```css
:root {
  --color-text: #1f1f1f;
  --color-text-muted: #666;
  --color-surface: #fff;
  --color-accent: #de751f;

  --size-sm: 0.875rem;
  --line-height-sm: 1.25rem;
  --size-base: 1rem;
  --line-height-base: 1.5rem;
  --size-lg: 1.125rem;
  --line-height-lg: 1.75rem;

  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
  --space-8: 2rem;

  --radius-md: 0.5rem;
}
```

Guidelines:

- All colours used on the site should be listed in one palette file.
- Use a known palette when colour design is not the task. Good candidates include
  uchu, flexoki, reasonable colours, Radix, the US Web Design System, and
  Material Design.
- Check contrast for text, focus states, hover states, disabled states, and dark
  mode if present.
- Use OKLCH only when it makes the palette easier to reason about or generate.

## Base styles

Keep `base.css` small. It can set document-wide defaults and plain element
styles that are safe everywhere.

```css
html {
  line-height: 1.5;
}

body {
  margin: 0;
  font-family: system-ui, sans-serif;
  color: var(--color-text);
  background: var(--color-surface);
}

a {
  color: var(--color-accent);
}
```

Move repeated component styles into base only after the repetition is clear.

## Layout and spacing

Let layout containers own spacing where possible.

```css
.section {
  --inner-width: 60rem;
  padding: var(--space-8) max(var(--space-4), (100% - var(--inner-width)) / 2);
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

Use media queries when the design actually changes at a breakpoint. Do not add
breakpoints just to copy a framework pattern.

## Utilities

Keep utilities few and stable. Good utilities are generic, accessible, and used
across components.

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

Avoid recreating a full utility framework one class at a time. If the utilities
file keeps growing, move styles back into components or tokens.

## Refactoring workflow

1. Identify the semantic structure of the HTML.
2. Choose block classes for the main components.
3. Move scattered utility classes into component CSS.
4. Extract repeated values into tokens.
5. Put shared spacing on layout containers.
6. Replace breakpoint-heavy layout rules with grid or intrinsic sizing when it is
   clearer.
7. Check that editing a component file cannot accidentally restyle unrelated
   components.
8. Remove unused classes and duplicated declarations.

## Review checklist

- Does every component have one clear block class?
- Are element and modifier names tied to the component they belong to?
- Are colours, sizes, and spacing values tokenized?
- Is `base.css` still small?
- Are utilities genuinely shared and generic?
- Are margins owned by layout containers where possible?
- Could grid, `minmax()`, `auto-fit`, or `grid-template-areas` remove media
  queries?
- Are focus, hover, active, disabled, and visited states covered where needed?
- Is the CSS easy to delete when the component is deleted?
