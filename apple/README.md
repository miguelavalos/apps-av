# Apps AV Apple

Swift packages for AV apps on Apple platforms.

## Architecture Boundary

Apps AV is the shared Apple foundation for AVALSYS apps. It should provide the
structure, design language, reusable UI primitives, and cross-app interaction
patterns that future iOS apps can adopt without inheriting a specific product
domain.

Keep this package domain-neutral:

- Do include brand tokens, shell scaffolds, launch primitives, settings surfaces,
  paywall surfaces, assistant visual primitives, generic player chrome, and
  semantic haptics.
- Do not include radio, station, stream, catalog, recommendation, listening
  analytics, purchase-product IDs, account policies, localized product copy, or
  app-specific orchestration.
- Do not add product-specific words to public APIs unless the module itself is
  intentionally product-specific. Public names should describe their UI role:
  `primaryTitle`, `footerPlayer`, `compactStatusBadge`, `assistant`, `content`,
  `status`, and similar generic terms.

Host apps own their domain and adapt it into Apps AV primitives. For example,
a radio app may render a station through `AVCompactStatusBadge` or
`AVExpandedFooterPlayerScaffold`, but Apps AV should not know that the title is
a station, that playback uses streams, or that a badge means live metadata.

### Ownership Matrix

| Layer | Belongs in Apps AV | Belongs in product apps or product shared code |
| --- | --- | --- |
| Branding | Base color, spacing, typography, radius, motion, surface tokens | App-specific names, app-specific overrides, product art direction decisions |
| Shell | Navigation chrome, footer player layout, tab treatment, generic headers/search/buttons | Tab model, routes, screen state, playback state, business rules |
| Launch | Splash layout and transition state primitives | Startup work, test flags, product logo, tagline, legal copy |
| Settings | Cards, rows, buttons, sheet/screen scaffolds | Account state, deletion rules, URLs, localized copy, provider configuration |
| Assistant | Avi/assistant cards, panel chrome, buttons, avatar containers, reaction visuals | Personality model, assets, prompts, recommendations, domain actions |
| Paywall | Paywall cards, benefit rows, plan layout, upgrade prompt surfaces | Product IDs, entitlements, usage limits, billing flows, legal URLs |
| Haptics | Semantic feedback events and native platform mapping | When a domain action should trigger feedback |

### Promotion Rule

Add a primitive to Apps AV only when a second product could reuse it without
renaming the API, changing the mental model, or importing product domain. If a
component still needs words like station, radio, stream, track catalog, Tune,
or a product-specific policy to make sense, keep it in the product app or the
product shared package.

## Reference App Pattern

Tune AV is the first completed reference app for the Apps AV visual system.
When a new app is created, use Tune AV as the product-quality reference and
Apps AV as the reusable implementation boundary. A new app should not copy Tune
screens wholesale; it should provide product configuration, product assets, and
domain screens that consume Apps AV primitives.

Moments AV is the first adaptation target for this pattern. Work done for
Moments should either:

- promote generic Tune-proven behavior into Apps AV, then let Tune and Moments
  consume it; or
- stay in Moments when it is specific to memory projects, media upload, story
  generation, previews, final renders, credits, or Moments-specific copy.

### Common App Contract

Every Apps AV Apple app should converge on the same common shell contract:

| Area | Apps AV provides | App provides |
| --- | --- | --- |
| Branding | Shared palette model, colors, surfaces, typography, spacing, radius, app identity model | App logo, wordmark, artwork, optional palette override |
| Launch | Splash layout, hero/logo slots, transition state policy, splash content model | Product startup work, product logo/artwork, launch copy |
| Onboarding | Shared auth/onboarding panels, CTA surfaces, onboarding content model | Provider wiring, legal URLs, login/guest policy, product copy |
| Home chrome | Top header layout with settings left, logo center, account right | Logo asset and account/settings routes |
| Footer | Shared bottom shell with tabs left and Avi/assistant right | Tab enum, tab labels/icons, selected content, assistant state |
| Settings/account | Shared cards, rows, buttons, notices, headers, destructive surfaces | Account state, URLs, subscription/credits content, product policies |
| Avi | Shared avatar/card/header/landing hero/panel visuals | Product guidance, domain actions, assistant artwork/personality inputs |
| Domain screens | Shared screen padding, scroll behavior, status/buttons/cards | Product workflows, models, API clients, data orchestration |

### App Integration Checklist

For a new app, start with the same structure used by Tune AV and Moments AV:

1. Add the local package dependency on `apps-av/apple`.
2. Keep the app project under `apps/ios`, with the iOS target source folder
   inside that platform folder.
3. Add product assets for the shared shell:
   - header wordmark or logo
   - Avi footer icon
   - splash logo and hero artwork
   - onboarding brand and hero artwork
   - Avi onboarding and sheet artwork when the product needs a larger companion image
   - app icon and launch assets
4. Add one local app experience file that defines an `AVCommonAppExperience`
   from app identity, brand palette, legal links, splash copy, onboarding copy,
   and footer configuration.
5. Apply that experience once at the app root with
   `.avCommonAppExperience(ProductAppExperience.experience)`.
6. Read `@Environment(\.avCommonAppExperience)` from shared shell, onboarding,
   settings, account, and assistant surfaces instead of reaching back into
   product static globals from each screen.
7. Add a local theme adapter that points to `AVBrandFoundation` tokens.
8. Build the root shell with `AVAppShellConfiguredScaffold` unless the product
   needs custom footer chrome. This keeps the Tune-style footer contract:
   product tabs on the left and Avi on the right.
   Build the footer assistant with
   `AVAppShellConfiguredAssistant(experience:accessibilityIdentifier:)` so the
   assistant name and artwork come from `AVCommonAppExperience`.
9. Use `AVAppShellConfiguredBrandHeader` for the top header: settings on the
   left, configured product logo centered, account on the right.
10. Use `AVAppShellScreenMetric` and `avShellScreenContentPadding` for standard
   screen spacing instead of local duplicated constants.
11. Use `AVAppShellScrollableScreenScaffold` for standard scrollable domain
    screens that need shared padding, hidden scroll indicators, and a branded
    background.
12. Use `AVAppShellHomeHeader` inside that scaffold for Home so every app keeps
    the Tune-derived top composition: settings left, app logo center, account
    right, then the app-specific Home summary and intro content.
13. Keep product tabs, routes, workflows, settings models, legal URLs, and
    account policy in the app.
14. Use `AVAuthConfiguredOnboardingScreen` for the common Tune-derived
    login/onboarding composition. The shared screen reads configured brand,
    hero, and Avi artwork from `AVCommonAppExperience`; products provide auth
    provider wiring, legal URLs, login/guest policy, and product copy.
15. Use `AVAuthLegalConsentText` with the app experience identity/legal links
    for standard auth consent copy when the app does not need localized custom
    legal text.
16. Use `AVAviCompanionArtwork` for Tune-style Avi companion artwork instead
    of rebuilding local shadow/frame/accessibility wrappers.
17. Use `AVConfiguredAviAvatarBadge` for standard app-configured Avi badges.
    Use `AVAviAssetAvatarBadge` only when the asset name is intentionally local
    to the screen.
18. Use `AVConfiguredAviHomeBriefCard` for the standard Home Avi intro when
    the app can use the configured assistant avatar. Use `AVAviHomeBriefCard`
    directly when the product needs a dynamic or domain-specific assistant
    avatar, such as Tune AV playback emotions.
19. Use `AVAviGuidanceScreenScaffold` for informational Avi screens. Use
    `AVConfiguredAviGuidanceScreen` when the standard configured assistant
    avatar/header/hero composition is enough. Use lower-level Avi primitives
    only when the product has a richer domain experience such as Tune AV
    playback.
20. Use `AVAppShellDashboardSection`, `AVAppShellMetric`, and
    `AVAppShellMetricStrip` for reusable Home/dashboard summaries.
21. Use `AVSettingsConfiguredSettingsContent`,
    `AVSettingsConfiguredAccountContent`, and `AVSettingsHelpLegalSection` for
    common Tune-style settings/account/help/legal surfaces, then inject
    product-specific state and actions. Prefer
    `AVSettingsConfiguredHelpLegalContent(identity:legalLinks:)` for standard
    help/legal copy, overriding only the details that are truly product-specific.
22. Promote reusable UI only after it can serve both Tune AV and the new app
    without product naming.
23. Build Apps AV, Tune AV, and the new app after shared API changes.

### Common Surface Verification

Before treating a new app as aligned with the Apps AV reference pattern,
verify the shared surfaces in a simulator or UI test fixture:

1. Signed-out launch shows the configured splash and onboarding, with product
   logo, product copy, product hero artwork, and configured Avi CTA artwork.
2. Signing in is required when the product has no guest mode.
3. Home opens as the initial signed-in screen.
4. Home top chrome has settings on the left, product logo centered, and account
   on the right. The header buttons expose generic accessibility labels:
   `Settings` and `Account`.
5. Footer product tabs stay on the left and the Avi/assistant entry stays on
   the right.
6. Avi opens as an informational or guidance surface unless the product has a
   richer assistant workflow. The screen must show the configured Avi artwork
   and product guidance content.
7. Settings and Account open from the shared header and keep the same header
   selection treatment.
8. Settings and Account use `AVSettingsFoundation` configured/profile surfaces
   for common sections, while product policies and domain rows remain local.
9. Domain screens use `AVAppShellFoundation` primitives for cards, metrics,
   status, metadata, and scroll spacing. They should not use settings cards as
   generic containers.
10. The app builds after shared API changes, and Tune AV still builds when the
    change affects Apps AV public API.

### Domain Screen Rule

Settings/account components are for settings and account surfaces only. Domain
screens such as create flows, projects, libraries, editors, playback details,
or dashboards should use shell primitives:

- `AVAppShellCard` for neutral app content cards.
- `AVAppShellContentHeader` for card titles and explanatory detail.
- `AVAppShellInfoRow` for non-interactive icon/title/detail rows inside
  product cards.
- `AVAppShellProgressRow` for compact workflow progress rows where the product
  owns the phase names and completion rules.
- `AVAppShellInlineMessage` for empty, unavailable, and helper messages with a
  leading symbol.
- `AVAppShellMetadataCard`, `AVAppShellMetadataItem`, and
  `AVAppShellIdentifierRow` for compact technical metadata, diagnostics, API
  identifiers, and render/job details.
- `AVAppShellHomeHeader` for the standard Home composition: brand header,
  screen title/subtitle, then product-specific Home intro content.
- `AVAppShellScrollableScreenScaffold` for standard scrollable screen
  composition: shared padding, scroll behavior, and branded background.
- `AVAppShellScreenHeader` for top-of-screen summaries.
- `avShellScreenContentPadding()` and `avShellScreenScrollBehavior()` for
  standard screen spacing and scroll treatment.
- `AVSettingsProfileSurface` and `AVSettingsProfileCopy` for the common
  settings/account title and subtitle contract when the app does not need
  localized or heavily custom profile copy.

Do not use `AVSettingsCard` as a generic rounded container. That couples domain
screens to settings semantics and makes new apps harder to audit. If a domain
screen needs a visual primitive that is missing from Apps AV, either keep a
small product-local view or promote a neutral shell primitive after it works for
both Tune AV and the adapting app.

Moments AV is the reference adaptation for this rule: Home, Avi, Projects, and
Create should consume shell/Avi primitives for product workflow UI, while
Profile, Account, legal, and destructive account actions may consume
`AVSettingsFoundation`.

### Current Shared Shell APIs

Define app identity once in the product app and expose one shared experience
value. Product apps may keep this as a local enum so localized copy, bundle
config, environment-derived URLs, and product-specific subtitles stay local.

```swift
import AVBrandFoundation
import AVSettingsFoundation

enum ProductAppExperience {
    private static let appIdentity = AVAppIdentity(
        displayName: "Product AV",
        assistantName: "Avi",
        accountName: "Apps AV"
    )

    static var experience: AVCommonAppExperience {
        AVCommonAppExperience(
            identity: appIdentity,
            legalLinks: legalLinks,
            brandPalette: AVBrandPalette.standard,
            visualAssets: visualAssets,
            splashTagline: "Product tagline",
            onboardingTitle: "Create with Avi",
            onboardingSubtitle: "Sign in to keep projects attached to your account.",
            onboardingPrimaryTitle: "Continue"
        )
    }

    static var visualAssets: AVCommonAppVisualAssets {
        AVCommonAppVisualAssets(
            headerLogoName: "ProductHeaderWordmark",
            splashLogoName: "ProductSplashLogo",
            splashHeroName: "ProductSplashHero",
            onboardingBrandName: "ProductAuthWordmark",
            onboardingHeroName: "ProductOnboardingHero",
            onboardingCTACompanionName: "ProductAviOnboardingCTA",
            onboardingAuthPanelCompanionName: "ProductAviLoginSheetPeek",
            footerAssistantName: "ProductAviFooterIcon"
        )
    }

    static var legalLinks: AVAppLegalLinks {
        AVAppLegalLinks(
            supportURL: AppConfig.supportURL,
            privacyURL: AppConfig.privacyURL,
            termsURL: AppConfig.termsURL
        )
    }
}
```

Use `ProductAppExperience.experience.identity`, `.splashContent`,
`.brandPalette`, `.splashContent`, `.onboardingContent`, `.legalLinks`, and
`.footerConfiguration` from shell, launch, onboarding, settings, account, and
Avi surfaces. This keeps the common contract obvious when adapting a new
product. Apply the experience at the app root:

```swift
RootView()
    .avCommonAppExperience(ProductAppExperience.experience)
```

Then consume the same configuration from reusable surfaces:

```swift
@Environment(\.avCommonAppExperience) private var appExperience

AVAppShellBrandHeader(identity: appExperience.identity) {
    Image("HeaderWordmark")
        .resizable()
        .scaledToFit()
} openSettings: {
    openSettings()
} openAccount: {
    openAccount()
}
```

Product-specific workflow screens may still use local constants or view models
for domain copy and state. Shared surfaces should prefer the environment value
so the app can be rethemed by changing one app experience.

`AVAppShellScaffold` owns the common bottom shell layout. Footer product tabs
belong on the bottom left and the Avi/assistant entry belongs on the bottom
right.

`AVAppShellBrandHeader` owns the common top header layout:

```swift
AVAppShellBrandHeader(
    identity: ProductAppExperience.experience.identity,
    activeItem: activeHeaderItem,
    settingsAccessibilityLabel: "Settings",
    selectedAccessibilityValue: "Selected"
) {
    Image("HeaderWordmark")
        .resizable()
        .scaledToFit()
} openSettings: {
    openSettings()
} openAccount: {
    openAccount()
}
```

`AVAppShellScreenMetric` and the screen modifiers keep common screen spacing
aligned across products:

```swift
ScrollView {
    screenContent
        .avShellScreenContentPadding()
}
.avShellScreenScrollBehavior()
```

`AVAppShellStandardScaffold` keeps the standard Tune-style footer consistent:
product tabs sit on the left and the app's Avi asset sits in the assistant
button on the right.

Prefer `AVAppShellConfiguredScaffold` for new apps. It reads the assistant
identity from one app-level configuration object and leaves only the app tab
model, selected content, and optional footer player local:

```swift
let assistant = AVAppShellConfiguredAssistant(
    name: appExperience.identity.assistantName,
    accessibilityIdentifier: "product.tab.avi",
    assetName: appExperience.visualAssets?.footerAssistantName ?? "AviFooterIcon"
)

AVAppShellConfiguredScaffold(
    selectedTabID: selectedTab,
    tabs: productTabs,
    assistantID: .avi,
    assistant: assistant,
    hasAssistantActiveContext: hasActiveContext,
    footerConfiguration: appExperience.footerConfiguration,
    onSelectTab: selectTab,
    onSelectAssistant: openAvi,
    content: { selectedContent },
    footerPlayer: { EmptyView() }
)
```

```swift
AVAppShellStandardScaffold(
    selectedTabID: selectedTab,
    tabs: productTabs,
    assistantID: .avi,
    assistantName: "Avi",
    assistantAccessibilityIdentifier: "tab.avi",
    assistantAssetName: "AviFooterIcon",
    hasAssistantActiveContext: hasActiveContext,
    footerConfiguration: .contentOnly,
    onSelectTab: selectTab,
    onSelectAssistant: openAvi,
    content: { content },
    footerPlayer: { EmptyView() }
)
```

`AVAuthConfiguredOnboardingScreen` is the default onboarding entry point for
new apps. It reads logo and Avi companion assets from
`AVCommonAppExperience.visualAssets`, while the product keeps provider actions,
legal copy, login/guest policy, and product hero artwork local:

```swift
AVAuthConfiguredOnboardingScreen(
    authOptionsArePresented: $authOptionsArePresented,
    primaryAction: showAuthOptions,
    secondaryAction: allowsGuestAccess ? skip : nil,
    heroArtwork: { ProductOnboardingArtwork() },
    authPanel: { ProductAuthOptionsPanel() }
)
```

Use the lower-level `AVAuthOnboardingScreen` only when the app needs custom
branding slots that do not fit the configured wrapper:

```swift
let content = AVAuthOnboardingContent(
    title: title,
    subtitle: subtitle,
    primaryTitle: "Continue",
    secondaryTitle: allowsGuestAccess ? "Not now" : nil,
    brandAccessibilityLabel: "Product AV"
)

AVAuthOnboardingScreen(
    authOptionsArePresented: $authOptionsArePresented,
    content: content,
    primaryAction: showAuthOptions,
    secondaryAction: allowsGuestAccess ? skip : nil,
    brand: { ProductLogo() },
    heroArtwork: { ProductOnboardingArtwork() },
    ctaCompanion: { ProductAviCompanion() },
    authPanel: { ProductAuthOptionsPanel() }
)
```

Use `AVAuthLegalConsentText` when the product does not need custom localized
legal copy:

```swift
AVAuthLegalConsentText.make(
    identity: ProductAppExperience.experience.identity,
    legalLinks: ProductAppExperience.experience.legalLinks
)
```

`AVAviCompanionArtwork` owns the common Tune-derived companion image treatment
for onboarding CTAs and auth sheets: fixed frame, optional ground shadow,
image shadow, offset, and accessibility hiding. Product apps provide only the
asset name and sizing overrides when their artwork differs:

```swift
AVAviCompanionArtwork(
    assetName: "AviV2OnboardingCTA",
    shadow: .init(color: ProductTheme.ink.opacity(0.12), radius: 10, y: 7),
    groundShadowColor: ProductTheme.ink.opacity(0.1)
)

AVAviCompanionArtwork(
    assetName: "AviV2LoginSheetPeek",
    imageWidth: 126,
    imageHeight: 126,
    frameWidth: 140,
    frameHeight: 110,
    imageOffset: CGSize(width: 0, height: -5),
    groundShadowColor: nil
)
```

`AVConfiguredAviAvatarBadge` is the default circular Avi badge for configured
apps. It reads the footer assistant asset from `AVCommonAppExperience`:

```swift
AVConfiguredAviAvatarBadge(
    imageSize: 58,
    badgeSize: 76,
    backgroundStyle: .accentSoft,
    strokeStyle: .accentSoft
)
```

`AVAviAssetAvatarBadge` owns the lower-level circular Avi asset treatment used
when a screen intentionally supplies a specific asset:

```swift
AVAviAssetAvatarBadge(
    assetName: "AviFooterIcon",
    imageSize: 58,
    badgeSize: 76,
    backgroundStyle: .accentSoft,
    strokeStyle: .accentSoft
)
```

`AVAviLandingHeroCard` owns the common Avi landing/guidance hero treatment.
Tune AV uses it for Avi Preview and Moments AV uses it for the Moments guidance
page. Product apps provide the copy, chips, and assistant artwork:

```swift
let content = AVAviLandingContent(
    eyebrow: "Avi guide",
    title: "Avi keeps work moving",
    detail: "Use Avi for focused guidance across the product workflow.",
    chips: [
        AVAviLandingChip(title: "Create", systemImage: "sparkles"),
        AVAviLandingChip(title: "Review", systemImage: "checkmark.circle")
    ],
    accessibilityIdentifier: "product.avi.hero"
)

AVAviLandingHeroCard(content: content) {
    ProductAviAvatar()
}
```

For an informational Avi tab like Moments AV, prefer
`AVAviGuidanceScreenScaffold`. It combines the standard Avi header, the landing
hero, scroll behavior, and footer-safe bottom padding:

```swift
AVAviGuidanceScreenScaffold(
    identity: appExperience.identity,
    summary: "Guidance for the product workflow.",
    status: "Guide",
    headerAccessibilityIdentifier: "product.avi.header",
    landingContent: content,
    backgroundStyle: AnyShapeStyle(ProductTheme.shellBackground)
) {
    AVConfiguredAviAvatarBadge(imageSize: 58, badgeSize: 76)
} heroAvatar: {
    AVConfiguredAviAvatarBadge(imageSize: 62, badgeSize: 78)
} content: {
    ProductAviGuidanceContent()
}
```

For Home dashboards, use the shell primitives rather than product-local metric
tiles:

```swift
AVAppShellDashboardSection(title: "Account connected", detail: accountSummary) {
    AVAppShellMetricStrip(
        metrics: [
            AVAppShellMetric(title: "Spendable", value: credits, systemImage: "creditcard"),
            AVAppShellMetric(title: "Projects", value: projectCount, systemImage: "folder")
        ],
        minTileHeight: 96
    )
}
```

For technical details and workflow diagnostics, keep status rules in the app
but use shared metadata primitives for layout:

```swift
AVAppShellMetadataCard {
    HStack {
        ProductStatusBadge(status: status)
        Text(kindTitle)
            .font(.caption.weight(.semibold))
    }

    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        AVAppShellMetadataItem(title: "Provider", value: providerTitle)
        AVAppShellMetadataItem(title: "Model", value: modelTitle)
    }

    AVAppShellIdentifierRow(title: "Job ID", value: jobID)
}
```

For settings and account, use configured content wrappers when the app follows
the standard Apps AV profile model:

```swift
AVSettingsConfiguredSettingsContent(
    sections: settingsSections,
    helpLegalContent: helpLegalContent,
    openURL: openURL,
    deleteAccount: deleteAccount
)

AVSettingsConfiguredAccountContent(
    sections: accountSections,
    signOut: signOut,
    deleteAccount: deleteAccount
)
```

## Products

### AVBrandFoundation

`AVBrandFoundation` provides shared Apple UI tokens for AV apps:

```swift
import AVBrandFoundation

Text("Avi")
    .font(AVBrandTypography.title)
    .foregroundStyle(AVBrandColor.textPrimary)
    .padding(AVBrandSpacing.lg)
    .background(AVBrandColor.cardSurface)
    .clipShape(RoundedRectangle(cornerRadius: AVBrandRadius.card))

Circle()
    .fill(AVBrandSurface.accentGradient)
```

The product includes generic tokens for color, surface gradients, typography, spacing, radius, icon sizing, and motion. Use semantic names such as `ink`, `canvas`, `accentBase`, `textPrimary`, and `accentGradient` in Apps AV. Product-specific apps should keep their local theme adapters when they need app-specific names.

Brand token ownership is intentionally narrow:

| Type | Role |
| --- | --- |
| `AVBrandColor` | Default structural colors and semantic defaults used by Apps AV. |
| `AVBrandPalette` | App-provided product branding overrides such as `ink`, `accent`, `destructive`, launch surfaces, and canvas. |
| `AVBrandSurface` | Reusable gradients and surfaces, with palette-aware functions when the surface carries app branding. |

Use `AVBrandColor` directly for structural chrome that should remain stable across products. Use `@Environment(\.avBrandPalette)` in reusable components when a future app should be able to override the visual brand without changing Apps AV code.

Apps can provide product branding without changing base components by injecting an `AVBrandPalette` near the app root:

```swift
RootView()
    .avBrandPalette(
        AVBrandPalette(
            ink: productInk,
            accent: productAccent,
            destructive: productDestructive,
            canvas: productCanvas,
            launchSurfaceStart: productLaunchStart,
            launchSurfaceMid: productLaunchMid,
            darkSurfaceAlt: productDarkSurface
        )
    )
```

Keep app/domain language, product identifiers, account policy, localized copy, and orchestration outside Apps AV. The palette is only for reusable visual branding tokens.

### AVAppShellFoundation

`AVAppShellFoundation` provides shared shell scaffolding primitives for Apple apps:

```swift
import AVAppShellFoundation

AVAppShellScaffold(
    selectedTabID: selectedTab,
    tabs: tabs,
    assistantID: assistantTab,
    assistantAccessibilityLabel: "Assistant",
    assistantAccessibilityIdentifier: "tab.assistant",
    hasAssistantActiveContext: hasActiveContext,
    footerConfiguration: .contentOnly,
    onSelectTab: selectTab,
    onSelectAssistant: openAssistant,
    content: { content },
    footerPlayer: { footerPlayer },
    assistantIcon: { isSelected in assistantIcon(isSelected) }
)

AVAppShellStandardScaffold(
    selectedTabID: selectedTab,
    tabs: tabs,
    assistantID: assistantTab,
    assistantName: "Avi",
    assistantAccessibilityIdentifier: "tab.avi",
    assistantAssetName: "AviFooterIcon",
    hasAssistantActiveContext: hasActiveContext,
    footerConfiguration: .contentOnly,
    onSelectTab: selectTab,
    onSelectAssistant: openAssistant,
    content: { content },
    footerPlayer: { footerPlayer }
)

AVAppShellFooterAssistantAssetIcon(assetName: "AviFooterIcon")

AVAppShellScrollableScreenScaffold {
    productShellBackground
} content: {
    productScreenHeader
    productDomainContent
}

AVAppShellHomeHeader(
    title: "Product AV",
    subtitle: "Product-specific Home summary."
) {
    productBrandHeader
} content: {
    productHomeIntro
}

AVAppShellShowMoreButton(
    title: "Show 12 more",
    action: showMore
)
AVAppShellIconButton(
    systemName: "gearshape.fill",
    accessibilityLabel: "Settings",
    accessibilityIdentifier: "header.settings",
    action: openSettings
)
AVAppShellBrandHeaderScaffold(
    leading: { settingsButton },
    logo: { wordmark },
    trailing: { accountButton }
)
AVAppShellDetailHeaderScaffold(
    title: "Featured item",
    subtitle: "Current activity",
    status: "Active",
    accessibilityIdentifier: "item.detail.header",
    leading: { backButton },
    accessory: { statusBadge }
)
AVAppShellSectionHeader(title: "Featured") {
    sectionActions
}
AVAppShellSearchField(
    query: $query,
    prompt: "Search",
    clearTitle: "Clear",
    focusRequest: focusToken
)
```

The product owns reusable shell layout, footer glass styling, tab affordances, and assistant entry treatment. Product-specific apps keep their own tab model, localized labels, assistant assets, navigation, playback, and business rules.

### AVLaunchFoundation

`AVLaunchFoundation` provides shared splash and launch transition primitives:

```swift
import AVLaunchFoundation

AVSplashScreen(
    content: ProductAppExperience.splashContent,
    logo: { logo },
    hero: { hero }
)
```

Use `AVSplashTransitionPolicy` and `AVSplashTransitionState` from the host app to keep launch timing and one-shot presentation consistent while preserving app-specific test flags, assets, and startup work.

Apps that use `AVCommonAppExperience` should prefer the configured splash
wrapper from `AVSettingsFoundation`. It reads splash logo, optional hero
artwork, assistant artwork, copy, and brand palette from the app experience:

```swift
import AVSettingsFoundation

struct ProductSplashView: View {
    var body: some View {
        AVConfiguredSplashScreen()
    }
}
```

Use the lower-level `AVSplashScreen` only when the product needs a fully custom
launch hero while preserving the shared launch layout.

### AVSettingsFoundation

`AVSettingsFoundation` provides reusable settings, account, and legal surface primitives:

```swift
import AVSettingsFoundation

AVSettingsCardBackground()
AVSettingsSheetScaffold(backgroundStyle: AnyShapeStyle(appBackground), closeTitle: "Done", onClose: dismiss) {
    content
}
AVSettingsScreenHeader(title: "Settings", subtitle: "Manage account and preferences")
AVSettingsSheetHeader(title: "Local storage", subtitle: "Choose what to clear")
AVSettingsSectionHeader(title: "Account", subtitle: "Manage your AV account")
AVSettingsSectionCard(title: "Account", subtitle: "Manage your AV account") {
    AVSettingsInfoRow(systemImage: "person.crop.circle", title: "Account", detail: "Signed in")
}
AVSettingsNoticeCard(systemImage: "person.2", title: "Shared account", detail: "This affects all AV apps.")
AVSettingsStatusCard(systemImage: "checkmark.shield", title: "Ready", detail: "Your account is eligible.")
AVSettingsDetailCard(title: "Linked service", detail: "Review the connected service before continuing.", linkTitle: "Manage", linkDestination: serviceURL)
AVSettingsDetailList(items: [
    AVSettingsDetailListItem(id: "service", title: "Connected service", detail: "Review this before continuing.", linkTitle: "Manage", linkDestination: serviceURL)
])
AVSettingsTextField("DELETE", text: $confirmationText, accessibilityIdentifier: "account.confirmation")
AVSettingsLoadingState("Loading account")
AVSettingsDestructiveActionCard(sectionTitle: "Danger zone", systemImage: "trash", title: "Clear data", detail: "Remove local data") { }
AVSettingsInfoRow(systemImage: "person.crop.circle", title: "Account", detail: "Signed in")
AVSettingsInfoSection(title: "About", subtitle: "Common app details", items: [
    AVSettingsInfoSectionItem(id: "plan", systemImage: "sparkles", title: "Plan", detail: "Active")
])
AVSettingsHelpLegalSection(
    title: "Help",
    subtitle: "Support, policies, and account safety.",
    openSourceTitle: "Built on Apps AV",
    openSourceDetail: "This app shares common Apps AV foundations.",
    sourceCodeURL: sourceCodeURL,
    legalLinks: ProductAppExperience.experience.legalLinks,
    supportDetail: "Open product support.",
    privacyDetail: "Review how product data is handled.",
    termsDetail: "Review product terms.",
    accountDeletionDetail: "Open account deletion.",
    openURL: openURL
)
let profileCopy = AVSettingsProfileCopy(identity: ProductAppExperience.experience.identity)
profileCopy.title(for: .settings)
profileCopy.subtitle(for: .account)
AVSettingsToggleRow(systemImage: "bell", title: "Alerts", detail: "Show important warnings", isOn: $isOn)
AVSettingsButton(title: "Continue", style: .primary) { }
AVSettingsButton(title: "Delete account", style: .destructivePrimary, isLoading: isDeleting) { }
AVSettingsLinkButton(title: "Manage account", systemImage: "safari", destination: accountURL)
AVSettingsOptionButton(title: "System", systemImage: "gearshape", isSelected: true) { }
AVAuthProviderButton(title: "Continue with Apple", isLoading: false, style: .dark, action: signIn) {
    Image(systemName: "applelogo")
}
AVAuthOptionsPanelScaffold(
    title: "Save your account",
    subtitle: "Continue with your preferred provider.",
    legalConsentText: legalText,
    skipTitle: "Not now",
    onSkip: skip
) {
    providerButtons
}
AVOnboardingCallToActionSection(
    primaryTitle: "Continue",
    secondaryTitle: "Skip",
    primaryAction: continueFlow,
    secondaryAction: skip
) {
    companion
}
AVOnboardingHeroText(title: "Meet Avi", subtitle: "A helpful companion for your app.")
AVSettingsGroupedActionList(title: "Local data") {
    AVSettingsGroupedActionRow(
        systemImage: "clock",
        title: "Clear recents",
        detail: "Remove recent activity",
        showsDivider: true
    ) { }
    AVSettingsGroupedActionRow(
        systemImage: "slider.horizontal.3",
        title: "Reset settings",
        detail: "Restore defaults"
    ) { }
}
```

The product owns shared layout and styling only. Host apps keep their account state, legal URLs, deletion policies, settings models, and localized copy.

### AVAviFoundation

`AVAviFoundation` provides reusable Avi visual primitives for Apple apps:

```swift
import AVAviFoundation

AVAviCompanionCard(
    title: "Avi",
    detail: "Ready when you are",
    actionAccessibilityLabel: "Open Avi",
    action: openAvi,
    avatar: { avatar }
)

AVAviScreenHeader(
    title: "Ask Avi",
    summary: "Signals and suggestions",
    accessibilityIdentifier: "avi.header",
    avatar: { avatar }
)

let landingContent = AVAviLandingContent(
    eyebrow: "Avi guide",
    title: "Avi keeps work moving",
    detail: "Use Avi for focused guidance across the product workflow.",
    chips: [
        AVAviLandingChip(title: "Create", systemImage: "sparkles"),
        AVAviLandingChip(title: "Review", systemImage: "checkmark.circle")
    ],
    accessibilityIdentifier: "avi.hero"
)

AVAviLandingHeroCard(content: landingContent) {
    avatar
}

AVAviFocusedHeaderScaffold(
    label: "Focused",
    title: "Avi is ready",
    summary: "Reading the current context",
    accessibilityValue: "static:focused",
    avatar: { avatar }
)

AVAviPreviewPrimaryButton(
    title: "Start with Avi",
    systemImage: "sparkles",
    accessibilityIdentifier: "avi.preview.primary",
    action: start
)

AVAviPreviewCapabilityRow(
    systemImage: "text.quote",
    title: "Understands context",
    detail: "Uses current app signals to suggest next steps"
)

AVAviPanelOptionButton(
    title: "Open details",
    systemImage: "info.circle",
    accessibilityIdentifier: "avi.actions.details",
    action: openDetails
)

AVAviPopoverActionPanel(
    title: "Ask Avi",
    pageLabel: "1 of 2",
    showsPagingControls: true,
    canGoPrevious: false,
    canGoNext: true,
    previousAccessibilityLabel: "Previous options",
    nextAccessibilityLabel: "More options",
    closeAccessibilityLabel: "Close options",
    nextPage: showNextPage,
    close: closePanel
) {
    actions
}

AVAviAvatarBadge(backgroundStyle: .muted) {
    Image("AviHead")
        .resizable()
        .scaledToFit()
}

AVAviStableAssetImage(
    value: emotion,
    width: 58,
    assetName: { $0.assetName },
    transitionPriority: { $0.priority }
)
```

The product owns shared companion cards, headers, command controls, panel chrome, and generic reaction effects. Host apps keep their Avi personality model, assets, recommendation logic, playback, account state, and localized copy.

### AVPaywallFoundation

`AVPaywallFoundation` provides reusable paywall and upgrade prompt surfaces:

```swift
import AVPaywallFoundation

AVPaywallHeader(
    eyebrow: "Pro",
    title: "Unlock more",
    subtitle: "More capacity and richer assistant actions"
)

AVPlanComparisonCard(
    title: "Pro",
    subtitle: "For frequent use",
    rows: ["Unlimited assistant actions"],
    isHighlighted: true
)

AVPaywallBenefitList(items: [
    AVPaywallBenefitItem(id: "sync", systemImage: "icloud", title: "Sync", detail: "Keep data available across AV apps")
])

AVPaywallPrimaryButton(
    title: "Continue",
    accessibilityIdentifier: "paywall.continue",
    action: continueAction
)

AVUpgradePromptSheet(
    eyebrow: "Limit reached",
    title: "Upgrade to continue",
    message: "You have reached today's limit.",
    primaryButtonTitle: "View plans",
    dismissButtonTitle: "Not now",
    accessibilityIdentifier: "upgrade.sheet",
    onPrimaryAction: showPlans,
    onDismiss: dismiss
)
```

The product owns shared paywall layout, benefit rows, status rows, legal link styling, offer card chrome, and upgrade prompt sheet styling. Host apps keep product IDs, purchase services, entitlement resolution, usage rules, localized copy, legal URLs, and App Store billing behavior.

### AVHaptics

`AVHaptics` provides a semantic haptics API for common app events:

```swift
import AVHaptics

AVHaptics.perform(.affirm)
AVHaptics.perform(.impactLight)
AVHaptics.perform(.primaryAction)
AVHaptics.perform(.dismissiveFeedback)
AVHaptics.perform(.warning)
```

Use app-generic events such as `primaryAction`, `step`, `affirm`, `undo`,
`positiveFeedback`, `negativeFeedback`, and `dismissiveFeedback`. Product apps
adapt their domain actions into generic Apps AV feedback before calling this
API.

The implementation uses native platform feedback:

- iOS: `UISelectionFeedbackGenerator`, `UIImpactFeedbackGenerator`, and `UINotificationFeedbackGenerator`
- macOS: `NSHapticFeedbackManager`

## Domain Audit

Last audited: 2026-05-22.

| Area | Decision | Notes |
| --- | --- | --- |
| `AVAppShellFoundation` player/footer primitives | Keep in Apps AV | Footer player APIs use `primaryTitle` and `primaryAction`; product apps adapt station or media names before entering Apps AV. |
| `AVAppShellFoundation` status/search/shell primitives | Keep in Apps AV | `AVCompactStatusBadge`, search fields, section headers, tabs, and shell scaffolds describe reusable chrome. Host apps own result models, filters, routes, labels, and playback state. |
| `AVLaunchFoundation` splash primitives | Keep in Apps AV | Splash accepts product-provided logo, hero, tagline, and status. Internal backdrop names are neutral; product apps own launch copy, assets, startup work, and test flags. |
| `AVAviFoundation` assistant primitives | Keep in Apps AV | Avi components are visual assistant primitives: cards, headers, avatar containers, preview controls, suggested item rows, action controls, panels, and generic reactions. Product apps own Avi personality, assets, prompts, recommendations, and domain actions. |
| `AVHaptics` semantic events | Keep in Apps AV with generic names | Uses app-generic events such as `primaryAction`, `secondaryAction`, `step`, `stopAction`, `affirm`, `undo`, `positiveFeedback`, `negativeFeedback`, and `dismissiveFeedback`. Product apps adapt domain actions before calling Apps AV. |
| `AVBrandFoundation` tokens | Keep in Apps AV with semantic names | `AVBrandColor` owns defaults, `AVBrandPalette` owns app-provided overrides, and `AVBrandSurface` owns reusable surfaces. Apps AV internals avoid brand-specific or signal-specific token names. |

## Installation

During local development, add the package by path:

```swift
.package(path: "../apps-av/apple")
```

For app repositories that live next to this package, use the relative path that matches the app project, such as `../../../apps-av/apple`.

When publishing a stable release, prefer pinning this package by Git tag.

## Requirements

- iOS 18+
- macOS 14+
- Swift 6
