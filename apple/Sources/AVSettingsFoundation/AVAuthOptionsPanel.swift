import SwiftUI

public struct AVAuthOptionsPanel<Accessory: View>: View {
    private let title: String
    private let subtitle: String
    private let legalConsentText: AttributedString
    private let unavailableMessage: String?
    private let skipTitle: String?
    private let actionsAreDisabled: Bool
    private let appleTitle: String
    private let googleTitle: String
    private let isBusy: Bool
    private let activeProvider: AVAuthProvider?
    private let isAvailable: Bool
    private let appleAccessibilityIdentifier: String?
    private let googleAccessibilityIdentifier: String?
    private let onApple: () -> Void
    private let onGoogle: () -> Void
    private let onSkip: (() -> Void)?
    private let accessory: Accessory

    public init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String? = nil,
        actionsAreDisabled: Bool = false,
        appleTitle: String = "Continue with Apple",
        googleTitle: String = "Continue with Google",
        isBusy: Bool = false,
        activeProvider: AVAuthProvider? = nil,
        isAvailable: Bool = true,
        appleAccessibilityIdentifier: String? = nil,
        googleAccessibilityIdentifier: String? = nil,
        onApple: @escaping () -> Void,
        onGoogle: @escaping () -> Void,
        onSkip: (() -> Void)? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.legalConsentText = legalConsentText
        self.unavailableMessage = unavailableMessage
        self.skipTitle = skipTitle
        self.actionsAreDisabled = actionsAreDisabled
        self.appleTitle = appleTitle
        self.googleTitle = googleTitle
        self.isBusy = isBusy
        self.activeProvider = activeProvider
        self.isAvailable = isAvailable
        self.appleAccessibilityIdentifier = appleAccessibilityIdentifier
        self.googleAccessibilityIdentifier = googleAccessibilityIdentifier
        self.onApple = onApple
        self.onGoogle = onGoogle
        self.onSkip = onSkip
        self.accessory = accessory()
    }

    public var body: some View {
        AVAuthOptionsPanelScaffold(
            title: title,
            subtitle: subtitle,
            legalConsentText: legalConsentText,
            unavailableMessage: unavailableMessage,
            skipTitle: skipTitle,
            actionsAreDisabled: actionsAreDisabled || isBusy || !isAvailable,
            onSkip: onSkip
        ) {
            AVSettingsSignInActions(
                appleTitle: appleTitle,
                googleTitle: googleTitle,
                isBusy: isBusy,
                activeProvider: activeProvider,
                isAvailable: isAvailable,
                appleAccessibilityIdentifier: appleAccessibilityIdentifier,
                googleAccessibilityIdentifier: googleAccessibilityIdentifier,
                onApple: onApple,
                onGoogle: onGoogle
            )
        } accessory: {
            accessory
        }
    }
}

public extension AVAuthOptionsPanel where Accessory == EmptyView {
    init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String? = nil,
        actionsAreDisabled: Bool = false,
        appleTitle: String = "Continue with Apple",
        googleTitle: String = "Continue with Google",
        isBusy: Bool = false,
        activeProvider: AVAuthProvider? = nil,
        isAvailable: Bool = true,
        appleAccessibilityIdentifier: String? = nil,
        googleAccessibilityIdentifier: String? = nil,
        onApple: @escaping () -> Void,
        onGoogle: @escaping () -> Void,
        onSkip: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            legalConsentText: legalConsentText,
            unavailableMessage: unavailableMessage,
            skipTitle: skipTitle,
            actionsAreDisabled: actionsAreDisabled,
            appleTitle: appleTitle,
            googleTitle: googleTitle,
            isBusy: isBusy,
            activeProvider: activeProvider,
            isAvailable: isAvailable,
            appleAccessibilityIdentifier: appleAccessibilityIdentifier,
            googleAccessibilityIdentifier: googleAccessibilityIdentifier,
            onApple: onApple,
            onGoogle: onGoogle,
            onSkip: onSkip,
            accessory: { EmptyView() }
        )
    }
}
