---
name: svelte-testing
description: >
  Test Svelte and SvelteKit applications. Use when writing, reviewing, or configuring
  unit tests, component tests, browser/component tests, SSR tests, form action tests,
  server route tests, or end-to-end tests for Svelte apps. Covers Vitest, jsdom,
  @testing-library/svelte, vitest-browser-svelte, Playwright, Storybook tests, and
  Sveltest examples. Biases toward current Svelte docs and Sveltest references.
---

Use this skill when adding, fixing, or reviewing tests in Svelte or SvelteKit projects.
Prefer source-backed guidance and cite the relevant source when explaining testing choices.

## Sources

- Svelte testing docs: https://svelte.dev/docs/svelte/testing
- Svelte testing LLM docs: https://svelte.dev/docs/svelte/testing/llms.txt
- Svelte FAQ, “How do I test Svelte apps?”: https://svelte.dev/docs/svelte/faq#How-do-I-test-Svelte-apps
- Sveltest site: https://sveltest.dev/
- Sveltest getting started: https://sveltest.dev/docs/getting-started
- Sveltest repository: https://github.com/spences10/sveltest

## Reference files

Read these before nontrivial setup or when explaining tradeoffs:

- `references/official-svelte-testing.md`: official Svelte testing guidance for
  Vitest, runes, jsdom, Testing Library, Storybook, and Playwright.
- `references/sveltest.md`: Sveltest's browser-mode and SvelteKit
  client-server alignment patterns.

## Test strategy

Svelte is unopinionated about test frameworks. Choose the smallest test that gives useful confidence:

1. **Unit tests** for extracted business logic, data transformation, validation, state helpers, and edge cases.
2. **Component tests** for component behavior that needs DOM mounting, user interaction, bindings, context, snippets, lifecycle, or accessibility queries.
3. **Server/SvelteKit tests** for endpoints, form actions, hooks, load helpers, and shared client/server contracts. Prefer real `Request`, `FormData`, and validation logic; mock only external systems.
4. **SSR tests** for server-rendered output and hydration-sensitive behavior.
5. **E2E tests** for production-like user flows through the full app.

Do not test Svelte’s own implementation details. If most logic is inside a component, consider extracting it and testing it as plain TypeScript/JavaScript first.

## Vitest setup

For Vite/SvelteKit projects, prefer Vitest for unit and integration tests.

Manual baseline:

```sh
npm install -D vitest
```

In `vite.config.js` or `vite.config.ts`, import from `vitest/config` and, when tests need browser package entry points while running in Node, use browser conditions during Vitest runs:

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

For client-side component tests in jsdom:

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

If only some files need DOM APIs, prefer `// @vitest-environment jsdom` at the top of those test files rather than making all tests jsdom.

## Svelte 5 runes in tests

Vitest can process test files like source files. If using runes directly in a test, name the file with `.svelte`, for example `counter.svelte.test.ts`.

Use `flushSync` when a state update or effect needs to be observed synchronously:

```ts
import { flushSync } from "svelte";
import { expect, test } from "vitest";

test("reactive state", () => {
  let count = $state(0);

  count = 1;
  flushSync();

  expect(count).toBe(1);
});
```

If the code under test uses `$effect`, wrap it in `$effect.root` and call the cleanup function.

## Component tests

For low-level tests, mount directly with Svelte APIs:

```ts
import { flushSync, mount, unmount } from "svelte";
import { expect, test } from "vitest";
import Component from "./Component.svelte";

test("Component", () => {
  const component = mount(Component, {
    target: document.body,
    props: { initial: 0 },
  });

  document.body.querySelector("button")?.click();
  flushSync();

  expect(document.body.querySelector("button")).toHaveTextContent("1");
  unmount(component);
});
```

Prefer Testing Library-style tests when asserting user-visible behavior:

```ts
import { render, screen } from "@testing-library/svelte";
import userEvent from "@testing-library/user-event";
import { expect, test } from "vitest";
import Component from "./Component.svelte";

test("increments", async () => {
  const user = userEvent.setup();
  render(Component);

  const button = screen.getByRole("button");
  await user.click(button);

  expect(button).toHaveTextContent("1");
});
```

When testing two-way bindings, context, or snippet props, create a small wrapper component for the test and interact with that wrapper through the DOM.

## Browser component tests

Use `vitest-browser-svelte` when jsdom is too synthetic and a real browser is worth the cost. Reach for it when testing browser layout/behavior, focus behavior, realistic events, or component flows that should run through Playwright-backed Vitest browser mode.

Sveltest is a reference guide and example project for these patterns, not a package to install. Use its docs and repository examples, then adapt the pattern to the project’s component API rather than copying blindly.

Prefer `page` locators from `vitest/browser` over container queries. Use role, label, text, then test id, in that order. Browser mode is strict; if multiple elements match, use `.first()`, `.nth()`, or `.last()` intentionally.

## SvelteKit server, form, and SSR tests

- Keep shared validation/contract logic importable by both client and server.
- In server tests, prefer real `Request` and `FormData` objects.
- Mock boundaries such as databases, queues, email, network APIs, and auth providers, not your own client/server contract.
- Test endpoint and form-action success, validation failure, authorization failure, and unexpected boundary failure.
- Add SSR tests when markup, metadata, load output, or hydration compatibility matters.

## E2E tests

Use Playwright or an equivalent E2E runner for critical flows. E2E tests should interact with the app as a user would and should not know about Svelte internals.

Typical Playwright config starts the production preview before tests:

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

## Review checklist

- Does the test assert user-visible behavior or stable contracts instead of implementation details?
- Could component-internal logic be extracted and tested faster as a unit test?
- Are DOM tests using accessible queries (`getByRole`, labels, text) where practical?
- Are async interactions awaited?
- Are Svelte updates/effects flushed only when synchronous assertions require it?
- Are browser-mode tests reserved for behavior jsdom cannot model well?
- Do server tests use real web primitives and mock only external boundaries?
- Is at least one E2E test covering the critical happy path?

## Self-update

This is a living skill. When Svelte testing work reveals a reusable lesson,
update this `SKILL.md` or add a reference file with the smallest rule that would
improve future tests.

Update when:

- current Svelte, SvelteKit, Vitest, Playwright, or Sveltest docs change;
- a test pattern repeatedly catches or misses real bugs;
- a setup instruction is incomplete for a real project;
- the user corrects framework-specific guidance;
- a better fixture, wrapper, or mocking boundary proves useful repeatedly.

Prefer source-backed updates. Keep project-specific test commands in the project
under test, not in this shared skill.

## Citation notes

When citing this skill’s guidance:

- Cite the Svelte testing docs for Vitest setup, jsdom setup, runes-in-tests, direct mounting, Testing Library examples, Storybook component tests, and Playwright E2E setup.
- Cite the Svelte FAQ for the unit/component/E2E taxonomy and the reminder to avoid testing Svelte’s implementation details.
- Cite Sveltest for `vitest-browser-svelte` examples and its client-server alignment strategy with shared validation, real `FormData`/`Request`, TypeScript contracts, and minimal mocking.
