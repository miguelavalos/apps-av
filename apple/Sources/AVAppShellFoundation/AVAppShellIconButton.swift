import AVBrandFoundation
import SwiftUI

public struct AVAppShellIconButton: View {
    private let systemName: String
    private let accessibilityLabel: String
    private let accessibilityValue: String?
    private let accessibilityIdentifier: String?
    private let isSelected: Bool
    private let fontSize: CGFloat
    private let action: () -> Void

    public init(
        systemName: String,
        accessibilityLabel: String,
        accessibilityValue: String? = nil,
        accessibilityIdentifier: String? = nil,
        isSelected: Bool = false,
        fontSize: CGFloat = 15,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.accessibilityIdentifier = accessibilityIdentifier
        self.isSelected = isSelected
        self.fontSize = fontSize
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textPrimary)
                .frame(width: 36, height: 36)
                .background(isSelected ? AVBrandColor.footerGlassSelected : AVBrandColor.elevatedSurface, in: Circle())
                .overlay {
                    Circle()
                        .stroke(
                            isSelected ? AVBrandColor.accent.opacity(0.28) : AVBrandColor.borderSubtle.opacity(0.52),
                            lineWidth: 1
                        )
                }
                .shadow(color: AVBrandColor.accent.opacity(isSelected ? 0.12 : 0), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue ?? "")
        .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

private extension View {
    @ViewBuilder
    func applyAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}
