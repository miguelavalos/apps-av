import AVBrandFoundation
import SwiftUI

public struct AVSplashAccentRings: View {
    private let sizes: [CGFloat]
    private let trim: ClosedRange<CGFloat>
    private let opacity: Double
    private let opacityStep: Double
    private let lineWidth: CGFloat
    private let rotation: Angle
    private let offset: CGSize
    private let color: Color?

    public init(
        sizes: [CGFloat] = [134, 184, 236],
        trim: ClosedRange<CGFloat> = 0.04...0.26,
        opacity: Double = 0.15,
        opacityStep: Double = 0.03,
        lineWidth: CGFloat = 1.5,
        rotation: Angle = .degrees(-24),
        offset: CGSize = CGSize(width: 76, height: 32),
        color: Color? = nil
    ) {
        self.sizes = sizes
        self.trim = trim
        self.opacity = opacity
        self.opacityStep = opacityStep
        self.lineWidth = lineWidth
        self.rotation = rotation
        self.offset = offset
        self.color = color
    }

    public var body: some View {
        ForEach(Array(sizes.enumerated()), id: \.offset) { index, size in
            Circle()
                .trim(from: trim.lowerBound, to: trim.upperBound)
                .stroke(ringColor.opacity(opacity - Double(index) * opacityStep), lineWidth: lineWidth)
                .frame(width: size, height: size)
                .rotationEffect(rotation)
                .offset(offset)
        }
        .accessibilityHidden(true)
    }

    @Environment(\.avBrandPalette) private var brandPalette

    private var ringColor: Color {
        color ?? brandPalette.accent
    }
}
