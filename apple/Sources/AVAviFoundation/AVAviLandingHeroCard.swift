import AVBrandFoundation
import SwiftUI

public struct AVAviLandingChip: Hashable, Sendable {
    public var title: String
    public var systemImage: String

    public init(title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }
}

public struct AVAviLandingContent: Hashable, Sendable {
    public var eyebrow: String
    public var title: String
    public var detail: String
    public var chips: [AVAviLandingChip]
    public var accessibilityIdentifier: String?

    public init(
        eyebrow: String,
        title: String,
        detail: String,
        chips: [AVAviLandingChip] = [],
        accessibilityIdentifier: String? = nil
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.detail = detail
        self.chips = chips
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public struct AVAviLandingHeroCard<Avatar: View>: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let eyebrow: String
    private let title: String
    private let detail: String
    private let chips: [AVAviLandingChip]
    private let accessibilityIdentifier: String?
    private let avatar: Avatar

    public init(
        eyebrow: String,
        title: String,
        detail: String,
        chips: [AVAviLandingChip] = [],
        accessibilityIdentifier: String? = nil,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.detail = detail
        self.chips = chips
        self.accessibilityIdentifier = accessibilityIdentifier
        self.avatar = avatar()
    }

    public init(
        content: AVAviLandingContent,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.init(
            eyebrow: content.eyebrow,
            title: content.title,
            detail: content.detail,
            chips: content.chips,
            accessibilityIdentifier: content.accessibilityIdentifier,
            avatar: avatar
        )
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.lg) {
            HStack(alignment: .top, spacing: AVBrandSpacing.lg) {
                VStack(alignment: .leading, spacing: AVBrandSpacing.xs) {
                    Text(eyebrow)
                        .font(AVBrandTypography.eyebrow)
                        .foregroundStyle(brandPalette.accent)
                        .textCase(.uppercase)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    Text(title)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.76)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                avatar
                    .padding(7)
                    .background(brandPalette.accent.opacity(0.09), in: Circle())
                    .accessibilityHidden(true)
            }

            if !chips.isEmpty {
                HStack(spacing: AVBrandSpacing.xs) {
                    ForEach(chips, id: \.self) { chip in
                        AVAviPreviewChip(title: chip.title, systemImage: chip.systemImage)
                    }
                }
            }

            Text(detail)
                .font(AVBrandTypography.bodyStrong)
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AVBrandSpacing.xxl)
        .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.panel, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.panel, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.45), lineWidth: 1)
        }
        .shadow(color: AVBrandColor.softShadow.opacity(0.12), radius: 14, y: 7)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}
