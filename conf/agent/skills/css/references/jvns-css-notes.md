# Notes from Julia Evans CSS posts

Sources:

- https://jvns.ca/blog/2026/05/15/moving-away-from-tailwind--and-learning-to-structure-my-css-/
- https://jvns.ca/blog/2026/05/04/css-colour-palettes/

## Structuring vanilla CSS

The useful parts to borrow from Tailwind are the constraints, not the class names:

- a reset stylesheet
- a shared color palette
- a font scale
- small, carefully chosen utilities
- component-scoped CSS files
- a tiny base stylesheet
- spacing rules that live mostly in layout containers
- flexible grid layouts before reaching for media queries
- optional bundling with standards-based CSS imports and nesting

Component CSS should be easy to reason about. Each component gets a unique class,
usually a block class, and one component's CSS should not override another
component's CSS. A good target is: editing one component file should not create
surprising changes elsewhere.

Base styles should start small. Add shared styles bottom-up after seeing the same
need in several components.

Spacing is easier to maintain when outer layout components own the gaps. Use
patterns like the owl selector for vertical rhythm instead of scattering margins
on every child.

Responsive design can often use CSS grid instead of breakpoint-heavy rules. Reach
for `auto-fit`, `minmax()`, `min()`, `max-content`, and `grid-template-areas`
when they make the layout express the content better.

## Color palettes

A shared palette helps when choosing colors is not the focus of the work. Keep
all site colors in one palette file and reference them through custom
properties.

Named palettes and tools mentioned in the source post:

- uchu
- flexoki
- reasonable colors
- Web Awesome
- Radix
- US Web Design System
- Material Design
- harmonizer
- tints.dev
- coolors
- colorpalette.pro
- colorhexa
- OKLCH / `oklch()`

Prefer accessible palettes when available. For generated palettes, verify
contrast and states instead of trusting the generated result.
