import AVBrandFoundation
import SwiftUI

public struct AVFeedbackStatusBadge: View {
    private let systemImage: String
    private let accessibilityLabel: String
    private let isHighlighted: Bool
    private let size: CGFloat
    private let fontSize: CGFloat?
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
        self.fontSize = fontSize
        self.borderOpacity = borderOpacity
    }

    public var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: fontSize ?? size * 0.41, weight: .black))
            .foregroundStyle(isHighlighted ? AVBrandColor.brandBlack : AVBrandColor.textInverse)
            .frame(width: size, height: size)
            .background(backgroundColor, in: Circle())
            .overlay {
                Circle()
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
            }
            .accessibilityLabel(accessibilityLabel)
    }

    private var backgroundColor: Color {
        isHighlighted ? AVBrandColor.accent : AVBrandColor.brandGraphite.opacity(0.86)
    }
}
