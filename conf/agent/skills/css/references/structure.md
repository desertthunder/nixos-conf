# CSS structure reference

Source distilled from Julia Evans, “Moving away from Tailwind, and learning to structure my CSS” (2026-05-15): <https://jvns.ca/blog/2026/05/15/moving-away-from-tailwind--and-learning-to-structure-my-css-/>

## Core idea

Replace utility-first sprawl with semantic HTML and small CSS systems. Keep the parts Tailwind makes useful—reset, palette, type scale, constraints—but own them explicitly in vanilla CSS.

## Recommended stylesheet layout

```css
@import "reset.css";
@import "tokens/colors.css";
@import "tokens/type.css";
@import "base.css";
@import "utilities.css";
@import "components/card.css";
@import "components/site-header.css";
```

Use native CSS imports during development. Bundle for production only if needed, for example with esbuild.

## Layers of responsibility

1. **Reset**: start from a known baseline. Include `box-sizing: border-box`, sensible line-height, form normalization, and accessibility defaults.
2. **Tokens**: define all colors, font sizes, line heights, spacing, radii, and shadows as variables. Do not scatter raw values through components.
3. **Base**: keep tiny. Only site-wide element styles you are confident should apply everywhere, such as link color or a default centered section wrapper.
4. **Utilities**: keep tiny and stable. Use for cross-cutting one-off helpers such as `.sr-only`, not as a replacement for component CSS.
5. **Components**: put most CSS here. Each component gets one unique root class and its own file.
6. **Layouts**: let parent layout components own spacing between children where possible.

## Component rules

- Each component has one unique root class, for example `.zine`, `.pricing-card`, `.site-header`.
- Component CSS should not override another component’s internals.
- Prefer nested selectors under the root class:

```css
.zine {
  display: grid;

  &.horizontal { /* variant */ }
  &.vertical { /* variant */ }
  &:hover { /* interaction */ }

  img { max-width: 100%; }
}
```

- If a style needs to be shared, promote it deliberately to tokens, base, utilities, or a layout primitive.

## Spacing

Prefer parent-owned spacing over children with arbitrary outer margins.

```css
.stack > * + * {
  margin-block-start: var(--space-4);
}
```

Use layout primitives such as `.stack`, `.cluster`, `.switcher`, or component-specific parent rules before adding margins to every child.

## Responsive design

Reach for flexible layout before breakpoints. CSS Grid often removes the need for media queries.

```css
.grid-auto {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 400px), 1fr));
  gap: var(--space-6);
}
```

Use `grid-template-areas` when named regions make the layout clearer. Add media/container queries only when layout rules cannot express the behavior naturally.

## Type scale

Define font sizes and line heights once, then consume variables.

```css
:root {
  --size-sm: 0.875rem;
  --line-sm: 1.25rem;
  --size-base: 1rem;
  --line-base: 1.5rem;
  --size-lg: 1.125rem;
  --line-lg: 1.75rem;
}

h3 {
  font-size: var(--size-lg);
  line-height: var(--line-lg);
}
```

## Build system

Prefer standards-first CSS: imports, nesting, custom properties, grid. If production bundling is necessary, keep it boring and deterministic:

```sh
esbuild style.css --bundle --loader:.svg=dataurl --loader:.woff2=file --outfile=dist/style.css
```
