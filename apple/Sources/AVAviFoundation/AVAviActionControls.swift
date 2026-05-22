import AVBrandFoundation
import SwiftUI

public struct AVAviActionChip: View {
    private let title: String
    private let systemImage: String
    private let action: () -> Void

    public init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .black))

                Text(title)
                    .font(.system(size: 13, weight: .black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .foregroundStyle(AVBrandColor.textPrimary)
            .padding(.horizontal, AVBrandSpacing.lg)
            .frame(height: 38)
            .background(AVBrandColor.cardSurface, in: Capsule(style: .continuous))
            .overlay {
                Capsule(style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.72), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

public struct AVAviSignalStep: View {
    private let index: Int
    private let title: String

    public init(index: Int, title: String) {
        self.index = index
        self.title = title
    }

    public var body: some View {
        HStack(spacing: AVBrandSpacing.sm) {
            Text("\(index)")
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(AVBrandColor.accent)
                .frame(width: 24, height: 24)
                .background(AVBrandColor.accent.opacity(0.12), in: Circle())

            Text(title)
                .font(AVBrandTypography.captionStrong)
                .foregroundStyle(AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, AVBrandSpacing.md)
        .padding(.vertical, AVBrandSpacing.sm)
        .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.5), lineWidth: 1)
        }
    }
}

public struct AVAviSignalChip: View {
    private let title: String
    private let systemImage: String

    public init(title: String, systemImage: String) {
        self.title = title
        self.systemImage = systemImage
    }

    public var body: some View {
        Label(title, systemImage: systemImage)
            .font(.system(size: 11, weight: .black))
            .lineLimit(1)
            .minimumScaleFactor(0.78)
            .foregroundStyle(AVBrandColor.accent)
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, AVBrandSpacing.sm)
            .frame(height: 30)
            .background(AVBrandColor.accent.opacity(0.1), in: Capsule(style: .continuous))
            .overlay {
                Capsule(style: .continuous)
                    .stroke(AVBrandColor.accent.opacity(0.22), lineWidth: 1)
            }
    }
}

public struct AVAviInfoRow: View {
    private let title: String
    private let detail: String
    private let systemImage: String
    private let accessibilityIdentifier: String

    public init(title: String, detail: String, systemImage: String, accessibilityIdentifier: String) {
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AVBrandColor.accent)
                .frame(width: 28, height: 28)
                .background(AVBrandColor.accent.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(detail)
                    .font(AVBrandTypography.caption)
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviRecommendationItemRow<Trailing: View>: View {
    private let title: String
    private let detail: String
    private let playAccessibilityLabel: String
    private let detailsAccessibilityLabel: String
    private let accessibilityIdentifier: String
    private let playAction: () -> Void
    private let detailsAction: () -> Void
    private let trailing: Trailing

    public init(
        title: String,
        detail: String,
        playAccessibilityLabel: String,
        detailsAccessibilityLabel: String,
        accessibilityIdentifier: String,
        playAction: @escaping () -> Void,
        detailsAction: @escaping () -> Void,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.detail = detail
        self.playAccessibilityLabel = playAccessibilityLabel
        self.detailsAccessibilityLabel = detailsAccessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.playAction = playAction
        self.detailsAction = detailsAction
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: AVBrandSpacing.sm) {
            Button(action: playAction) {
                Image(systemName: "play.fill")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(AVBrandColor.textInverse)
                    .frame(width: 32, height: 32)
                    .background(AVBrandColor.accent, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(playAccessibilityLabel)

            VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 5) {
                    Text(detail)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .lineLimit(1)

                    trailing
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: detailsAction) {
                Image(systemName: "info.circle")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(detailsAccessibilityLabel)
        }
        .padding(AVBrandSpacing.sm)
        .background(AVBrandColor.accent.opacity(0.07), in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVAviRecommendationItemRow where Trailing == EmptyView {
    init(
        title: String,
        detail: String,
        playAccessibilityLabel: String,
        detailsAccessibilityLabel: String,
        accessibilityIdentifier: String,
        playAction: @escaping () -> Void,
        detailsAction: @escaping () -> Void
    ) {
        self.init(
            title: title,
            detail: detail,
            playAccessibilityLabel: playAccessibilityLabel,
            detailsAccessibilityLabel: detailsAccessibilityLabel,
            accessibilityIdentifier: accessibilityIdentifier,
            playAction: playAction,
            detailsAction: detailsAction
        ) {
            EmptyView()
        }
    }
}

public struct AVAviActionButton: View {
    private let title: String
    private let systemImage: String
    private let action: () -> Void

    public init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .foregroundStyle(AVBrandColor.textPrimary)
                .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle.opacity(0.7), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
    }
}

public struct AVAviPrimaryActionButton: View {
    private let title: String
    private let systemImage: String
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .black))

                Text(title)
                    .font(.system(size: 13, weight: .black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .foregroundStyle(AVBrandColor.textInverse)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(AVBrandColor.accent, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}

public struct AVAviQuickActionButton: View {
    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool = false,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 14, weight: .black))
                .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                        .stroke(isSelected ? AVBrandColor.accent.opacity(0.34) : AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}

public struct AVAviIconActionButton: View {
    private let systemImage: String
    private let isSelected: Bool
    private let accessibilityLabel: String
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        systemImage: String,
        isSelected: Bool = false,
        accessibilityLabel: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textPrimary)
                .frame(width: 44, height: 44)
                .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                        .stroke(isSelected ? AVBrandColor.accent.opacity(0.34) : AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}

public struct AVAviPromptButton: View {
    private let title: String
    private let systemImage: String
    private let action: () -> Void

    public init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .black))

                Text(title)
                    .font(.system(size: 13, weight: .black))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)

                Spacer(minLength: 0)
            }
            .foregroundStyle(AVBrandColor.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AVBrandSpacing.md)
            .padding(.vertical, 11)
            .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.55), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }
}

public enum AVAviPanelOptionButtonStyle {
    case regular
    case compact

    var spacing: CGFloat {
        switch self {
        case .regular: 12
        case .compact: 7
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .regular: 30
        case .compact: 25
        }
    }

    var iconFontSize: CGFloat {
        switch self {
        case .regular: 13
        case .compact: 12
        }
    }

    var titleFontSize: CGFloat {
        switch self {
        case .regular: 13
        case .compact: 12
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .regular: 10
        case .compact: 9
        }
    }

    var height: CGFloat {
        switch self {
        case .regular: 44
        case .compact: 42
        }
    }

    var strokeOpacity: Double {
        switch self {
        case .regular: 0.46
        case .compact: 0.6
        }
    }
}

public struct AVAviPanelOptionButton: View {
    private let title: String
    private let systemImage: String
    private let role: ButtonRole?
    private let style: AVAviPanelOptionButtonStyle
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        role: ButtonRole? = nil,
        style: AVAviPanelOptionButtonStyle = .regular,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.style = style
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(role: role, action: action) {
            HStack(spacing: style.spacing) {
                Image(systemName: systemImage)
                    .font(.system(size: style.iconFontSize, weight: .bold))
                    .foregroundStyle(iconColor)
                    .frame(width: style.iconSize, height: style.iconSize)
                    .background(iconColor.opacity(0.1), in: Circle())

                Text(title)
                    .font(.system(size: style.titleFontSize, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: style.height)
            .padding(.horizontal, style.horizontalPadding)
            .background(AVBrandColor.cardSurface.opacity(0.92), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(style.strokeOpacity), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }

    private var iconColor: Color {
        role == .destructive ? .red : AVBrandColor.accent
    }
}

public struct AVAviPreviewPrimaryButton: View {
    private let title: String
    private let systemImage: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .black))
                    .frame(width: 30, height: 30)
                    .background(AVBrandColor.textInverse.opacity(0.16), in: Circle())

                Text(title)
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .black))
            }
            .foregroundStyle(AVBrandColor.textInverse)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 52)
            .padding(.horizontal, AVBrandSpacing.lg)
            .background(AVBrandColor.accent, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
            .shadow(color: AVBrandColor.accent.opacity(0.24), radius: 12, y: 7)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviPreviewCapabilityRow: View {
    private let systemImage: String
    private let title: String
    private let detail: String

    public init(systemImage: String, title: String, detail: String) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.md) {
            Image(systemName: systemImage)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(AVBrandColor.accent)
                .frame(width: 30, height: 30)
                .background(AVBrandColor.accent.opacity(0.1), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)

                Text(detail)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}

public struct AVAviPreviewSecondaryButton: View {
    private let title: String
    private let systemImage: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .black))
                    .foregroundStyle(AVBrandColor.accent)
                    .frame(width: 30, height: 30)
                    .background(AVBrandColor.accent.opacity(0.1), in: Circle())

                Text(title)
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.82)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 76)
            .padding(.horizontal, AVBrandSpacing.sm)
            .background(AVBrandColor.cardSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.5), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
