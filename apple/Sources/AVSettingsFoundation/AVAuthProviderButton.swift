import AVBrandFoundation
import SwiftUI

public struct AVAuthProviderButton<Icon: View>: View {
    public enum Style {
        case dark
        case light
    }

    @Environment(\.avBrandPalette) private var brandPalette
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let title: String
    private let isLoading: Bool
    private let style: Style
    private let action: () -> Void
    private let icon: Icon

    public init(
        title: String,
        isLoading: Bool = false,
        style: Style,
        action: @escaping () -> Void,
        @ViewBuilder icon: () -> Icon
    ) {
        self.title = title
        self.isLoading = isLoading
        self.style = style
        self.action = action
        self.icon = icon()
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .tint(progressTint)
                    } else {
                        icon
                            .foregroundStyle(iconTint)
                    }
                }
                .frame(width: 24, height: 24)

                Text(title)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(titleTint)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, dynamicTypeSize.isAccessibilitySize ? 10 : 8)
            .frame(minHeight: dynamicTypeSize.isAccessibilitySize ? 56 : 46)
            .frame(maxWidth: .infinity)
            .background(backgroundTint, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(borderTint, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }

    private var backgroundTint: Color {
        switch style {
        case .dark:
            brandPalette.ink
        case .light:
            Color.white.opacity(0.72)
        }
    }

    private var borderTint: Color {
        switch style {
        case .dark:
            brandPalette.ink.opacity(0.2)
        case .light:
            brandPalette.ink.opacity(0.18)
        }
    }

    private var titleTint: Color {
        switch style {
        case .dark:
            .white
        case .light:
            brandPalette.ink
        }
    }

    private var iconTint: Color {
        switch style {
        case .dark:
            .white
        case .light:
            brandPalette.ink
        }
    }

    private var progressTint: Color {
        switch style {
        case .dark:
            .white
        case .light:
            brandPalette.ink
        }
    }
}
