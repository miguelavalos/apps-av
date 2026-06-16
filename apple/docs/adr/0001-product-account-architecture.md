# ADR 0001: Product Account Architecture

Status: Accepted

Date: 2026-06-10

## Context

Tune AV, Moments AV, and Animate AV need one shared Apple account architecture.
Each product app should preserve its own credits, access, purchases, sync, media,
and feature policy, but authentication, account restore, account gating, and
sign-in presentation must follow the same rules.

Account AV already wraps the external provider. Apps AV Apple is the shared
Apple client package used by product apps. The architecture boundary is:

- Account AV adapts the provider.
- Apps AV Apple owns the shared product-account client architecture.
- Product apps adapt product-specific behavior into that shared architecture.

Moments AV and Animate AV are pre-user enough that no legacy compatibility
branch is required. Tune AV is already live in the App Store, so product
backend compatibility must be preserved separately while auth/account code
migrates to the shared architecture. Dead duplicated auth/account code should
be removed as products migrate.

## Decision

Apps AV Apple will define the common product-account architecture for Apple
clients. Account AV remains a provider-auth adapter only.

### Account AV Responsibilities

Account AV may:

- configure the auth provider;
- restore the provider session;
- get a provider token;
- sign in with Apple;
- sign in with Google;
- sign out of the provider;
- expose provider session metadata clearly labeled as provider metadata.

Account AV must not own:

- product account state;
- Apps AV internal user state;
- product UI;
- credits, access, subscriptions, purchases, sync, or analytics identity;
- an internal Apps AV identity cache.

### Apps AV Apple Responsibilities

Apps AV Apple owns the shared product-account client behavior:

- internal Apps AV user state;
- `/v1/me` identity resolution;
- last-known internal user cache;
- restore lifecycle;
- temporary unavailable state;
- manual logout semantics;
- common auth presentation state;
- common onboarding, splash, and shell gate support;
- shared tests for account restore and auth-flow behavior.

Product apps provide adapters for product-specific access, entitlement,
subscription, credit, sync, media, and feature policy.

## Identity Rule

Product apps must publish and cache only the internal Apps AV user returned by
`/v1/me`.

Provider user ids, including Clerk `user_...` subjects, must never be used as:

- product user ids;
- ownership ids;
- purchase or subscription customer ids;
- Convex ids;
- D1 ids;
- R2 path ids;
- analytics user ids.

Provider identity is authentication evidence only. The native product flow is:

1. Restore or create a provider session through Account AV.
2. Request a provider bearer token from Account AV.
3. Call Apps AV `/v1/me` with that token.
4. Publish and cache only the internal Apps AV user returned by `/v1/me`.
5. Resolve product access, credits, purchases, subscriptions, sync, or features
   through product adapters scoped to that internal user.

If `/v1/me` fails or cannot resolve a user, the app must not publish the
provider subject as a fallback product user.

## Restore And Logout Semantics

Signed-in state is sticky unless the user manually logs out.

iOS must not automatically log the user out because of:

- elapsed time;
- app restart;
- keychain delay;
- provider refresh delay;
- backend timeout;
- temporary `/v1/me` failure;
- network or service unavailability during restore.

During restore, a last-known internal user remains the visible signed-in account
while the provider, token, or `/v1/me` resolution is temporarily unavailable.
The shared state may mark the account temporarily unavailable so products can
disable sensitive actions or show retry affordances, but it must not clear
local signed-in state.

If the provider reports signed out and there is no last-known internal user, the
shared product-account state may become guest/signed-out. If the provider
reports signed out while a last-known internal user exists, the shared
architecture treats that as recoverable restore uncertainty, not as logout.

Only explicit manual logout may clear the last-known internal user cache and
run product cleanup hooks.

## Common Auth Presenter Rule

Every visible sign-in entrypoint in Tune AV, Moments AV, and Animate AV must
open the same common Apps AV auth presenter.

This includes direct and indirect entrypoints such as:

- Account or Profile;
- Paywall;
- Create;
- Gallery and in-progress empty states;
- Avi sign-in cards;
- onboarding calls to action;
- product-specific sign-in prompts.

Products may configure copy, legal links, artwork, and product-specific
post-auth behavior, but they must not create parallel local sign-in flows.

The shared presenter state must cover:

- hidden;
- onboarding collapsed;
- onboarding options;
- busy provider;
- error.

The common presenter API will cover:

- `presentSignIn(optionsExpanded:)`;
- `skipForNow()`;
- `continueWithApple()`;
- `continueWithGoogle()`;
- `signOutManually()`.

## Product Boundaries

Tune AV keeps Tune-specific access, entitlements, subscriptions, cloud sync,
and guest policy behind adapters.

Moments AV keeps Moments credits, purchases, profile resolution, media workflows,
and product copy behind adapters.

Animate AV keeps Animate credits, paywall, `/v1/me` feature fields, launch and
deep-link behavior, and image-generation feature gating behind adapters. Public
v1 remains video-only. Image generation remains admin/test-only: normal users
must not see image entrypoints, while backend enforcement remains required.

Series AV is outside this migration plan.

## Legacy And Cleanup Rule

Because the shared auth/account migration does not require preserving obsolete
local auth architecture, the refactor should remove obsolete local auth/account
code as each app adopts the shared architecture. Product backend compatibility
is handled by each app's backend contract; Tune AV must keep App Store
compatibility while shipped clients still require it.

Do not keep:

- fallback code that publishes provider ids as product ids;
- duplicate auth presentation booleans;
- app-local sign-in coordinator copies when the shared presenter can replace
  them;
- obsolete tests that preserve the old architecture rather than the product
  behavior;
- dead account caches outside the shared Apps AV product-account layer.

## Consequences

This creates one shared mental model for account restore and sign-in across Tune
AV, Moments AV, and Animate AV. Product apps become thinner: they adapt
product-specific policy to Apps AV Apple account primitives instead of owning
their own provider restore and auth presentation state.

Future implementation steps should add the shared types, session controller,
auth flow controller, root gate helpers, app migrations, cleanup audits, and
validation tests described by this ADR.
