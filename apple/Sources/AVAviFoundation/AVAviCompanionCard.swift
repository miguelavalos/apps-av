import AVBrandFoundation
import SwiftUI

public struct AVAviCompanionCard<Avatar: View>: View {
    private let title: String
    private let detail: String
    private let actionSystemImage: String
    private let actionAccessibilityLabel: String
    private let accessibilityIdentifier: String?
    private let action: () -> Void
    private let avatar: Avatar

    public init(
        title: String,
        detail: String,
        actionSystemImage: String = "sparkles",
        actionAccessibilityLabel: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.title = title
        self.detail = detail
        self.actionSystemImage = actionSystemImage
        self.actionAccessibilityLabel = actionAccessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.avatar = avatar()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: AVBrandSpacing.lg) {
            avatar
                .padding(6)
                .background(AVBrandColor.accent.opacity(0.12), in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(detail)
                    .font(AVBrandTypography.captionStrong)
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: AVBrandSpacing.xs)

            Button(action: action) {
                Image(systemName: actionSystemImage)
                    .font(.system(size: 15, weight: .black))
                    .foregroundStyle(AVBrandColor.brandBlack)
                    .frame(width: 42, height: 42)
                    .background(AVBrandColor.accent, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(actionAccessibilityLabel)
            .accessibilityIdentifierIfPresent(accessibilityIdentifier)
        }
        .padding(AVBrandSpacing.xl)
        .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.64), lineWidth: 1)
        }
    }
}

extension View {
    @ViewBuilder
    package func accessibilityIdentifierIfPresent(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
