import AVBrandFoundation
import SwiftUI

public struct AVAppShellScreenHeader: View {
    private let title: String
    private let subtitle: String
    private let titleAccessibilityIdentifier: String?

    public init(
        title: String,
        subtitle: String,
        titleAccessibilityIdentifier: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.titleAccessibilityIdentifier = titleAccessibilityIdentifier
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleView

            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var titleView: some View {
        let text = Text(title)
            .font(.system(size: 30, weight: .black))
            .foregroundStyle(AVBrandColor.textPrimary)
            .lineLimit(2)
            .minimumScaleFactor(0.72)

        if let titleAccessibilityIdentifier {
            text.accessibilityIdentifier(titleAccessibilityIdentifier)
        } else {
            text
        }
    }
}
