# Sveltest notes

Source reviewed: <https://sveltest.dev/> and
<https://sveltest.dev/docs/getting-started>
Captured: 2026-07-04

## What Sveltest is

Sveltest is a reference guide and example project for modern Svelte testing. It
is not a package you install into an app. Learn from its examples and adapt the
patterns to the project under test.

Sveltest focuses on Svelte 5 testing with `vitest-browser-svelte`, real browser
component tests, and a client-server alignment strategy for SvelteKit apps.

## When to use these patterns

Reach for Sveltest guidance when:

- jsdom feels too synthetic for the component behavior;
- focus, browser events, visibility, or user interactions matter;
- migrating away from `@testing-library/svelte`/jsdom component tests;
- testing SvelteKit client and server behavior that must stay aligned;
- looking for examples of forms, actions, SSR, server tests, remote functions,
  context, stores, runes, or E2E flows.

## Browser-mode setup

The documented setup uses the Svelte CLI to create a SvelteKit project with
Vitest and Playwright, then adds Vitest browser dependencies:

```sh
pnpm dlx sv@latest create my-testing-app
pnpm install -D @vitest/browser-playwright vitest-browser-svelte playwright
```

For projects migrating to browser-mode component tests, remove jsdom/Testing
Library dependencies only if they are no longer used:

```sh
pnpm un @testing-library/jest-dom @testing-library/svelte jsdom
```

Do not remove existing test dependencies blindly. First inspect the test suite.

## Multi-project Vitest shape

Sveltest's recommended shape separates client, SSR, and server tests:

- **client:** browser mode, `vitest-browser-svelte`, Svelte component tests;
- **ssr:** Node environment, `*.ssr.test.ts` / `*.ssr.spec.ts` files;
- **server:** Node environment, non-component tests, excluding Svelte and SSR
  test files.

Important client settings:

```ts
import { playwright } from "@vitest/browser-playwright";
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    projects: [
      {
        extends: "./vite.config.ts",
        test: {
          name: "client",
          testTimeout: 2000,
          browser: {
            enabled: true,
            provider: playwright(),
            instances: [{ browser: "chromium" }],
          },
          include: ["src/**/*.svelte.{test,spec}.{js,ts}"],
          exclude: ["src/lib/server/**", "src/**/*.ssr.{test,spec}.{js,ts}"],
          setupFiles: ["vitest-browser-svelte"],
        },
      },
    ],
  },
});
```

`setupFiles: ['vitest-browser-svelte']` is the official setup entry for the
browser helpers and cleanup. If TypeScript does not pick up browser render and
assertion types, add `vitest-browser-svelte` to `compilerOptions.types`.

## Client-server alignment strategy

Sveltest's main SvelteKit testing idea is to keep client and server contracts in
sync:

1. Share validation logic between client and server.
2. Use real `FormData` and `Request` objects in server tests.
3. Share TypeScript contracts for data shapes.
4. Keep an E2E test as the final integration safety net.

Avoid heavy mocks that hide real mismatches. Mock external services and process
boundaries; prefer real web primitives for SvelteKit form/action/request logic.

## Browser test style

Use `render` from `vitest-browser-svelte` and `page` from `vitest/browser`:

```ts
import { page } from "vitest/browser";
import { describe, expect, it } from "vitest";
import { render } from "vitest-browser-svelte";
import Page from "./+page.svelte";

describe("/+page.svelte", () => {
  it("renders h1", async () => {
    await render(Page);

    const heading = page.getByRole("heading", { level: 1 });
    await expect.element(heading).toBeInTheDocument();
  });
});
```

Always prefer locators over container queries. Locators auto-retry and mirror how
users find UI.

Locator order:

1. semantic roles: `page.getByRole('button', { name: 'Submit' })`;
2. labels: `page.getByLabel('Email address')`;
3. unique text: `page.getByText('Welcome back')`;
4. test IDs as a fallback.

Vitest browser mode is strict. If multiple elements match, use `.first()`,
`.nth(index)`, or `.last()` intentionally.

## Common pitfalls

- SvelteKit enhanced form submit clicks can hang in browser component tests. Test
  form state directly or move the full submission path to an E2E/server test.
- Mock signatures should match real function signatures. Add a mock-verification
  test when mocks are complex.
- Use `createRawSnippet` for Svelte 5 snippet props in component tests.
- Use `flushSync` and, where needed, `untrack` when asserting rune-derived state
  synchronously.

## Examples to consult

- <https://github.com/spences10/sveltest>: source repository.
- <https://sveltest.dev/examples>: overview of unit, integration, E2E, form, and component testing patterns.
  - <https://sveltest.dev/examples/unit>: unit/component examples.
  - <https://sveltest.dev/examples/todos>: SvelteKit form/action examples and live todo app.
- <https://sveltest.dev/todos>: live demo.
