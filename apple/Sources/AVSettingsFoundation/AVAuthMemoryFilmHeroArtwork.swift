import AVBrandFoundation
import SwiftUI

public struct AVAuthMemoryFilmHeroArtwork: View {
    public init() {}

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(Array(photoFrames.enumerated()), id: \.offset) { index, frame in
                    AVAuthMemoryPhotoFrame(frame: frame)
                        .zIndex(Double(index))
                }

                AVAuthMemoryFilmStrip()
                    .rotationEffect(.degrees(-7))
                    .offset(x: -118, y: 86)

                AVAuthMemoryFilmStrip()
                    .rotationEffect(.degrees(9))
                    .offset(x: 122, y: 68)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    private var photoFrames: [AVAuthMemoryPhotoFrameModel] {
        [
            AVAuthMemoryPhotoFrameModel(
                size: CGSize(width: 218, height: 286),
                offset: CGSize(width: -82, height: 48),
                rotation: -10,
                lineWidth: 116,
                gradient: LinearGradient(
                    colors: [Color(red: 0.95, green: 0.62, blue: 0.48), Color(red: 0.37, green: 0.54, blue: 0.68)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            AVAuthMemoryPhotoFrameModel(
                size: CGSize(width: 232, height: 304),
                offset: CGSize(width: 76, height: 28),
                rotation: 8,
                lineWidth: 136,
                gradient: LinearGradient(
                    colors: [Color(red: 0.64, green: 0.77, blue: 0.58), Color(red: 0.96, green: 0.82, blue: 0.55)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            ),
            AVAuthMemoryPhotoFrameModel(
                size: CGSize(width: 214, height: 254),
                offset: CGSize(width: 8, height: 152),
                rotation: -2,
                lineWidth: 104,
                gradient: LinearGradient(
                    colors: [Color(red: 0.47, green: 0.63, blue: 0.82), Color(red: 0.88, green: 0.71, blue: 0.76)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        ]
    }
}

private struct AVAuthMemoryPhotoFrame: View {
    let frame: AVAuthMemoryPhotoFrameModel

    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(frame.gradient)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 6) {
                    Capsule(style: .continuous)
                        .fill(.white.opacity(0.72))
                        .frame(width: frame.lineWidth, height: 7)

                    Capsule(style: .continuous)
                        .fill(.white.opacity(0.42))
                        .frame(width: frame.lineWidth * 0.62, height: 6)
                }
                .padding(18)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
            .frame(width: frame.size.width, height: frame.size.height)
            .rotationEffect(.degrees(frame.rotation))
            .offset(x: frame.offset.width, y: frame.offset.height)
            .shadow(color: AVBrandColor.ink.opacity(0.1), radius: 18, y: 10)
    }
}

private struct AVAuthMemoryFilmStrip: View {
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.white.opacity(0.38))
                    .frame(width: 76, height: 46)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
            }
        }
        .padding(10)
        .background(.white.opacity(0.16), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: AVBrandColor.ink.opacity(0.08), radius: 14, y: 8)
        .accessibilityHidden(true)
    }
}

private struct AVAuthMemoryPhotoFrameModel {
    let size: CGSize
    let offset: CGSize
    let rotation: Double
    let lineWidth: CGFloat
    let gradient: LinearGradient
}
