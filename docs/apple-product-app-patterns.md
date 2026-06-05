# Apps AV Apple Product App Patterns

This public guide describes the shared Apple-client pattern for Apps AV product
apps. It is safe for public repositories: it names shared packages and client
contracts, but it does not include production config, private provider setup,
backend internals, or release operations.

Use this guide when bootstrapping or refactoring iOS, iPadOS, macOS, Catalyst,
or future Apple-platform clients for Apps AV products such as Tune AV,
Moments AV, Series AV, Photo AV, and new products.

## Goal

Every Apple product app should feel product-specific while using the same
shared platform shape.

Product apps own:

- app name, bundle ids, icons, logos, launch assets, screenshots, and copy;
- product navigation destinations and domain screens;
- product data models, workflows, providers, local/offline rules, and tests;
- app-specific Pro, credit, usage, media, playback, tracking, or creation
  behavior;
- public legal/support links and public App Store metadata.

Shared code owns:

- identity/account behavior through `AccountAV`;
- shell, launch, settings, account, assistant, paywall, brand, and haptic
  primitives through `apps-av/apple`;
- reusable local-device media analysis when the output is domain-neutral.

If a second product can reuse a component without product words, copy changes,
or a different mental model, promote it into `apps-av/apple`. If it still needs
words such as station, render, episode, memory, gallery, or playback policy to
make sense, keep it in the product app.

## Required Apple Packages

Product apps should use these packages before writing local equivalents:

- `AccountAV`: provider-neutral account API that wraps Clerk configuration,
  sign-in, token refresh, current user mapping, and sign-out.
- `AVBrandFoundation`: shared Apple brand tokens and surfaces.
- `AVAppShellFoundation`: app chrome, footer/header grammar, screen spacing,
  cards, metrics, metadata rows, and dashboard primitives.
- `AVLaunchFoundation`: shared splash and launch-transition primitives.
- `AVSettingsFoundation`: settings, account, help/legal, destructive action,
  auth/onboarding, rows, cards, and profile surfaces.
- `AVAviFoundation`: shared Avi/assistant visual primitives.
- `AVPaywallFoundation`: paywall, plan, upgrade prompt, and benefit surfaces.
- `AVHaptics`: semantic haptics for common app events.
- `AVMediaAnalysisFoundation`: reusable local-device media signals when useful
  across more than one AV app.

Do not reimplement Clerk buttons, Account screens, footer selection, settings
cards, onboarding panels, paywall cards, or Avi chrome in a product app unless
the shared package is missing a required extension point.

## Bootstrap Checklist

Start every new Apple product app with this shape:

1. Create the platform folder, usually `apps/ios`, and keep the source folder
   inside that platform folder.
2. Add local Swift package dependencies on `../../../apps-av/apple` and
   `../../../account-av`, adjusted for the repo layout.
3. Add `Debug.xcconfig`, `Release.xcconfig`, and a gitignored generated
   `Local.xcconfig`.
4. Add a config generator and runtime checker. The checker must redact
   sensitive values and print the Account AV redirect URI as
   `<bundle-id>://callback`.
5. Register URL schemes with `$(PRODUCT_BUNDLE_IDENTIFIER)`.
6. Add Sign in with Apple and keychain entitlements when account sign-in exists.
7. Add one app experience object that centralizes product identity, brand assets,
   legal links, onboarding copy, assistant identity, footer tabs, and shared
   shell configuration.
8. Apply the experience at the app root with the Apps AV environment modifier.
9. Use shared launch, onboarding, header, footer, settings, account, help/legal,
   paywall, and Avi primitives before creating local screens.
10. Keep product routes, workflows, models, API clients, feature state, and
    product copy local.
11. Add tests for account state sync, sign-out clearing, shell selection,
    settings order, and the product's main workflow states.
12. Add public-safe docs for install, config hygiene, release checks, and public
    repo safety.

## Account AV Contract

Product apps must treat Clerk as an implementation detail behind `AccountAV`.
The app-facing account layer should speak in provider-neutral terms:

```swift
@MainActor
protocol AVAccountService {
    var isAvailable: Bool { get }
    var providerSessionUser: AccountAVUser? { get }

    func getToken() async throws -> String?
    func signInWithApple() async throws
    func signInWithGoogle() async throws
    func signOut() async throws
}
```

Configure once at app launch:

```swift
AccountAVClerk.configureIfPossible(publishableKey: AppConfig.avAccountKey)
```

Use `ClerkAccountAVService` inside the product account wrapper:

```swift
private let accountService = ClerkAccountAVService(
    publishableKeyProvider: { AppConfig.avAccountKey },
    fallbackDisplayName: L10n.string("account.displayName.user"),
    loggerSubsystem: "com.avalsys.productav"
)
```

After OAuth returns, sync from the account provider before updating app state:

```swift
try await accountController.signInWithApple()
await accountController.syncFromAccountProvider()
isShowingAccountOnboarding = false
authOptionsArePresented = false
```

The account controller should:

- read `providerSessionUser` as provider session evidence only;
- if nil, call `getToken()`;
- read `providerSessionUser` again;
- call the platform API `/v1/me` with the provider token;
- publish and cache only the returned internal Apps AV user id;
- resolve app access, credits, purchases, or sync state from that internal user;
- clear local signed-in state on sign-out.

If `/v1/me` fails, do not publish the provider subject as the product user.

Purchase SDKs such as RevenueCat must also use the internal Apps AV user id as
their app/customer user id. Product apps can keep product-specific purchase
services for subscriptions, credits, or other catalogs, but the customer id
selection rule is shared: use the resolved internal user id, never
`providerSessionUser.id`.

Do not call Clerk directly from product UI.

## Shell And Navigation

Use shared shell primitives for common chrome:

- product destinations live in footer tabs or platform-appropriate product
  navigation;
- Settings and Account are chrome destinations, not product tabs;
- opening Settings or Account must not leave Home selected in the footer;
- tapping any product tab clears chrome state;
- headers use settings left, product wordmark center, account right unless the
  product has a documented reason to diverge;
- Avi can be a shared assistant button or a product tab only when the product
  requires that information architecture.

For macOS, prefer sidebar or toolbar navigation when appropriate, but preserve
the same semantic destinations and reuse the same settings/account content.

## Settings And Account

Common settings stay in this order across apps:

1. App language
2. Appearance

Put product-only settings in a separate product preferences card after common
settings.

Account screens should:

- show local/guest state when signed out;
- show current account identity when signed in;
- expose sign-in and sign-out actions consistently;
- route account deletion through the shared Account AV path;
- keep product Pro, credits, usage limits, and subscription state in product
  sections below shared account state.

## Config And Public Repo Hygiene

Public repos must not contain generated local config, secrets, production-only
values, signing material, provider dashboards, private URLs, app review access,
or internal operations.

Public committed config should contain variable placeholders and safe defaults
only. Real local, staging, production, provider, signing, and release values are
generated by private maintainer tooling into ignored local files.

Use compile-only unsigned builds for build checks:

```bash
xcodebuild build -project apps/ios/ProductAV.xcodeproj \
  -scheme ProductAV \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO
```

Do not validate sign-in, account state, purchases, uploads, generation, deletion,
or other keychain/provider flows with unsigned simulator builds.

## Verification Checklist

Before calling a product app aligned with Apps AV, verify:

- runtime config checker passes for the intended environment;
- URL scheme is `$(PRODUCT_BUNDLE_IDENTIFIER)`;
- Account AV redirect URI is `<bundle-id>://callback`;
- app UI uses `AccountAV`, not direct Clerk calls;
- onboarding and Account/Profile sign-in both show Apple/Google choices;
- OAuth success closes onboarding and shows signed-in account state;
- scene activation refreshes account state;
- sign-out clears local account/access/credit/subscription state;
- Settings and Account do not select Home in footer chrome;
- Settings common controls are Language then Appearance;
- shared shell/settings/account/paywall/Avi primitives are used where available;
- public docs and git state contain no generated local config or secrets.

Private provider setup, backend architecture, billing authority, release
evidence, App Store Connect details, and operational runbooks belong in the
private AVALSYS suite, not in public product repos.
