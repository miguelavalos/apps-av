# Apps AV Web Product App Patterns

This public guide defines the shared web pattern for Apps AV product apps. It is
safe for public repositories: it covers client-side UI structure, shared package
usage, and product-owned copy, without private deployment or provider details.

Use this when building or realigning web apps such as Series AV, Tune AV,
Moments AV, Animate AV, and future product apps.

## Shared Ownership

Product web apps own:

- product routes, domain workflows, state, and tests;
- product copy, icons, legal/support links, and branded assets;
- product-specific Pro, sync, credit, playback, render, tracking, or creation
  behavior.

`@avalsys/apps-av-web` owns:

- app shell and footer/header grammar;
- assistant placement in app chrome;
- settings/account scaffold, section cards, rows, buttons, option groups, and
  shared account/settings sections;
- reusable product-screen primitives such as search fields, segmented controls,
  metric tiles, assistant cards, and loading skeletons;
- shared external search engine lists and localized link helpers;
- protected-route empty/error/loading primitives.

Promote a component into `@avalsys/apps-av-web` when a second app can reuse it
without product nouns. Keep it local when the component only makes sense with
words such as series, station, render, gallery, episode, or playback.

## Account And Settings Pattern

Web account/settings screens should mirror the shared Apple `AVSettingsFoundation`
shape:

1. App shell chrome.
2. Plain screen header with title and subtitle, not a hero card.
3. Full-width section cards.
4. Rows with one icon, one title, and one detail.
5. Full-width primary/secondary/destructive buttons.

Use this order for `/settings`:

1. App preferences: language and appearance.
2. Product preferences: product behavior plus external-link/search settings when
   relevant.
3. On this device: local-only state, cache, downloads, or browser/device data.
4. Help and legal: open source/source, support, privacy, terms, account deletion.

Use this order for `/account`:

1. Account: session identity, email when available, and plan/access summary.
2. Product Pro: product-specific Pro benefits and upgrade/manage action.
3. Product sync or account-owned state: only when the account capabilities make
   it relevant.
4. Account safety: account deletion and other sensitive Account AV flows.

## Product Adaptation Checklist

For each product app:

- import settings primitives from `@avalsys/apps-av-web`, not local copies;
- import shared screen primitives from `@avalsys/apps-av-web` instead of
  product-local equivalents when the component has no product noun;
- keep section order identical to this guide unless the app lacks that category;
- keep the same row structure across account/settings;
- make product-specific differences copy-only where possible;
- document any intentional missing section in that product's public docs;
- run typecheck, tests, production build, and rendered desktop/mobile checks
  before calling the UI aligned.

## Series AV Reference

Series AV is the first web implementation of this pattern. Use its
`/account` and `/settings` routes as the reference when migrating the remaining
web apps.

## Assistant Pattern

Avi belongs to app chrome and contextual content, not to a floating bottom
overlay.

Use this web pattern across product apps:

1. Product configs expose `assistant` when the app has an Avi route.
2. `AppShell` renders the assistant as the right-side top chrome action on
   desktop.
3. Mobile places the assistant in the top navigation drawer.
4. Product pages can add a contextual assistant card when Avi is part of the
   current workflow.
5. Do not add product-local fixed bottom assistant buttons.
6. Do not render Clerk `UserButton`, provider avatars, or account avatars in
   product app chrome. Account access belongs in the normal navigation and
   account/settings routes; Clerk remains an Account AV implementation detail.
7. Account AV is the exception for account management itself: it may embed
   Clerk `UserProfile`, but visible provider avatar surfaces must be branded
   with Avi and the signed-in shell must not derive a user initial/avatar.

This mirrors the Apple app pattern where Avi is part of the configured app
experience and appears as contextual content when useful, without covering
primary actions or scroll content.

## Destructive Actions Pattern

Product web apps must treat deletion, archive removal, local data clearing, and
remote workflow cancellation as sensitive actions.

Use this pattern across product apps:

1. Keep the action label and confirmation copy in the product's localized text
   module.
2. Confirm before mutating browser storage, product API state, backend workflow
   state, or account-owned product data.
3. Make the confirmation copy specific about scope: local browser copy, active
   workflow, downloaded file, library entry, or backend-owned media/artifacts.
4. Do not use a generic `Delete?` prompt when source media, generated artifacts,
   credits, sync state, or backend jobs are involved.
5. Add a focused source-guard or unit test beside the route/component when a
   destructive action is introduced.

Current product precedents:

- Series AV confirms library entry deletion from detail and library rows.
- Tune AV confirms music discovery removal and local data clearing.
- Animate AV confirms downloaded video clearing, local job clearing, and active
  job deletion.
- Moments AV confirms Moment workspace deletion before requesting source media
  and generated artifact deletion.

## Product Screen Primitives

Use these shared primitives before creating product-local UI:

- `AppSearchField` for in-page search inputs.
- `AppSegmentedControl` for filters, modes, and small option sets.
- `AppMetricTile` for compact counters and status summaries.
- `AppAssistantBriefCard` for contextual Avi guidance inside content.
- `AppExternalLinkPanel` for grouped external resource links.
- `AppRowsSkeleton` for list-row loading states.
- `AppGridSkeleton` for card-grid loading states.

Keep product-local components for domain-rich rows/cards such as a Series AV
episode row, Tune AV station row, or Moments AV render card.
