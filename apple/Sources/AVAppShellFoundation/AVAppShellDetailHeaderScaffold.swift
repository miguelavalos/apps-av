import AVBrandFoundation
import SwiftUI

public struct AVAppShellDetailHeaderScaffold<Leading: View, Accessory: View>: View {
    private let title: String
    private let entityName: String?
    private let subtitle: String
    private let status: String?
    private let accessibilityIdentifier: String?
    private let spacing: CGFloat
    private let contentSpacing: CGFloat
    private let leading: Leading
    private let accessory: Accessory

    public init(
        title: String,
        entityName: String? = nil,
        subtitle: String,
        status: String? = nil,
        accessibilityIdentifier: String? = nil,
        spacing: CGFloat = 13,
        contentSpacing: CGFloat = 5,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.entityName = entityName
        self.subtitle = subtitle
        self.status = status
        self.accessibilityIdentifier = accessibilityIdentifier
        self.spacing = spacing
        self.contentSpacing = contentSpacing
        self.leading = leading()
        self.accessory = accessory()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            leading

            VStack(alignment: .leading, spacing: contentSpacing) {
                HStack(spacing: AVBrandSpacing.xs) {
                    if let status {
                        Text(status)
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(AVBrandColor.accent)
                            .textCase(.uppercase)
                            .lineLimit(1)
                    }

                    accessory
                }

                Text(title)
                    .font(.system(size: entityName == nil ? 25 : 15, weight: .black, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(entityName == nil ? 2 : 1)
                    .minimumScaleFactor(0.78)
                    .fixedSize(horizontal: false, vertical: true)

                if let entityName {
                    Text(entityName)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(3)
                        .minimumScaleFactor(0.72)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Text(subtitle)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 1)
        }
        .accessibilityElement(children: .contain)
        .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVAppShellDetailHeaderScaffold where Accessory == EmptyView {
    init(
        title: String,
        entityName: String? = nil,
        subtitle: String,
        status: String? = nil,
        accessibilityIdentifier: String? = nil,
        spacing: CGFloat = 13,
        contentSpacing: CGFloat = 5,
        @ViewBuilder leading: () -> Leading
    ) {
        self.init(
            title: title,
            entityName: entityName,
            subtitle: subtitle,
            status: status,
            accessibilityIdentifier: accessibilityIdentifier,
            spacing: spacing,
            contentSpacing: contentSpacing,
            leading: leading,
            accessory: { EmptyView() }
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
