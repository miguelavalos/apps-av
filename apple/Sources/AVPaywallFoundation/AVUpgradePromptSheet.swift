import AVBrandFoundation
import SwiftUI

public struct AVUpgradePromptSheet: View {
    private let iconSystemImage: String
    private let eyebrow: String
    private let title: String
    private let message: String
    private let primaryButtonTitle: String
    private let primaryButtonIsDisabled: Bool
    private let dismissButtonTitle: String
    private let accessibilityIdentifier: String
    private let primaryAccessibilityIdentifier: String
    private let dismissAccessibilityIdentifier: String
    private let onPrimaryAction: () -> Void
    private let onDismiss: () -> Void

    public init(
        iconSystemImage: String = "sparkles",
        eyebrow: String,
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryButtonIsDisabled: Bool = false,
        dismissButtonTitle: String,
        accessibilityIdentifier: String,
        primaryAccessibilityIdentifier: String = "limits.upgrade.primary",
        dismissAccessibilityIdentifier: String = "limits.upgrade.dismiss",
        onPrimaryAction: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.iconSystemImage = iconSystemImage
        self.eyebrow = eyebrow
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonIsDisabled = primaryButtonIsDisabled
        self.dismissButtonTitle = dismissButtonTitle
        self.accessibilityIdentifier = accessibilityIdentifier
        self.primaryAccessibilityIdentifier = primaryAccessibilityIdentifier
        self.dismissAccessibilityIdentifier = dismissAccessibilityIdentifier
        self.onPrimaryAction = onPrimaryAction
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.cardPadding) {
            HStack(spacing: AVBrandSpacing.lg) {
                Image(systemName: iconSystemImage)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(AVBrandColor.textInverse)
                    .frame(width: 48, height: 48)
                    .background(AVBrandColor.accent, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))

                VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                    Text(eyebrow)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AVBrandColor.accent)
                        .textCase(.uppercase)

                    Text(title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(AVBrandColor.textPrimary)
                }
            }

            Text(message)
                .font(AVBrandTypography.body)
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("limits.upgrade.message")

            VStack(spacing: AVBrandSpacing.md) {
                Button(action: onPrimaryAction) {
                    Text(primaryButtonTitle)
                        .font(AVBrandTypography.button)
                        .foregroundStyle(AVBrandColor.textInverse)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AVBrandSpacing.lg)
                        .background(AVBrandColor.accent, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
                }
                .disabled(primaryButtonIsDisabled)
                .accessibilityIdentifier(primaryAccessibilityIdentifier)

                Button(action: onDismiss) {
                    Text(dismissButtonTitle)
                        .font(AVBrandTypography.button)
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AVBrandSpacing.lg)
                        .background(AVBrandColor.mutedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
                }
                .accessibilityIdentifier(dismissAccessibilityIdentifier)
            }
        }
        .padding(AVBrandRadius.panel)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(AVBrandSurface.shellBackground.ignoresSafeArea())
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
