import SwiftUI

public struct AVAppShellDashboardSection<Content: View>: View {
    private let title: String
    private let detail: String
    private let spacing: CGFloat
    private let content: Content

    public init(
        title: String,
        detail: String,
        spacing: CGFloat = 18,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.detail = detail
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        AVAppShellCard(spacing: spacing) {
            AVAppShellContentHeader(title: title, detail: detail)
            content
        }
    }
}

public extension AVAppShellDashboardSection where Content == EmptyView {
    init(
        title: String,
        detail: String,
        spacing: CGFloat = 18
    ) {
        self.init(
            title: title,
            detail: detail,
            spacing: spacing
        ) {
            EmptyView()
        }
    }
}
