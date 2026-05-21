import AVBrandFoundation
import SwiftUI

public struct AVFramedArtwork<Content: View>: View {
    private let size: CGFloat
    private let cornerRadius: CGFloat
    private let strokeOpacity: Double
    private let lineWidth: CGFloat
    private let content: Content

    public init(
        size: CGFloat,
        cornerRadius: CGFloat,
        strokeOpacity: Double = 1,
        lineWidth: CGFloat = 1,
        @ViewBuilder content: () -> Content
    ) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.strokeOpacity = strokeOpacity
        self.lineWidth = lineWidth
        self.content = content()
    }

    public var body: some View {
        content
            .frame(width: size, height: size)
            .clipShape(shape)
            .overlay {
                shape
                    .stroke(AVBrandColor.borderSubtle.opacity(strokeOpacity), lineWidth: lineWidth)
            }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}
