import AVBrandFoundation
import SwiftUI

public struct AVPaywallHeader: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let eyebrow: String
    private let title: String
    private let subtitle: String
    private let titleFontSize: CGFloat
    private let subtitleFontSize: CGFloat

    public init(
        eyebrow: String,
        title: String,
        subtitle: String,
        titleFontSize: CGFloat = 30,
        subtitleFontSize: CGFloat = 15
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.titleFontSize = titleFontSize
        self.subtitleFontSize = subtitleFontSize
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.xs) {
            Text(eyebrow)
                .font(AVBrandTypography.eyebrow)
                .foregroundStyle(brandPalette.accent)
                .textCase(.uppercase)

            Text(title)
                .font(.system(size: titleFontSize, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.82)

            Text(subtitle)
                .font(.system(size: subtitleFontSize, weight: .semibold, design: .rounded))
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineLimit(2)
                .minimumScaleFactor(0.84)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
