import AVBrandFoundation
import SwiftUI

public struct AVPaywallOfferCard<Avatar: View, RestoreButton: View>: View {
    private let title: String
    private let detail: String
    private let primaryButtonTitle: String
    private let primaryButtonIsDisabled: Bool
    private let primaryAccessibilityIdentifier: String
    private let primaryAction: () -> Void
    private let avatar: Avatar
    private let restoreButton: RestoreButton

    public init(
        title: String,
        detail: String,
        primaryButtonTitle: String,
        primaryButtonIsDisabled: Bool = false,
        primaryAccessibilityIdentifier: String = "paywall.purchase",
        primaryAction: @escaping () -> Void,
        @ViewBuilder avatar: () -> Avatar,
        @ViewBuilder restoreButton: () -> RestoreButton
    ) {
        self.title = title
        self.detail = detail
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonIsDisabled = primaryButtonIsDisabled
        self.primaryAccessibilityIdentifier = primaryAccessibilityIdentifier
        self.primaryAction = primaryAction
        self.avatar = avatar()
        self.restoreButton = restoreButton()
    }

    public var body: some View {
        VStack(spacing: 13) {
            HStack(alignment: .center, spacing: 13) {
                avatar
                    .frame(width: 68, height: 68)

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(AVBrandTypography.cardTitle)
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.86)

                    Text(detail)
                        .font(AVBrandTypography.captionStrong)
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            AVPaywallPrimaryButton(
                title: primaryButtonTitle,
                isDisabled: primaryButtonIsDisabled,
                accessibilityIdentifier: primaryAccessibilityIdentifier,
                action: primaryAction
            )

            restoreButton
        }
        .padding(AVBrandSpacing.lg)
        .background(AVBrandColor.cardSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous)
                .stroke(AVBrandColor.accent.opacity(0.32), lineWidth: 1.5)
        }
        .shadow(color: AVBrandColor.softShadow.opacity(0.18), radius: 12, y: 6)
    }
}

public struct AVPaywallPrimaryButton: View {
    private let title: String
    private let isDisabled: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        isDisabled: Bool = false,
        accessibilityIdentifier: String = "paywall.primary",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.brandBlack)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    AVBrandColor.accent,
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.control, style: .continuous)
                )
        }
        .disabled(isDisabled)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVPaywallOfferCard where RestoreButton == EmptyView {
    init(
        title: String,
        detail: String,
        primaryButtonTitle: String,
        primaryButtonIsDisabled: Bool = false,
        primaryAccessibilityIdentifier: String = "paywall.purchase",
        primaryAction: @escaping () -> Void,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.title = title
        self.detail = detail
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonIsDisabled = primaryButtonIsDisabled
        self.primaryAccessibilityIdentifier = primaryAccessibilityIdentifier
        self.primaryAction = primaryAction
        self.avatar = avatar()
        self.restoreButton = EmptyView()
    }
}

public struct AVPaywallRestoreButton: View {
    private let title: String
    private let isDisabled: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        isDisabled: Bool = false,
        accessibilityIdentifier: String = "paywall.restore",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isDisabled = isDisabled
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .background(AVBrandSurface.shellBackground, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .disabled(isDisabled)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
