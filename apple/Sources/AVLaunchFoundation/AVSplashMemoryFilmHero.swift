import AVBrandFoundation
import SwiftUI

public struct AVSplashMemoryFilmHero: View {
    private let assistantAssetName: String?
    private let accentColor: Color

    public init(
        assistantAssetName: String? = nil,
        accentColor: Color = AVBrandColor.accent
    ) {
        self.assistantAssetName = assistantAssetName
        self.accentColor = accentColor
    }

    public var body: some View {
        ZStack {
            mainFrame

            ForEach(Array(supportingFrames.enumerated()), id: \.offset) { index, frame in
                AVSplashMemoryFrame(frame: frame)
                    .zIndex(Double(index))
            }

            if let assistantAssetName {
                Image(assistantAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118, height: 118)
                    .padding(16)
                    .background(.white.opacity(0.54), in: Circle())
                    .shadow(color: AVBrandColor.ink.opacity(0.12), radius: 12, y: 8)
                    .offset(x: 72, y: 112)
            }

            AVSplashAccentRings(color: accentColor)
        }
        .frame(width: 330, height: 386)
        .accessibilityHidden(true)
    }

    private var mainFrame: some View {
        RoundedRectangle(cornerRadius: 34, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.82, blue: 0.56),
                        Color(red: 0.75, green: 0.86, blue: 0.7),
                        Color(red: 0.62, green: 0.73, blue: 0.88)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 300, height: 356)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    Capsule(style: .continuous)
                        .fill(.white.opacity(0.68))
                        .frame(width: 112, height: 9)

                    Capsule(style: .continuous)
                        .fill(.white.opacity(0.38))
                        .frame(width: 74, height: 7)
                }
                .padding(24)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
            .shadow(color: AVBrandColor.ink.opacity(0.1), radius: 18, y: 10)
    }

    private var supportingFrames: [AVSplashMemoryFrameModel] {
        [
            AVSplashMemoryFrameModel(
                size: CGSize(width: 166, height: 214),
                offset: CGSize(width: -88, height: -52),
                rotation: -11,
                gradient: LinearGradient(
                    colors: [Color(red: 0.94, green: 0.62, blue: 0.53), Color(red: 0.52, green: 0.63, blue: 0.82)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            AVSplashMemoryFrameModel(
                size: CGSize(width: 148, height: 190),
                offset: CGSize(width: 104, height: -72),
                rotation: 9,
                gradient: LinearGradient(
                    colors: [Color(red: 0.58, green: 0.78, blue: 0.65), Color(red: 0.96, green: 0.82, blue: 0.58)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
    }
}

private struct AVSplashMemoryFrame: View {
    let frame: AVSplashMemoryFrameModel

    var body: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(frame.gradient)
            .frame(width: frame.size.width, height: frame.size.height)
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.48), lineWidth: 1)
            }
            .rotationEffect(.degrees(frame.rotation))
            .offset(x: frame.offset.width, y: frame.offset.height)
            .shadow(color: AVBrandColor.ink.opacity(0.08), radius: 12, y: 8)
    }
}

private struct AVSplashMemoryFrameModel {
    let size: CGSize
    let offset: CGSize
    let rotation: Double
    let gradient: LinearGradient
}
