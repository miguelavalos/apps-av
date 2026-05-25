import AVBrandFoundation
import SwiftUI

public struct AVAppShellPrimaryButton: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let systemImage: String?
    private let isDisabled: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        systemImage: String? = nil,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.xs) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 14, weight: .black))
                }

                Text(title)
                    .font(AVBrandTypography.button)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .foregroundStyle(brandPalette.ink)
            .frame(maxWidth: .infinity, minHeight: 46)
            .padding(.horizontal, AVBrandSpacing.lg)
            .background(background, in: RoundedRectangle(cornerRadius: AVBrandRadius.control, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.control, style: .continuous)
                    .stroke(AVBrandColor.glassStroke.opacity(isDisabled ? 0.25 : 0.48), lineWidth: 1)
            }
            .shadow(color: AVBrandColor.softShadow.opacity(isDisabled ? 0 : 0.12), radius: 10, y: 6)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.52 : 1)
        .accessibilityLabel(title)
    }

    private var background: Color {
        isDisabled ? AVBrandColor.mutedSurface : brandPalette.accent
    }
}
