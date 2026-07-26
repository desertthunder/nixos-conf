# Motion Design

Use motion to explain state, continuity, hierarchy, or material. A still
interface should remain complete and understandable.

## Choose duration and easing by purpose

Useful starting ranges:

- 100–150ms for press and immediate feedback;
- 150–250ms for product UI state changes;
- 200–300ms for menus, tooltips, and compact overlays;
- 300–500ms for larger layout changes;
- 500–800ms for deliberate display entrances.

Make exits shorter and quieter than entrances. Use exponential ease-out for
elements entering, ease-in for leaving, and ease-in-out for reversible state
changes. Avoid bounce and elastic easing unless the brief explicitly requires
that character.

## Keep interaction interruptible

Use CSS transitions or spring systems for states that can reverse mid-flight.
Reserve keyframes for one-shot sequences. Specify the properties:

```css
.control {
  transition:
    scale 150ms cubic-bezier(0.25, 1, 0.5, 1),
    background-color 150ms cubic-bezier(0.25, 1, 0.5, 1);
}

.control:active {
  scale: 0.96;
}
```

Specify transition properties instead of using `transition: all`.

## Choreograph entrances

Split a meaningful entrance into semantic groups and stagger them by roughly
50–100ms. Cap the total delay. Do not replay the same reveal on every section.
Product UI usually loads directly into the task and should skip page-load
choreography.

For contextual icon swaps, keep layout stable and cross-fade with opacity,
scale, and a small blur. Use an existing motion library when present. A single
effect does not justify a new dependency. Disable initial enter animation for
controls whose default state should appear on load.

Transform and opacity are dependable, but blur, clip paths, masks, shadow, and
color can support a specific direction. Bound expensive effects to small areas
and verify smoothness on the target devices.

## Respect reduced motion

Use `prefers-reduced-motion`. Replace spatial movement with a short crossfade or
remove it. Preserve functional feedback such as progress and focus.

## Protect performance

- Animate transform, opacity, and bounded filter effects when possible.
- Avoid casual animation of width, height, top, left, and margins.
- Use Intersection Observer instead of scroll handlers for triggered motion.
- Add `will-change` only when a measured first-frame stutter justifies the
  memory cost; remove it after the animation when practical.
- Test interruption, repeated input, and low-powered devices.
