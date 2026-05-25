import AVAviFoundation
import SwiftUI

public struct AVConfiguredAviAvatarBadge: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    private let imageSize: CGFloat
    private let badgeSize: CGFloat
    private let padding: CGFloat
    private let backgroundStyle: AVAviAvatarBadgeBackground
    private let strokeStyle: AVAviAvatarBadgeStroke
    private let fallbackAssetName: String

    public init(
        imageSize: CGFloat = 22,
        badgeSize: CGFloat = 36,
        padding: CGFloat = 0,
        backgroundStyle: AVAviAvatarBadgeBackground = .muted,
        strokeStyle: AVAviAvatarBadgeStroke = .subtle,
        fallbackAssetName: String = "AviFooterIcon"
    ) {
        self.imageSize = imageSize
        self.badgeSize = badgeSize
        self.padding = padding
        self.backgroundStyle = backgroundStyle
        self.strokeStyle = strokeStyle
        self.fallbackAssetName = fallbackAssetName
    }

    public var body: some View {
        AVAviAssetAvatarBadge(
            assetName: appExperience.visualAssets?.footerAssistantName ?? fallbackAssetName,
            imageSize: imageSize,
            badgeSize: badgeSize,
            padding: padding,
            backgroundStyle: backgroundStyle,
            strokeStyle: strokeStyle
        )
    }
}
