import AVBrandFoundation
import SwiftUI

public struct AVSettingsButton: View {
    public enum Style {
        case primary
        case secondary
        case destructive
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

                if style != .primary {
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
            .padding(.horizontal, style == .primary ? 0 : 18)
            .background(backgroundShape)
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                    .stroke(borderTint, lineWidth: style == .primary ? 0 : 1)
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
            AVBrandColor.accent
        case .secondary, .destructive:
            AVBrandColor.cardSurface
        }
    }

    private var titleTint: Color {
        switch style {
        case .primary:
            AVBrandColor.brandBlack
        case .secondary:
            AVBrandColor.textPrimary
        case .destructive:
            Color(red: 0.84, green: 0.16, blue: 0.22)
        }
    }

    private var borderTint: Color {
        switch style {
        case .primary:
            .clear
        case .secondary:
            AVBrandColor.borderSubtle
        case .destructive:
            Color(red: 0.84, green: 0.16, blue: 0.22).opacity(0.18)
        }
    }

    private var progressTint: Color {
        switch style {
        case .primary:
            AVBrandColor.brandBlack
        case .secondary, .destructive:
            AVBrandColor.textPrimary
        }
    }
}

public struct AVSettingsOptionButton: View {
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
                    .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textSecondary)

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
                    .fill(isSelected ? AVBrandColor.accent.opacity(0.1) : AVBrandColor.mutedSurface)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                    .stroke(
                        isSelected ? AVBrandColor.accent.opacity(0.35) : AVBrandColor.borderSubtle,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
