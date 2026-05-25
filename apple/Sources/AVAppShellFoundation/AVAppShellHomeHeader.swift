import SwiftUI

public struct AVAppShellHomeHeader<BrandHeader: View, Content: View>: View {
    private let title: String
    private let subtitle: String
    private let spacing: CGFloat
    private let titleAccessibilityIdentifier: String?
    private let brandHeader: BrandHeader
    private let content: Content

    public init(
        title: String,
        subtitle: String,
        spacing: CGFloat = 18,
        titleAccessibilityIdentifier: String? = nil,
        @ViewBuilder brandHeader: () -> BrandHeader,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.spacing = spacing
        self.titleAccessibilityIdentifier = titleAccessibilityIdentifier
        self.brandHeader = brandHeader()
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            brandHeader

            AVAppShellScreenHeader(
                title: title,
                subtitle: subtitle,
                titleAccessibilityIdentifier: titleAccessibilityIdentifier
            )

            content
        }
    }
}

public extension AVAppShellHomeHeader where Content == EmptyView {
    init(
        title: String,
        subtitle: String,
        spacing: CGFloat = 18,
        titleAccessibilityIdentifier: String? = nil,
        @ViewBuilder brandHeader: () -> BrandHeader
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            spacing: spacing,
            titleAccessibilityIdentifier: titleAccessibilityIdentifier,
            brandHeader: brandHeader,
            content: { EmptyView() }
        )
    }
}
