import AVBrandFoundation
import SwiftUI

public struct AVCircularMaterialIconButton: View {
    private let systemImage: String
    private let size: CGFloat
    private let fontSize: CGFloat
    private let fontWeight: Font.Weight
    private let isEnabled: Bool
    private let accessibilityLabel: String?
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        systemImage: String,
        size: CGFloat,
        fontSize: CGFloat,
        fontWeight: Font.Weight = .bold,
        isEnabled: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.size = size
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.isEnabled = isEnabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: fontSize, weight: fontWeight))
                .foregroundStyle(AVBrandColor.textSecondary.opacity(isEnabled ? 1 : 0.28))
                .frame(width: size, height: size)
                .background(.ultraThinMaterial.opacity(isEnabled ? 1 : 0.45), in: Circle())
                .overlay {
                    Circle()
                        .stroke(.white.opacity(isEnabled ? 0.12 : 0.06), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .applyAccessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

private extension View {
    @ViewBuilder
    func applyAccessibilityLabel(_ label: String?) -> some View {
        if let label {
            accessibilityLabel(label)
        } else {
            self
        }
    }
}
