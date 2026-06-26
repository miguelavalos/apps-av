import SwiftUI

public struct AVAppShellScrollableScreenScaffold<Background: View, Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat
    private let topPadding: CGFloat
    private let bottomPadding: CGFloat
    private let maxContentWidth: CGFloat?
    private let background: Background
    private let content: Content

    public init(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat = 18,
        horizontalPadding: CGFloat = AVAppShellScreenMetric.horizontalPadding,
        topPadding: CGFloat = AVAppShellScreenMetric.topPadding,
        bottomPadding: CGFloat = AVAppShellScreenMetric.bottomContentPadding,
        maxContentWidth: CGFloat? = nil,
        @ViewBuilder background: () -> Background,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.maxContentWidth = maxContentWidth
        self.background = background()
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: alignment, spacing: spacing) {
                content
            }
            .avShellScreenContentPadding(
                horizontal: horizontalPadding,
                top: topPadding,
                bottom: bottomPadding
            )
            .frame(maxWidth: maxContentWidth ?? .infinity, alignment: Alignment(horizontal: alignment, vertical: .top))
            .frame(maxWidth: .infinity, alignment: Alignment(horizontal: alignment, vertical: .top))
        }
        .avShellScreenScrollBehavior()
        .background(background.ignoresSafeArea())
        .overlay(alignment: .top) {
            GeometryReader { proxy in
                background
                    .frame(height: proxy.safeAreaInsets.top + 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea(edges: .top)
                    .allowsHitTesting(false)
            }
            .allowsHitTesting(false)
        }
    }
}
