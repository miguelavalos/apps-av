import AVBrandFoundation
import SwiftUI

public struct AVAppShellCardBackground: View {
    private let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = AVBrandRadius.card) {
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(AVBrandColor.elevatedSurface)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.64), lineWidth: 1)
            }
    }
}

public struct AVAppShellCard<Content: View>: View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AVAppShellCardBackground())
    }
}

public struct AVAppShellContentHeader: View {
    private let title: String
    private let detail: String

    public init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.78)

            Text(detail)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AVBrandColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

public struct AVAppShellActionRow: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let detail: String
    private let systemImage: String
    private let eyebrow: String?
    private let isProminent: Bool
    private let isDisabled: Bool
    private let showsChevron: Bool
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        title: String,
        detail: String,
        systemImage: String,
        eyebrow: String? = nil,
        isProminent: Bool = false,
        isDisabled: Bool = false,
        showsChevron: Bool = true,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.eyebrow = eyebrow
        self.isProminent = isProminent
        self.isDisabled = isDisabled
        self.showsChevron = showsChevron
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: AVBrandSpacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(isProminent ? brandPalette.ink : brandPalette.accent)
                    .frame(width: 28, height: 28)
                    .background(iconBackground, in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous))

                VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                    if let eyebrow {
                        Text(eyebrow)
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(AVBrandColor.textSecondary)
                            .textCase(.uppercase)
                            .lineLimit(1)
                    }

                    Text(title)
                        .font(AVBrandTypography.captionStrong)
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.84)

                    Text(detail)
                        .font(AVBrandTypography.caption)
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(AVBrandColor.textSecondary.opacity(0.72))
                        .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AVBrandSpacing.md)
            .background(rowBackground, in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous)
                    .stroke(rowBorder, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.55 : 1)
        .avAppShellAccessibilityIdentifierIfPresent(accessibilityIdentifier)
    }

    private var iconBackground: Color {
        isProminent ? brandPalette.accent : brandPalette.accent.opacity(0.12)
    }

    private var rowBackground: Color {
        isProminent ? brandPalette.accent.opacity(0.08) : AVBrandColor.cardSurface.opacity(0.72)
    }

    private var rowBorder: Color {
        isProminent ? brandPalette.accent.opacity(0.20) : AVBrandColor.borderSubtle.opacity(0.5)
    }
}

private extension View {
    @ViewBuilder
    func avAppShellAccessibilityIdentifierIfPresent(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
