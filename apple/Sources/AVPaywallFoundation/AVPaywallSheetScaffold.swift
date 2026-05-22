import AVBrandFoundation
import SwiftUI

public struct AVPaywallSheetScaffold<Content: View>: View {
    private let navigationTitle: String
    private let closeTitle: String
    private let accessibilityIdentifier: String
    private let horizontalPadding: CGFloat
    private let topPadding: CGFloat
    private let bottomPadding: CGFloat
    private let spacing: CGFloat
    private let backgroundStyle: AnyShapeStyle
    private let onClose: () -> Void
    private let content: Content

    public init(
        navigationTitle: String,
        closeTitle: String,
        accessibilityIdentifier: String = "paywall.sheet",
        horizontalPadding: CGFloat = 22,
        topPadding: CGFloat = 18,
        bottomPadding: CGFloat = 24,
        spacing: CGFloat = 16,
        backgroundStyle: AnyShapeStyle = AnyShapeStyle(AVBrandSurface.shellBackground),
        onClose: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.navigationTitle = navigationTitle
        self.closeTitle = closeTitle
        self.accessibilityIdentifier = accessibilityIdentifier
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.spacing = spacing
        self.backgroundStyle = backgroundStyle
        self.onClose = onClose
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    content
                }
                .padding(.horizontal, horizontalPadding)
                .padding(.top, topPadding)
                .padding(.bottom, bottomPadding)
            }
            .accessibilityIdentifier(accessibilityIdentifier)
            .background {
                Rectangle()
                    .fill(backgroundStyle)
                    .ignoresSafeArea()
            }
            .navigationTitle(navigationTitle)
            .avPaywallNavigationTitleDisplayMode()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(closeTitle, action: onClose)
                }
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func avPaywallNavigationTitleDisplayMode() -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
