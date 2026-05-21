import AVBrandFoundation
import SwiftUI

public struct AVPaywallHeader: View {
    private let eyebrow: String
    private let title: String
    private let subtitle: String

    public init(eyebrow: String, title: String, subtitle: String) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.xs) {
            Text(eyebrow)
                .font(AVBrandTypography.eyebrow)
                .foregroundStyle(AVBrandColor.accent)
                .textCase(.uppercase)

            Text(title)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.82)

            Text(subtitle)
                .font(AVBrandTypography.bodyStrong)
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineLimit(2)
                .minimumScaleFactor(0.84)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
