import AVBrandFoundation
import SwiftUI

public struct AVStatusPill: View {
    private let title: String
    private let isUppercased: Bool
    private let fontSize: CGFloat
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    private let fillOpacity: Double
    private let strokeOpacity: Double

    public init(
        title: String,
        isUppercased: Bool = true,
        fontSize: CGFloat = 12,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 8,
        fillOpacity: Double = 0.1,
        strokeOpacity: Double = 0.22
    ) {
        self.title = title
        self.isUppercased = isUppercased
        self.fontSize = fontSize
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.fillOpacity = fillOpacity
        self.strokeOpacity = strokeOpacity
    }

    public var body: some View {
        Text(displayTitle)
            .font(.system(size: fontSize, weight: .semibold))
            .foregroundStyle(AVBrandColor.accent)
            .lineLimit(1)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(AVBrandColor.accent.opacity(fillOpacity), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(AVBrandColor.accent.opacity(strokeOpacity), lineWidth: 1)
            }
    }

    private var displayTitle: String {
        isUppercased ? title.uppercased() : title
    }
}
