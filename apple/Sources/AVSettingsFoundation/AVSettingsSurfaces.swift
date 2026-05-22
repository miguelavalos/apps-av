import AVBrandFoundation
import SwiftUI

public struct AVSettingsCardBackground: View {
    private let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = AVBrandRadius.sheet) {
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(AVBrandColor.cardSurface)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
            }
    }
}

public struct AVSettingsCard<Content: View>: View {
    private let spacing: CGFloat
    private let padding: CGFloat
    private let content: Content

    public init(
        spacing: CGFloat = 18,
        padding: CGFloat = 22,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        .padding(padding)
        .background(AVSettingsCardBackground())
    }
}

public struct AVSettingsSectionHeader: View {
    private let title: String
    private let subtitle: String

    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AVBrandColor.textPrimary)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

public struct AVSettingsScreenHeader: View {
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
        VStack(alignment: .leading, spacing: 10) {
            titleView

            Text(subtitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var titleView: some View {
        let text = Text(title)
            .font(.system(size: 34, weight: .bold))
            .foregroundStyle(AVBrandColor.textPrimary)

        if let titleAccessibilityIdentifier {
            text.accessibilityIdentifier(titleAccessibilityIdentifier)
        } else {
            text
        }
    }
}

public struct AVSettingsSheetHeader: View {
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
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(AVBrandColor.textPrimary)

        if let titleAccessibilityIdentifier {
            text.accessibilityIdentifier(titleAccessibilityIdentifier)
        } else {
            text
        }
    }
}

public struct AVSettingsSheetScaffold<Content: View>: View {
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat
    private let topPadding: CGFloat
    private let bottomPadding: CGFloat
    private let backgroundStyle: AnyShapeStyle
    private let closeTitle: String?
    private let closeAccessibilityIdentifier: String?
    private let onClose: (() -> Void)?
    private let content: Content

    public init(
        spacing: CGFloat = 22,
        horizontalPadding: CGFloat = 20,
        topPadding: CGFloat = 22,
        bottomPadding: CGFloat = 28,
        backgroundStyle: AnyShapeStyle = AnyShapeStyle(AVBrandColor.footerBackdrop),
        closeTitle: String? = nil,
        closeAccessibilityIdentifier: String? = nil,
        onClose: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.backgroundStyle = backgroundStyle
        self.closeTitle = closeTitle
        self.closeAccessibilityIdentifier = closeAccessibilityIdentifier
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
            .background {
                Rectangle()
                    .fill(backgroundStyle)
                    .ignoresSafeArea()
            }
            .toolbar {
                if let closeTitle, let onClose {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(closeTitle, action: onClose)
                            .applyAccessibilityIdentifier(closeAccessibilityIdentifier)
                    }
                }
            }
        }
    }
}

public struct AVSettingsNoticeCard: View {
    private let systemImage: String
    private let title: String
    private let detail: String

    public init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(AVBrandColor.textPrimary)

            Text(detail)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(AVSettingsCardBackground())
    }
}

public struct AVSettingsStatusCard: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let systemImage: String
    private let title: String
    private let detail: String

    public init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(brandPalette.accent)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(detail)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .background(AVSettingsCardBackground())
    }
}

public struct AVSettingsDetailCard: View {
    private let title: String
    private let detail: String?
    private let linkTitle: String?
    private let linkDestination: URL?

    public init(
        title: String,
        detail: String? = nil,
        linkTitle: String? = nil,
        linkDestination: URL? = nil
    ) {
        self.title = title
        self.detail = detail
        self.linkTitle = linkTitle
        self.linkDestination = linkDestination
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(AVBrandColor.textPrimary)

            if let detail, !detail.isEmpty {
                Text(detail)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let linkTitle, let linkDestination {
                Link(linkTitle, destination: linkDestination)
                    .font(.system(size: 13, weight: .bold))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            AVBrandColor.mutedSurface,
            in: RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
        )
    }
}

public struct AVSettingsDetailListItem: Identifiable {
    public let id: String
    public let title: String
    public let detail: String?
    public let linkTitle: String?
    public let linkDestination: URL?
    public let accessibilityIdentifier: String?

    public init(
        id: String,
        title: String,
        detail: String? = nil,
        linkTitle: String? = nil,
        linkDestination: URL? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.linkTitle = linkTitle
        self.linkDestination = linkDestination
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public struct AVSettingsDetailList: View {
    private let items: [AVSettingsDetailListItem]
    private let spacing: CGFloat

    public init(
        items: [AVSettingsDetailListItem],
        spacing: CGFloat = 10
    ) {
        self.items = items
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(items) { item in
                AVSettingsDetailCard(
                    title: item.title,
                    detail: item.detail,
                    linkTitle: item.linkTitle,
                    linkDestination: item.linkDestination
                )
                .applyAccessibilityIdentifier(item.accessibilityIdentifier)
            }
        }
    }
}

public struct AVSettingsTextField: View {
    private let placeholder: String
    @Binding private var text: String
    private let accessibilityIdentifier: String?

    public init(
        _ placeholder: String,
        text: Binding<String>,
        accessibilityIdentifier: String? = nil
    ) {
        self.placeholder = placeholder
        _text = text
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    public var body: some View {
        TextField(placeholder, text: $text)
            .padding(14)
            .background(
                AVBrandColor.mutedSurface,
                in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
            }
            .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVSettingsLoadingState: View {
    private let title: String
    private let verticalPadding: CGFloat
    private let accessibilityIdentifier: String?

    public init(
        _ title: String,
        verticalPadding: CGFloat = 40,
        accessibilityIdentifier: String? = nil
    ) {
        self.title = title
        self.verticalPadding = verticalPadding
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    public var body: some View {
        ProgressView(title)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, verticalPadding)
            .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVSettingsDestructiveActionCard: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let sectionTitle: String
    private let systemImage: String
    private let title: String
    private let detail: String
    private let action: () -> Void

    public init(
        sectionTitle: String,
        systemImage: String,
        title: String,
        detail: String,
        action: @escaping () -> Void
    ) {
        self.sectionTitle = sectionTitle
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(sectionTitle)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AVBrandColor.textSecondary)
                .textCase(.uppercase)

            Button(action: action) {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 22)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 15, weight: .bold))

                        Text(detail)
                            .font(.system(size: 13, weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 12)
                }
                .foregroundStyle(brandPalette.destructive)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(brandPalette.destructive.opacity(0.07))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(brandPalette.destructive.opacity(0.18), lineWidth: 1)
                        }
                )
            }
            .buttonStyle(.plain)
        }
    }
}

public struct AVSettingsInfoRow: View {
    private let systemImage: String
    private let title: String
    private let detail: String

    public init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        AVSettingsRowLayout(systemImage: systemImage, title: title, detail: detail)
    }
}

public struct AVSettingsActionRow: View {
    private let systemImage: String
    private let title: String
    private let detail: String
    private let action: () -> Void

    public init(
        systemImage: String,
        title: String,
        detail: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            AVSettingsRowLayout(systemImage: systemImage, title: title, detail: detail) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AVBrandColor.textSecondary.opacity(0.7))
                    .padding(.top, 4)
            }
            .padding(16)
            .background(AVSettingsRowBackground())
        }
        .buttonStyle(.plain)
    }
}

public struct AVSettingsToggleRow: View {
    private let systemImage: String
    private let title: String
    private let detail: String
    @Binding private var isOn: Bool

    public init(
        systemImage: String,
        title: String,
        detail: String,
        isOn: Binding<Bool>
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        _isOn = isOn
    }

    public var body: some View {
        AVSettingsRowLayout(systemImage: systemImage, title: title, detail: detail) {
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(16)
        .background(AVSettingsRowBackground())
    }
}

public struct AVSettingsInlineActionRow: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let systemImage: String
    private let title: String
    private let detail: String
    private let actionTitle: String
    private let action: () -> Void

    public init(
        systemImage: String,
        title: String,
        detail: String,
        actionTitle: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        AVSettingsRowLayout(systemImage: systemImage, title: title, detail: detail) {
            Button(actionTitle, action: action)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(brandPalette.accent)
                .buttonStyle(.plain)
        }
        .padding(16)
        .background(AVSettingsRowBackground())
    }
}

public struct AVSettingsGroupedActionList<Rows: View>: View {
    private let title: String
    private let rows: Rows

    public init(title: String, @ViewBuilder rows: () -> Rows) {
        self.title = title
        self.rows = rows()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AVBrandColor.textSecondary)
                .textCase(.uppercase)

            VStack(spacing: 0) {
                rows
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(AVBrandColor.mutedSurface)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                    }
            )
        }
    }
}

public struct AVSettingsGroupedActionRow: View {
    private let systemImage: String
    private let title: String
    private let detail: String
    private let showsDivider: Bool
    private let action: () -> Void

    public init(
        systemImage: String,
        title: String,
        detail: String,
        showsDivider: Bool = false,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.showsDivider = showsDivider
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                AVSettingsRowLayout(systemImage: systemImage, title: title, detail: detail) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AVBrandColor.textSecondary.opacity(0.7))
                        .padding(.top, 4)
                }
                .padding(16)
            }
            .buttonStyle(.plain)

            if showsDivider {
                Divider()
                    .overlay(AVBrandColor.borderSubtle)
                    .padding(.leading, 50)
            }
        }
    }
}

private struct AVSettingsRowLayout<Trailing: View>: View {
    @Environment(\.avBrandPalette) private var brandPalette

    let systemImage: String
    let title: String
    let detail: String
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(brandPalette.accent)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(detail)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            trailing()
        }
    }
}

private extension AVSettingsRowLayout where Trailing == EmptyView {
    init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.trailing = { EmptyView() }
    }
}

private struct AVSettingsRowBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: AVBrandRadius.row, style: .continuous)
            .fill(AVBrandColor.mutedSurface)
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.row, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
            }
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
