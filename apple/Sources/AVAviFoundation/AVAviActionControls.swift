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
