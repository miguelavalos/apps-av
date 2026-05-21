import AVBrandFoundation
import SwiftUI

public struct AVPaywallBenefitRow: View {
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
                .foregroundStyle(AVBrandColor.accent)
                .frame(width: 32, height: 32)
                .background(AVBrandColor.accent.opacity(0.1), in: Circle())

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
    private let links: [AVPaywallLegalLink]

    public init(links: [AVPaywallLegalLink]) {
        self.links = links
    }

    public var body: some View {
        HStack(spacing: AVBrandSpacing.xxl) {
            ForEach(links) { link in
                Button(link.title, action: link.action)
                    .accessibilityIdentifier(link.accessibilityIdentifier)
            }
        }
        .font(AVBrandTypography.captionStrong)
        .foregroundStyle(AVBrandColor.accent)
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
