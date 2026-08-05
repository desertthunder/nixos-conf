# Ticket Workflow

Use this reference when splitting a spec or plan into implementation tickets.

## Source gathering

Work from what is already known. If the user provides a spec path, issue number,
or URL, read the full body and comments before drafting tickets.

Inspect the codebase when dependencies, sequencing, or acceptance criteria depend
on existing architecture, tests, or naming.

## Vertical slices

Prefer vertical slices:

- each slice delivers a narrow but complete behavior through the relevant layers;
- each slice is demoable or verifiable on its own;
- each slice fits in one fresh agent context;
- tests verify behavior rather than implementation details.

Avoid horizontal slices that only build one layer, such as all schema work, all
API work, or all UI work, unless that layer-only task is an enabling prefactor.

## Prefactors

Use a prefactor when a small preparatory change makes the main work easier and
safer. It should be independently verifiable and should not smuggle in product
behavior.

## Dependency edges

Every ticket declares its blockers. Blockers should be real gates, not loose
ordering preferences.

Publish or list tickets in dependency order: blockers first.

## Wide refactor exception

For a wide mechanical refactor whose blast radius prevents a green vertical
slice, use expand-contract:

1. Expand: add the new form beside the old without breaking callers.
2. Migrate: move callers in batches sized by blast radius.
3. Contract: remove the old form after every migration batch is complete.

If migration batches cannot stay green alone, use a shared integration branch
and add a final integrate-and-verify ticket.

## Approval loop

Before writing final tickets, ask the user to confirm:

- granularity: too coarse, too fine, or right-sized;
- dependency edges: only genuine blockers;
- merges or splits: any tickets to combine or break apart.

Limit this loop to two revision passes unless the user explicitly asks for more.

## Sources

- Matt Pocock skills, `to-tickets`:
  https://github.com/mattpocock/skills
