import SwiftUI

public enum AVAuthProvider: Sendable {
    case apple
    case google
}

public struct AVSettingsSignInActions: View {
    private let appleTitle: String
    private let googleTitle: String
    private let isBusy: Bool
    private let activeProvider: AVAuthProvider?
    private let isAvailable: Bool
    private let appleAccessibilityIdentifier: String?
    private let googleAccessibilityIdentifier: String?
    private let onApple: () -> Void
    private let onGoogle: () -> Void

    public init(
        appleTitle: String = "Continue with Apple",
        googleTitle: String = "Continue with Google",
        isBusy: Bool = false,
        activeProvider: AVAuthProvider? = nil,
        isAvailable: Bool = true,
        appleAccessibilityIdentifier: String? = nil,
        googleAccessibilityIdentifier: String? = nil,
        onApple: @escaping () -> Void,
        onGoogle: @escaping () -> Void
    ) {
        self.appleTitle = appleTitle
        self.googleTitle = googleTitle
        self.isBusy = isBusy
        self.activeProvider = activeProvider
        self.isAvailable = isAvailable
        self.appleAccessibilityIdentifier = appleAccessibilityIdentifier
        self.googleAccessibilityIdentifier = googleAccessibilityIdentifier
        self.onApple = onApple
        self.onGoogle = onGoogle
    }

    public var body: some View {
        VStack(spacing: 10) {
            AVAuthProviderButton(
                title: appleTitle,
                isLoading: appleIsLoading,
                style: .dark,
                action: onApple
            ) {
                Image(systemName: "applelogo")
                    .font(.system(size: 17, weight: .bold))
            }
            .avSettingsAccessibilityIdentifierIfPresent(appleAccessibilityIdentifier)

            AVAuthProviderButton(
                title: googleTitle,
                isLoading: googleIsLoading,
                style: .light,
                action: onGoogle
            ) {
                AVGoogleBadge()
            }
            .avSettingsAccessibilityIdentifierIfPresent(googleAccessibilityIdentifier)
        }
        .disabled(isBusy || !isAvailable)
    }

    private var appleIsLoading: Bool {
        activeProvider == nil ? isBusy : activeProvider == .apple
    }

    private var googleIsLoading: Bool {
        activeProvider == nil ? isBusy : activeProvider == .google
    }
}

private extension View {
    @ViewBuilder
    func avSettingsAccessibilityIdentifierIfPresent(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
