import AVBrandFoundation
import SwiftUI

public struct AVAppShellInlineMessage: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String?
    private let message: String
    private let systemImage: String
    private let imageSize: CGFloat
    private let verticalPadding: CGFloat
    private let usesAccentIcon: Bool

    public init(
        title: String? = nil,
        message: String,
        systemImage: String = "info.circle",
        imageSize: CGFloat = 18,
        verticalPadding: CGFloat = 2,
        usesAccentIcon: Bool = false
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.imageSize = imageSize
        self.verticalPadding = verticalPadding
        self.usesAccentIcon = usesAccentIcon
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.sm) {
            Image(systemName: systemImage)
                .font(.system(size: min(imageSize, 20), weight: .semibold))
                .foregroundStyle(usesAccentIcon ? brandPalette.accent : AVBrandColor.textSecondary)
                .frame(width: imageSize)

            VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                if let title {
                    Text(title)
                        .font(AVBrandTypography.captionStrong)
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.84)
                }

                Text(message)
                    .font(AVBrandTypography.caption)
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.vertical, verticalPadding)
    }
}
