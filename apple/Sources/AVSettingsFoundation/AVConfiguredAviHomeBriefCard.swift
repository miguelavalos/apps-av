import AVAviFoundation
import SwiftUI

public struct AVConfiguredAviHomeBriefCard: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    private let detail: String
    private let actionAccessibilityLabel: String
    private let accessibilityIdentifier: String
    private let imageSize: CGFloat
    private let badgeSize: CGFloat
    private let backgroundStyle: AVAviAvatarBadgeBackground
    private let strokeStyle: AVAviAvatarBadgeStroke
    private let openAvi: () -> Void

    public init(
        detail: String,
        actionAccessibilityLabel: String,
        accessibilityIdentifier: String,
        imageSize: CGFloat = 58,
        badgeSize: CGFloat = 58,
        backgroundStyle: AVAviAvatarBadgeBackground = .accentSoft,
        strokeStyle: AVAviAvatarBadgeStroke = .accentSoft,
        openAvi: @escaping () -> Void
    ) {
        self.detail = detail
        self.actionAccessibilityLabel = actionAccessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.imageSize = imageSize
        self.badgeSize = badgeSize
        self.backgroundStyle = backgroundStyle
        self.strokeStyle = strokeStyle
        self.openAvi = openAvi
    }

    public var body: some View {
        AVAviHomeBriefCard(
            identity: appExperience.identity,
            detail: detail,
            actionAccessibilityLabel: actionAccessibilityLabel,
            accessibilityIdentifier: accessibilityIdentifier,
            openAvi: openAvi
        ) {
            AVConfiguredAviAvatarBadge(
                imageSize: imageSize,
                badgeSize: badgeSize,
                backgroundStyle: backgroundStyle,
                strokeStyle: strokeStyle
            )
        }
    }
}
