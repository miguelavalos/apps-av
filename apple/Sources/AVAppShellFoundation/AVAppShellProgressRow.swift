import AVBrandFoundation
import SwiftUI

public struct AVAppShellProgressRow: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let detail: String
    private let systemImage: String
    private let stateSystemImage: String?
    private let stateTint: Color?
    private let titleFont: Font
    private let detailFont: Font

    public init(
        title: String,
        detail: String,
        systemImage: String,
        isComplete: Bool,
        titleFont: Font = .caption.weight(.semibold),
        detailFont: Font = .caption
    ) {
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.stateSystemImage = isComplete ? "checkmark.circle.fill" : nil
        self.stateTint = nil
        self.titleFont = titleFont
        self.detailFont = detailFont
    }

    public init(
        title: String,
        detail: String,
        systemImage: String,
        stateSystemImage: String,
        stateTint: Color,
        titleFont: Font = .caption.weight(.semibold),
        detailFont: Font = .caption2
    ) {
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.stateSystemImage = stateSystemImage
        self.stateTint = stateTint
        self.titleFont = titleFont
        self.detailFont = detailFont
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.sm) {
            if let stateSystemImage {
                Image(systemName: stateSystemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(stateTint ?? brandPalette.accent)
                    .frame(width: 18)
            }

            Image(systemName: systemImage)
                .font(.caption.weight(.semibold))
                .foregroundStyle(stateSystemImage == nil ? AVBrandColor.textSecondary : AVBrandColor.textSecondary.opacity(0.82))
                .frame(width: 18)

            VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                Text(title)
                    .font(titleFont)
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)

                Text(detail)
                    .font(detailFont)
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
