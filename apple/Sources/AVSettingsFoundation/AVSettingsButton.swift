import AVBrandFoundation
import SwiftUI

public struct AVSettingsButton: View {
    @Environment(\.avBrandPalette) private var brandPalette

    public enum Style {
        case primary
        case secondary
        case destructive
        case destructivePrimary
    }

    private let title: String
    private let style: Style
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        title: String,
        style: Style,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .allowsTightening(true)

                if style != .primary && style != .destructivePrimary {
                    Spacer()
                }

                if isLoading {
                    ProgressView()
                        .tint(progressTint)
                }
            }
            .foregroundStyle(titleTint)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .padding(.horizontal, style == .primary || style == .destructivePrimary ? 0 : 18)
            .background(backgroundShape)
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                    .stroke(borderTint, lineWidth: style == .primary || style == .destructivePrimary ? 0 : 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var backgroundShape: some View {
        RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
            .fill(backgroundTint)
    }

    private var backgroundTint: Color {
        switch style {
        case .primary:
            brandPalette.accent
        case .destructivePrimary:
            AVBrandColor.destructive
        case .secondary, .destructive:
            AVBrandColor.cardSurface
        }
    }

    private var titleTint: Color {
        switch style {
        case .primary:
            brandPalette.ink
        case .destructivePrimary:
            .white
        case .secondary:
            AVBrandColor.textPrimary
        case .destructive:
            AVBrandColor.destructive
        }
    }

    private var borderTint: Color {
        switch style {
        case .primary, .destructivePrimary:
            .clear
        case .secondary:
            AVBrandColor.borderSubtle
        case .destructive:
            AVBrandColor.destructive.opacity(0.18)
        }
    }

    private var progressTint: Color {
        switch style {
        case .primary:
            brandPalette.ink
        case .destructivePrimary:
            .white
        case .secondary, .destructive:
            AVBrandColor.textPrimary
        }
    }
}

public struct AVSettingsLinkButton: View {
    private let title: String
    private let systemImage: String
    private let destination: URL

    public init(title: String, systemImage: String, destination: URL) {
        self.title = title
        self.systemImage = systemImage
        self.destination = destination
    }

    public var body: some View {
        Link(destination: destination) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 15, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.78)
                .allowsTightening(true)
                .foregroundStyle(AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    AVBrandColor.cardSurface,
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
    }
}

public struct AVSettingsOptionButton: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: systemImage)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(isSelected ? brandPalette.accent : AVBrandColor.textSecondary)

                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AVBrandSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                    .fill(isSelected ? brandPalette.accent.opacity(0.1) : AVBrandColor.mutedSurface)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                    .stroke(
                        isSelected ? brandPalette.accent.opacity(0.35) : AVBrandColor.borderSubtle,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
