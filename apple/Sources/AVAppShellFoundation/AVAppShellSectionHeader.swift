import AVBrandFoundation
import SwiftUI

public struct AVAppShellSectionHeader<Trailing: View>: View {
    private let title: String
    private let accessibilityIdentifier: String?
    private let spacing: CGFloat
    private let trailing: Trailing

    public init(
        title: String,
        accessibilityIdentifier: String? = nil,
        spacing: CGFloat = 10,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
        self.spacing = spacing
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: spacing) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            trailing
        }
        .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVAppShellSectionHeader where Trailing == EmptyView {
    init(
        title: String,
        accessibilityIdentifier: String? = nil,
        spacing: CGFloat = 10
    ) {
        self.init(
            title: title,
            accessibilityIdentifier: accessibilityIdentifier,
            spacing: spacing,
            trailing: { EmptyView() }
        )
    }
}

private extension View {
    @ViewBuilder
    func applyAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
