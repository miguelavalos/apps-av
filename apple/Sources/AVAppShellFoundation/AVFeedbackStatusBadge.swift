import AVBrandFoundation
import SwiftUI

public struct AVFeedbackStatusBadge: View {
    @Environment(\.avBrandPalette) private var brandPalette
    @AVScaledFontSize private var iconSize: CGFloat

    private let systemImage: String
    private let accessibilityLabel: String
    private let isHighlighted: Bool
    private let size: CGFloat
    private let borderOpacity: Double

    public init(
        systemImage: String,
        accessibilityLabel: String,
        isHighlighted: Bool = false,
        size: CGFloat = 22,
        fontSize: CGFloat? = nil,
        borderOpacity: Double = 0.78
    ) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.isHighlighted = isHighlighted
        self.size = size
        self.borderOpacity = borderOpacity
        _iconSize = AVScaledFontSize(wrappedValue: fontSize ?? size * 0.41)
    }

    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: iconSize, weight: .black))
            .foregroundStyle(isHighlighted ? brandPalette.ink : AVBrandColor.textInverse)
            .frame(width: size + $iconSize, height: size + $iconSize)
            .background(backgroundColor, in: Circle())
            .overlay {
                Circle()
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
            }
            .accessibilityLabel(accessibilityLabel)
            // The badge marks a corner of an artwork or a control that keeps its size: past the
            // second accessibility size it would cover what it marks.
            .dynamicTypeSize(...DynamicTypeSize.accessibility2)
    }

    private var backgroundColor: Color {
        isHighlighted ? brandPalette.accent : brandPalette.ink.opacity(0.86)
    }
}
