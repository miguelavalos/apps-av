import AVAviFoundation
import SwiftUI

public struct AVConfiguredAviGuidanceScreen<Content: View>: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    private let summary: String
    private let status: String?
    private let headerAccessibilityIdentifier: String
    private let landingContent: AVAviLandingContent
    private let backgroundStyle: AnyShapeStyle
    private let horizontalPadding: CGFloat
    private let topPadding: CGFloat
    private let bottomPadding: CGFloat
    private let spacing: CGFloat
    private let headerAvatarImageSize: CGFloat
    private let headerAvatarBadgeSize: CGFloat
    private let heroAvatarImageSize: CGFloat
    private let heroAvatarBadgeSize: CGFloat
    private let avatarBackgroundStyle: AVAviAvatarBadgeBackground
    private let avatarStrokeStyle: AVAviAvatarBadgeStroke
    private let content: Content

    public init(
        summary: String,
        status: String? = nil,
        headerAccessibilityIdentifier: String,
        landingContent: AVAviLandingContent,
        backgroundStyle: AnyShapeStyle,
        horizontalPadding: CGFloat = 18,
        topPadding: CGFloat = 18,
        bottomPadding: CGFloat = 132,
        spacing: CGFloat = 18,
        headerAvatarImageSize: CGFloat = 58,
        headerAvatarBadgeSize: CGFloat = 76,
        heroAvatarImageSize: CGFloat = 62,
        heroAvatarBadgeSize: CGFloat = 78,
        avatarBackgroundStyle: AVAviAvatarBadgeBackground = .accentSoft,
        avatarStrokeStyle: AVAviAvatarBadgeStroke = .accentSoft,
        @ViewBuilder content: () -> Content
    ) {
        self.summary = summary
        self.status = status
        self.headerAccessibilityIdentifier = headerAccessibilityIdentifier
        self.landingContent = landingContent
        self.backgroundStyle = backgroundStyle
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.spacing = spacing
        self.headerAvatarImageSize = headerAvatarImageSize
        self.headerAvatarBadgeSize = headerAvatarBadgeSize
        self.heroAvatarImageSize = heroAvatarImageSize
        self.heroAvatarBadgeSize = heroAvatarBadgeSize
        self.avatarBackgroundStyle = avatarBackgroundStyle
        self.avatarStrokeStyle = avatarStrokeStyle
        self.content = content()
    }

    public var body: some View {
        AVAviGuidanceScreenScaffold(
            identity: appExperience.identity,
            summary: summary,
            status: status,
            headerAccessibilityIdentifier: headerAccessibilityIdentifier,
            landingContent: landingContent,
            backgroundStyle: backgroundStyle,
            horizontalPadding: horizontalPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            spacing: spacing
        ) {
            AVConfiguredAviAvatarBadge(
                imageSize: headerAvatarImageSize,
                badgeSize: headerAvatarBadgeSize,
                backgroundStyle: avatarBackgroundStyle,
                strokeStyle: avatarStrokeStyle
            )
        } heroAvatar: {
            AVConfiguredAviAvatarBadge(
                imageSize: heroAvatarImageSize,
                badgeSize: heroAvatarBadgeSize,
                backgroundStyle: avatarBackgroundStyle,
                strokeStyle: avatarStrokeStyle
            )
        } content: {
            content
        }
    }
}
