# Reasonable Colors reference

Source: <https://github.com/matthewhowell/reasonable-colors>

Use `references/reasonable-colors.css` for the full CSS variable palette.

## Naming

Variables use:

```css
--color-COLORNAME-SHADE
```

Color names:

```text
gray,
rose, raspberry, red, orange, cinnamon, amber, yellow, lime,
chartreuse, green, emerald, aquamarine, teal, cyan, powder, sky,
cerulean, azure, blue, indigo, violet, purple, magenta, pink
```

Shades: `1`, `2`, `3`, `4`, `5`, `6`.

## Contrast heuristic

Minimum contrast can be inferred by shade-number difference:

- Difference of 2: about 3:1
- Difference of 3: about 4.5:1
- Difference of 4: about 7:1

## Usage

```css
@import "references/reasonable-colors.css";

:root {
  --surface: var(--color-gray-1);
  --text: var(--color-gray-6);
  --muted: var(--color-gray-4);
  --accent: var(--color-blue-4);
  --accent-bg: var(--color-blue-1);
}
```

For readable pairs, choose shades separated by at least 3 for normal text, or at least 4 when you need stronger contrast.
