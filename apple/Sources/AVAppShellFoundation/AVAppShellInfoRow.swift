import AVBrandFoundation
import SwiftUI

public struct AVAppShellInfoRow<Accessory: View>: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let detail: String
    private let systemImage: String
    private let eyebrow: String?
    private let accessibilityIdentifier: String?
    private let accessory: Accessory

    public init(
        title: String,
        detail: String,
        systemImage: String,
        eyebrow: String? = nil,
        accessibilityIdentifier: String? = nil,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.eyebrow = eyebrow
        self.accessibilityIdentifier = accessibilityIdentifier
        self.accessory = accessory()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(brandPalette.accent)
                .frame(width: 28, height: 28)
                .background(
                    brandPalette.accent.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous)
                )

            VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                if let eyebrow {
                    Text(eyebrow)
                        .font(.system(size: 11, weight: .black))
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .textCase(.uppercase)
                        .lineLimit(1)
                }

                Text(title)
                    .font(AVBrandTypography.captionStrong)
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.84)

                Text(detail)
                    .font(AVBrandTypography.caption)
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            accessory
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AVBrandSpacing.md)
        .background(AVBrandColor.cardSurface.opacity(0.72), in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.5), lineWidth: 1)
        }
        .avAppShellInfoRowAccessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}

public extension AVAppShellInfoRow where Accessory == EmptyView {
    init(
        title: String,
        detail: String,
        systemImage: String,
        eyebrow: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.init(
            title: title,
            detail: detail,
            systemImage: systemImage,
            eyebrow: eyebrow,
            accessibilityIdentifier: accessibilityIdentifier
        ) {
            EmptyView()
        }
    }
}

private extension View {
    @ViewBuilder
    func avAppShellInfoRowAccessibilityIdentifierIfPresent(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
