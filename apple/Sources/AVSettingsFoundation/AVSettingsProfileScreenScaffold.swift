import AVAppShellFoundation
import AVBrandFoundation
import SwiftUI

public struct AVSettingsProfileScreenScaffold<Chrome: View, Content: View>: View {
    private let title: String
    private let subtitle: String
    private let bottomContentPadding: CGFloat
    private let backgroundStyle: AnyShapeStyle
    private let showsTopSafeAreaShield: Bool
    private let chrome: Chrome
    private let content: Content

    public init(
        title: String,
        subtitle: String,
        bottomContentPadding: CGFloat = AVAppShellScreenMetric.bottomContentPadding,
        backgroundStyle: AnyShapeStyle = AnyShapeStyle(AVBrandColor.canvas),
        showsTopSafeAreaShield: Bool = false,
        @ViewBuilder chrome: () -> Chrome,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.bottomContentPadding = bottomContentPadding
        self.backgroundStyle = backgroundStyle
        self.showsTopSafeAreaShield = showsTopSafeAreaShield
        self.chrome = chrome()
        self.content = content()
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                chrome

                AVSettingsScreenHeader(title: title, subtitle: subtitle)

                content
            }
            .avShellScreenContentPadding(bottom: bottomContentPadding)
        }
        .avShellScreenScrollBehavior()
        .background {
            Rectangle()
                .fill(backgroundStyle)
                .ignoresSafeArea()
        }
        .overlay(alignment: .top) {
            if showsTopSafeAreaShield {
                topSafeAreaShield
            }
        }
    }

    private var topSafeAreaShield: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(backgroundStyle)
                .frame(height: proxy.safeAreaInsets.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)
                .allowsHitTesting(false)
        }
    }
}
