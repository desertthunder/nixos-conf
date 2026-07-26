# Color and Contrast

Build color around roles derived from the project.

## Build a functional palette

Prefer a perceptual color space such as OKLCH. When changing lightness, reduce
chroma near white and black so colors do not become harsh.

Define the roles the interface needs:

- primary or accent;
- neutral text and surfaces;
- semantic success, error, warning, and information;
- surface or elevation levels.

Tint neutrals toward the project's palette instead of defaulting to pure gray.
Add secondary and tertiary accents when they have a clear role. Accent
color gains meaning through restraint.

Use primitive tokens for values and semantic tokens in components:

```css
:root {
  --teal-600: oklch(52% 0.11 190);
  --color-action: var(--teal-600);
  --color-text: oklch(22% 0.01 190);
  --color-surface: oklch(98% 0.006 190);
}
```

## Meet contrast requirements

- Body and placeholder text: at least 4.5:1.
- Large text: at least 3:1.
- Icons, focus indicators, and meaningful component boundaries: at least 3:1
  against adjacent colors.
- Pair color with text, shape, or an icon when communicating status.

Gray text usually looks weak on a colored surface. Derive secondary text from
the surface hue or foreground instead. Verify contrast with a tool.

## Design dark mode

Build a separate dark palette.

- Use dark tinted surfaces instead of pure black.
- Show elevation with lighter surfaces; shadows contribute little on dark
  backgrounds.
- Reduce accent chroma when it becomes fluorescent.
- Recheck font weight because light text appears heavier.
- Redefine semantic tokens and keep primitives stable.

Choose light or dark from the use scene: who uses the interface, where, and
under what ambient light. Do not choose from the product category.

## Use transparency

Alpha colors depend on whatever sits behind them and can produce inconsistent
contrast. Prefer explicit surface colors for stable UI. Transparency remains
useful for overlays, focus rings, and effects whose relationship to the
background is intentional.

Test color-blind modes, placeholders, disabled controls, charts, and focus
states in both themes.
