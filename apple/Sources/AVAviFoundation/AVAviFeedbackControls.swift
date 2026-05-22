import AVBrandFoundation
import SwiftUI

public struct AVAviFeedbackOptionButton: View {
    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool = false,
        accessibilityIdentifier: String,
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
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(isSelected ? AVBrandColor.ink : AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(
                    isSelected ? AVBrandColor.accent : AVBrandColor.elevatedSurface,
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                        .stroke(
                            isSelected ? AVBrandColor.accent.opacity(0.62) : AVBrandColor.borderSubtle,
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviSelectedFeedbackStatus: View {
    private let title: String
    private let systemImage: String
    private let accessibilityLabel: String

    public init(
        title: String,
        systemImage: String,
        accessibilityLabel: String? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel ?? title
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(AVBrandColor.ink)
                .frame(width: 30, height: 30)
                .background(AVBrandColor.accent, in: Circle())

            Text(title)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .allowsTightening(true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(
            AVBrandColor.accent.opacity(0.1),
            in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .stroke(AVBrandColor.accent.opacity(0.22), lineWidth: 1)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

public struct AVAviFeedbackClearButton: View {
    private let accessibilityLabel: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        accessibilityLabel: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(AVBrandColor.textSecondary)
                .frame(width: 38, height: 38)
                .background(AVBrandSurface.shellBackground, in: Circle())
                .overlay {
                    Circle()
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviCompactFeedbackButton: View {
    private let systemImage: String
    private let accessibilityLabel: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        systemImage: String,
        accessibilityLabel: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(AVBrandColor.textSecondary)
                .frame(width: 34, height: 30)
                .background(
                    AVBrandColor.elevatedSurface,
                    in: RoundedRectangle(cornerRadius: 11, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviFeedbackCompactActionButton: View {
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
            Label(title, systemImage: systemImage)
                .font(.system(size: 12, weight: .black))
                .labelStyle(.titleAndIcon)
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .foregroundStyle(AVBrandColor.textPrimary)
                .frame(width: 96, height: 38)
                .background(
                    AVBrandSurface.shellBackground,
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviFeedbackDecisionButton: View {
    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool = false,
        accessibilityIdentifier: String,
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
                .font(.system(size: 12, weight: .black))
                .labelStyle(.titleAndIcon)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .foregroundStyle(isSelected ? AVBrandColor.ink : AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background {
                    backgroundShape
                }
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                        .stroke(isSelected ? AVBrandColor.accent.opacity(0.44) : AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }

    @ViewBuilder
    private var backgroundShape: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .fill(AVBrandColor.accent)
        } else {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .fill(AVBrandSurface.shellBackground)
        }
    }
}

public struct AVAviFeedbackInfoRow: View {
    private let title: String
    private let subtitle: String
    private let systemImage: String
    private let isAction: Bool

    public init(
        title: String,
        subtitle: String,
        systemImage: String,
        isAction: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.isAction = isAction
    }

    public var body: some View {
        HStack(spacing: 9) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(isAction ? AVBrandColor.ink : AVBrandColor.accent)
                .frame(width: 28, height: 28)
                .background(iconBackgroundColor, in: Circle())

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .allowsTightening(true)

                Text(subtitle)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .allowsTightening(true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 11)
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(
            AVBrandColor.accent.opacity(0.08),
            in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .stroke(AVBrandColor.accent.opacity(0.16), lineWidth: 1)
        }
    }

    private var iconBackgroundColor: Color {
        isAction ? AVBrandColor.ink.opacity(0.12) : AVBrandColor.accent.opacity(0.12)
    }
}
