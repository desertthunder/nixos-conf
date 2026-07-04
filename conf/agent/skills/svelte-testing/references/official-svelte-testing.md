# Official Svelte testing notes

Source reviewed: <https://svelte.dev/docs/svelte/testing> and
<https://svelte.dev/docs/svelte/faq#How-do-I-test-Svelte-apps>
Captured: 2026-07-04

## Core stance

Svelte is unopinionated about test frameworks. Pick the smallest test that gives
useful confidence:

- **Unit tests:** functions, state helpers, data transforms, validation, and edge
  cases. Extract logic out of components when possible.
- **Component tests:** compiled Svelte components mounted into a DOM, either
  simulated with jsdom or real through browser tooling.
- **E2E tests:** user workflows against the whole app, as close to production as
  practical.

Do not test Svelte's own implementation details. Svelte has its own test suite.
Test your behavior and contracts.

## Vitest setup for Vite/SvelteKit

For Vite projects, including SvelteKit, Svelte recommends Vitest. Use the Svelte
CLI to add it when possible, or install manually:

```sh
npm install -D vitest
```

When Vitest needs browser package entry points while running in Node, import from
`vitest/config` and enable browser conditions only during Vitest runs:

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  resolve: process.env.VITEST
    ? {
        conditions: ["browser"],
      }
    : undefined,
});
```

If browser entry points for all packages are undesirable because the same config
also runs backend tests, use a narrower alias/configuration instead of blindly
forcing browser conditions everywhere.

## Runes in tests

Vitest processes test files like source files. If a test file uses runes directly,
its filename must include `.svelte`, such as `counter.svelte.test.ts`.

Use `flushSync` when pending state/effects must be observed synchronously. If the
code under test uses `$effect`, run the test body inside `$effect.root` and call
the returned cleanup function.

## jsdom component tests

Use jsdom when a simulated DOM is enough:

```sh
npm install -D jsdom
```

```ts
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    environment: "jsdom",
  },
  resolve: process.env.VITEST
    ? {
        conditions: ["browser"],
      }
    : undefined,
});
```

If only some tests need DOM APIs, prefer `// @vitest-environment jsdom` at the
top of those files rather than making the whole suite jsdom.

Direct mounting with Svelte's `mount`, `unmount`, and `flushSync` works, but it
can be brittle if tests assert exact HTML structure. Prefer user-visible behavior
when possible.

## Testing Library component tests

`@testing-library/svelte` is useful for user-visible component tests. Prefer
accessible queries such as role, label, or text. Await user interactions.

For two-way bindings, context, or snippet props, create a small wrapper component
for the test and interact with the wrapper through the DOM.

## Storybook component tests

Storybook can test component stories with Vitest browser mode. Use the Svelte CLI
via `npx sv add storybook` when adding Storybook to a project. Interaction tests
belong in story `play` functions and use Testing Library/Vitest APIs.

Use Storybook tests when component variants and interactive documentation already
matter. Do not add Storybook only to test one small component.

## Playwright E2E tests

E2E tests should be framework-agnostic: navigate, interact with the DOM, and make
assertions from the user's point of view.

For SvelteKit/Vite apps, the Playwright config usually needs to build and start a
preview server before tests:

```ts
const config = {
  webServer: {
    command: "npm run build && npm run preview",
    port: 4173,
  },
  testDir: "tests",
  testMatch: /(.+\.)?(test|spec)\.[jt]s/,
};

export default config;
```

Use E2E for critical flows, routing, auth, form submissions, and integration
behavior that smaller tests cannot prove.
