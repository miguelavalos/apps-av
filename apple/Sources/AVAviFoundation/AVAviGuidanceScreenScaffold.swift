import AVBrandFoundation
import SwiftUI

public struct AVAviGuidanceScreenScaffold<HeaderAvatar: View, HeroAvatar: View, Content: View>: View {
    private let identity: AVAppIdentity
    private let summary: String
    private let status: String?
    private let headerAccessibilityIdentifier: String
    private let landingContent: AVAviLandingContent
    private let backgroundStyle: AnyShapeStyle
    private let horizontalPadding: CGFloat
    private let topPadding: CGFloat
    private let bottomPadding: CGFloat
    private let spacing: CGFloat
    private let headerAvatar: HeaderAvatar
    private let heroAvatar: HeroAvatar
    private let content: Content

    public init(
        identity: AVAppIdentity,
        summary: String,
        status: String? = nil,
        headerAccessibilityIdentifier: String,
        landingContent: AVAviLandingContent,
        backgroundStyle: AnyShapeStyle = AnyShapeStyle(AVBrandColor.canvas),
        horizontalPadding: CGFloat = 18,
        topPadding: CGFloat = 18,
        bottomPadding: CGFloat = 132,
        spacing: CGFloat = 18,
        @ViewBuilder headerAvatar: () -> HeaderAvatar,
        @ViewBuilder heroAvatar: () -> HeroAvatar,
        @ViewBuilder content: () -> Content
    ) {
        self.identity = identity
        self.summary = summary
        self.status = status
        self.headerAccessibilityIdentifier = headerAccessibilityIdentifier
        self.landingContent = landingContent
        self.backgroundStyle = backgroundStyle
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.spacing = spacing
        self.headerAvatar = headerAvatar()
        self.heroAvatar = heroAvatar()
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: spacing) {
                AVAviScreenHeader(
                    identity: identity,
                    summary: summary,
                    status: status,
                    accessibilityIdentifier: headerAccessibilityIdentifier
                ) {
                    headerAvatar
                }

                AVAviLandingHeroCard(content: landingContent) {
                    heroAvatar
                }

                content
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background {
            Rectangle()
                .fill(backgroundStyle)
                .ignoresSafeArea()
        }
    }
}
