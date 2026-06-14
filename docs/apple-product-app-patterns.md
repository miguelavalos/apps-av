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

## Documentation Scope Rule

Document shared Apple-product lessons in this guide or another shared Apps AV
public guide when the guidance is safe to publish. Document product-specific
behavior in that product repo's docs folder.

For example, account session behavior, app shell patterns, public config
hygiene, local file availability vocabulary, and release evidence shape are
shared. Station catalog behavior belongs to Tune AV, finished memory-video
Gallery behavior belongs to Moments AV, and account self-service behavior
belongs to Account AV.

Private provider, pricing, retention operations, credentials, admin workflows,
and release evidence values stay in the private AVALSYS suite.

## Third-Party Visual Content

Product apps must classify third-party visuals before showing them in public
Apple builds:

- Avalsys-owned, generated, synthetic, initials, and placeholder visuals are
  the safe default.
- Factual text metadata can be shown neutrally when it does not imply an
  unauthorized catalog or endorsement.
- TV/movie posters can be used as title-reference artwork when provider terms,
  attribution, and release evidence support that use.
- Company, platform, provider, station, app, favicon, and service logos are
  blocked unless permission or brand guidelines explicitly allow the exact use.
- Provider availability badges, `Watch on` links, trailers, embedded provider
  pages, and platform-branded actions require documented terms/evidence.
- App Store screenshots are stricter than in-app UI. Third-party posters or
  artwork need screenshot-specific approval before appearing in marketing
  assets.

Tune AV's station-logo rejection is not a blanket ban on Series AV-style
TV/movie posters. It is a warning not to use logos or brand imagery just because
a public API exposes them.

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

## Branding And First Run

Every Apps AV product app should have product-specific branding while preserving
the shared suite grammar.

Use this first-run sequence for iOS product apps:

```text
native launch logo + icon -> product splash with Avi -> onboarding
```

The native launch frame is a short identity frame. It should show the full
product logo, including product icon or mark, wordmark, and `AV`, centered on
the shared launch background. If plist-based `UILaunchScreen` image lookup is
unreliable during a copied-app migration, use an explicit
`LaunchScreen.storyboard` and verify the installed app contains the compiled
storyboard plus the referenced image resource.

The product splash is not the native launch logo. It should use product-specific
artwork and place Avi in a useful assistant role for that app. For example, a
music app can show Avi listening; a video or image app can show Avi preparing or
guiding creation. Avi should not be placed in the app icon unless a product
brand review explicitly approves that exception.

Onboarding may reuse the splash concept, but when Avi appears near the primary
call-to-action, the onboarding artwork should usually omit Avi so the screen
does not duplicate the assistant. The splash and onboarding art should integrate
with the shared paper/background treatment, without obvious rectangular canvas
edges or mismatched background colors.

Keep these roles separate:

- app icon: product feature and suite identity at small sizes;
- product mark: symbol used inside logo lockups and marketing surfaces;
- full logo: native launch, splash, web, and large marketing surfaces;
- wordmark: compact headers where repeating the icon would add visual noise;
- splash art: product concept with Avi as assistant;
- onboarding art: first-run product concept that supports the auth/actions
  layout.

Do not copy another app's visual assets into a new product as final branding.
Use existing apps as visual references, then approve product-specific assets in
the product's private brand-system handoff before replacing runtime assets.

Before accepting a first-run implementation, check a clean simulator install and
watch all three stages. A static screenshot of onboarding is not enough to
verify launch and splash behavior.

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
AccountAVClerk.configureIfPossible(
    publishableKey: AppConfig.avAccountKey,
    keychainService: BundleConfig.nonEmptyStringValue(for: "ACCOUNTAV_KEYCHAIN_SERVICE"),
    keychainAccessGroup: BundleConfig.nonEmptyStringValue(for: "ACCOUNTAV_KEYCHAIN_ACCESS_GROUP")
)
```

Use `ClerkAccountAVService` inside the product account wrapper:

```swift
private let accountService = ClerkAccountAVService(
    publishableKeyProvider: { AppConfig.avAccountKey },
    keychainServiceProvider: { BundleConfig.nonEmptyStringValue(for: "ACCOUNTAV_KEYCHAIN_SERVICE") },
    keychainAccessGroupProvider: { BundleConfig.nonEmptyStringValue(for: "ACCOUNTAV_KEYCHAIN_ACCESS_GROUP") },
    fallbackDisplayName: L10n.string("account.displayName.user"),
    loggerSubsystem: "com.avalsys.productav"
)
```

iOS apps using Account AV must expose these keys through `Info.plist` and
effective build settings:

- `ACCOUNTAV_PUBLISHABLE_KEY`
- `ACCOUNTAV_KEYCHAIN_SERVICE`
- `ACCOUNTAV_KEYCHAIN_ACCESS_GROUP`

Release builds must set `ACCOUNTAV_KEYCHAIN_ACCESS_GROUP` to
`935PM55U6R.<production-bundle-id>`. Debug/dev builds must set it to
`935PM55U6R.<debug-bundle-id>`. The signed entitlements file must include
`keychain-access-groups` with `$(AppIdentifierPrefix)$(PRODUCT_BUNDLE_IDENTIFIER)`.
The runtime config checker must fail before TestFlight if the effective access
group does not match the selected bundle/environment.

Series AV currently uses `scripts/verify-ios-runtime-config.sh production` for
the same Release/prod gate. New product apps should prefer the Tune AV-style
`scripts/check-ios-runtime-config.sh --env prod --configuration Release` shape
unless they already have an equivalent checker.

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
- treat a missing token or failed internal Apps AV user resolution as guest or
  temporarily unavailable instead of publishing the provider subject;
- keep signed-in onboarding tests realistic: active provider session, non-empty
  token, and internal Apps AV user resolution must all be present before the UI
  suppresses guest onboarding.
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

## macOS Clerk Keychain Service Rule

macOS and Catalyst apps that use Clerk through Account AV must treat the
Keychain service name as release-critical configuration.

Required behavior:

- configure Clerk with both an explicit `keychainConfig.service` and
  `keychainConfig.accessGroup`;
- include the matching `keychain-access-groups` entitlement in signed macOS
  archives;
- verify the resolved service, access group, and signed entitlement in archive
  preflight before TestFlight/App Store upload;
- never reuse a service name that was already used by a bad or legacy macOS
  build if that service has created login-keychain items on tester machines.

Clerk's macOS keychain storage can use a data-protection keychain primary store
with a legacy fallback when an access group is configured. Reusing an old
service name can make that fallback read old login-keychain items and trigger
system Keychain password prompts, even when the new archive has the correct
access group entitlement. If this happens, move the macOS product to a new
stable service name and make the archive checker reject the legacy service.

## Remote State And Local Files

Apple product apps should not hide account-owned product records just because a
device-local file is missing.

Use this split across apps:

- remote/account state: durable app records, purchases, credits, workflow
  status, and client-safe metadata recovered after sign-in;
- local availability: files, Photos assets, caches, and downloads present on
  the current device.

The UI should say whether content is saved on this device, missing locally,
available to download, unavailable to download, or metadata-only. Playback,
sharing, editing, and generation actions that need local files must validate
local availability first.

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
- native launch, splash, and onboarding appear in the expected first-run order;
- launch uses the product logo and icon, not a copied app asset;
- app icon, header wordmark, launch logo, splash art, and onboarding art are
  product-specific and visually reviewed;
- public docs and git state contain no generated local config or secrets.

Private provider setup, backend architecture, billing authority, release
evidence, App Store Connect details, and operational runbooks belong in the
private AVALSYS suite, not in public product repos.
