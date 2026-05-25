import AVBrandFoundation
import SwiftUI

public struct AVAviCompanionArtwork: View {
    public struct Shadow: Sendable {
        public var color: Color
        public var radius: CGFloat
        public var y: CGFloat

        public init(color: Color = AVBrandColor.ink.opacity(0.12), radius: CGFloat = 10, y: CGFloat = 7) {
            self.color = color
            self.radius = radius
            self.y = y
        }
    }

    private let assetName: String
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let frameWidth: CGFloat
    private let frameHeight: CGFloat
    private let imageOffset: CGSize
    private let shadow: Shadow
    private let groundShadowColor: Color?

    public init(
        assetName: String,
        imageWidth: CGFloat = 146,
        imageHeight: CGFloat = 146,
        frameWidth: CGFloat = 146,
        frameHeight: CGFloat = 150,
        imageOffset: CGSize = .zero,
        shadow: Shadow = Shadow(),
        groundShadowColor: Color? = AVBrandColor.ink.opacity(0.1)
    ) {
        self.assetName = assetName
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.imageOffset = imageOffset
        self.shadow = shadow
        self.groundShadowColor = groundShadowColor
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if let groundShadowColor {
                Capsule(style: .continuous)
                    .fill(groundShadowColor)
                    .frame(width: 82, height: 11)
                    .blur(radius: 5)
                    .offset(x: 4, y: 2)
            }

            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageHeight)
                .shadow(color: shadow.color, radius: shadow.radius, y: shadow.y)
                .offset(imageOffset)
        }
        .frame(width: frameWidth, height: frameHeight)
        .accessibilityHidden(true)
    }
}
