import AVBrandFoundation
import SwiftUI

public struct AVSettingsButton: View {
    @Environment(\.avBrandPalette) private var brandPalette
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .headline) private var titleFontSize: CGFloat = 15

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
                    .font(.system(size: titleFontSize, weight: .bold))
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                    .minimumScaleFactor(dynamicTypeSize.isAccessibilitySize ? 1 : 0.78)
                    .allowsTightening(!dynamicTypeSize.isAccessibilitySize)
                    .fixedSize(horizontal: false, vertical: true)

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
            .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 12 : 0)
            .frame(minHeight: dynamicTypeSize.isAccessibilitySize ? 56 : 48)
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
            brandPalette.destructive
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
            brandPalette.destructive
        }
    }

    private var borderTint: Color {
        switch style {
        case .primary, .destructivePrimary:
            .clear
        case .secondary:
            AVBrandColor.borderSubtle
        case .destructive:
            brandPalette.destructive.opacity(0.18)
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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .footnote) private var titleFontSize: CGFloat = 13

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
            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    HStack(spacing: AVBrandSpacing.sm) {
                        optionIcon
                        optionTitle
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, AVBrandSpacing.md)
                    .padding(.vertical, AVBrandSpacing.sm)
                    .frame(minHeight: 56)
                } else {
                    VStack(spacing: AVBrandSpacing.xs) {
                        optionIcon
                        optionTitle
                    }
                    .padding(.vertical, AVBrandSpacing.md)
                }
            }
            .frame(maxWidth: .infinity)
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

    private var optionIcon: some View {
        Image(systemName: systemImage)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(isSelected ? brandPalette.accent : AVBrandColor.textSecondary)
            .frame(width: 24, height: 24)
    }

    private var optionTitle: some View {
        Text(title)
            .font(.system(size: titleFontSize, weight: .semibold, design: .rounded))
            .foregroundStyle(AVBrandColor.textPrimary)
            .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
            .minimumScaleFactor(dynamicTypeSize.isAccessibilitySize ? 1 : 0.8)
            .fixedSize(horizontal: false, vertical: true)
    }
}
