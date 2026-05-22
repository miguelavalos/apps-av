import AVBrandFoundation
import SwiftUI

public struct AVPaywallBenefitRow: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let systemImage: String
    private let title: String
    private let detail: String

    public init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(brandPalette.accent)
                .frame(width: 32, height: 32)
                .background(brandPalette.accent.opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Text(detail)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.84)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(11)
        .background(AVBrandColor.cardSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.control, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.control, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.58), lineWidth: 1)
        }
    }
}

public struct AVPaywallBenefitItem: Identifiable {
    public let id: String
    public let systemImage: String
    public let title: String
    public let detail: String

    public init(id: String, systemImage: String, title: String, detail: String) {
        self.id = id
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }
}

public struct AVPaywallBenefitList: View {
    private let items: [AVPaywallBenefitItem]
    private let spacing: CGFloat

    public init(items: [AVPaywallBenefitItem], spacing: CGFloat = 8) {
        self.items = items
        self.spacing = spacing
    }

    public var body: some View {
        VStack(spacing: spacing) {
            ForEach(items) { item in
                AVPaywallBenefitRow(
                    systemImage: item.systemImage,
                    title: item.title,
                    detail: item.detail
                )
            }
        }
    }
}

public struct AVPaywallStatusRow: View {
    private let systemImage: String
    private let message: String

    public init(systemImage: String, message: String) {
        self.systemImage = systemImage
        self.message = message
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .bold))

            Text(message)
                .font(.system(size: 14, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)
        }
        .foregroundStyle(AVBrandColor.textSecondary)
        .padding(AVBrandSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AVBrandColor.mutedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
    }
}

public struct AVPaywallLegalLinks: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let links: [AVPaywallLegalLink]

    public init(links: [AVPaywallLegalLink]) {
        self.links = links
    }

    public var body: some View {
        HStack(spacing: AVBrandSpacing.xxl) {
            ForEach(links) { link in
                Button(action: link.action) {
                    Text(link.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                        .allowsTightening(true)
                }
                .accessibilityIdentifier(link.accessibilityIdentifier)
            }
        }
        .font(AVBrandTypography.captionStrong)
        .foregroundStyle(brandPalette.accent)
    }
}

public struct AVPaywallLegalLink: Identifiable {
    public let id = UUID()
    public let title: String
    public let accessibilityIdentifier: String
    public let action: () -> Void

    public init(title: String, accessibilityIdentifier: String, action: @escaping () -> Void) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }
}
