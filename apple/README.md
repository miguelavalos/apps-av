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
  `primaryTitle`, `footerPlayer`, `signalBadge`, `assistant`, `content`,
  `status`, and similar generic terms.

Host apps own their domain and adapt it into Apps AV primitives. For example,
a radio app may render a station through `AVSignalBadge` or
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
```

The product includes generic tokens for color, surface gradients, typography, spacing, radius, icon sizing, and motion. Product-specific apps should keep their local theme adapters when they need app-specific names.

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
    footerBackdropHeight: 210,
    footerPlayerTabSpacing: 10,
    onSelectTab: selectTab,
    onSelectAssistant: openAssistant,
    content: { content },
    footerPlayer: { footerPlayer },
    assistantIcon: { isSelected in assistantIcon(isSelected) }
)

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
    title: "Recently played",
    subtitle: "Your latest activity",
    status: "Library",
    accessibilityIdentifier: "library.detail.header",
    leading: { backButton },
    accessory: { statusBadge }
)
AVAppShellSectionHeader(title: "Recently played") {
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
    tagline: "Your product tagline",
    status: "Preparing your experience",
    logo: { logo },
    hero: { hero }
)
```

Use `AVSplashTransitionPolicy` and `AVSplashTransitionState` from the host app to keep launch timing and one-shot presentation consistent while preserving app-specific test flags, assets, and startup work.

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
AVSettingsNoticeCard(systemImage: "person.2", title: "Shared account", detail: "This affects all AV apps.")
AVSettingsStatusCard(systemImage: "checkmark.shield", title: "Ready", detail: "Your account is eligible.")
AVSettingsDetailCard(title: "Subscription", detail: "Manage your billing before deleting.", linkTitle: "Manage", linkDestination: billingURL)
AVSettingsDetailList(items: [
    AVSettingsDetailListItem(id: "subscription", title: "Active subscription", detail: "Manage billing first.", linkTitle: "Manage", linkDestination: billingURL)
])
AVSettingsTextField("DELETE", text: $confirmationText, accessibilityIdentifier: "account.confirmation")
AVSettingsLoadingState("Loading account")
AVSettingsDestructiveActionCard(sectionTitle: "Danger zone", systemImage: "trash", title: "Clear data", detail: "Remove local data") { }
AVSettingsInfoRow(systemImage: "person.crop.circle", title: "Account", detail: "Signed in")
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

AVAviFullPlayerHeaderScaffold(
    label: "Now listening",
    title: "Avi is tuned in",
    summary: "Reading the current signal",
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

AVHaptics.perform(.save)
AVHaptics.perform(.impactLight)
AVHaptics.perform(.playbackToggle)
AVHaptics.perform(.warning)
```

The implementation uses native platform feedback:

- iOS: `UISelectionFeedbackGenerator`, `UIImpactFeedbackGenerator`, and `UINotificationFeedbackGenerator`
- macOS: `NSHapticFeedbackManager`

## Installation

During local development, add the package by path:

```swift
.package(path: "../apps-av/apple")
```

For app repositories that live next to this package, use the relative path that matches the app project. For example, from `public/tune-av/apps/ios` the package path is `../../../apps-av/apple`.

When publishing a stable release, prefer pinning this package by Git tag.

## Requirements

- iOS 18+
- macOS 14+
- Swift 6
