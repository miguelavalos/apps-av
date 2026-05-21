import SwiftUI

public struct AVArtworkZoomOverlay<Artwork: View>: View {
    private let title: String
    private let subtitle: String
    private let accessibilityIdentifier: String
    private let dismiss: () -> Void
    private let artwork: (CGFloat) -> Artwork

    public init(
        title: String,
        subtitle: String,
        accessibilityIdentifier: String,
        dismiss: @escaping () -> Void,
        @ViewBuilder artwork: @escaping (CGFloat) -> Artwork
    ) {
        self.title = title
        self.subtitle = subtitle
        self.accessibilityIdentifier = accessibilityIdentifier
        self.dismiss = dismiss
        self.artwork = artwork
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.black.opacity(0.76))
                .ignoresSafeArea()
                .onTapGesture(perform: dismiss)

            GeometryReader { proxy in
                let artworkSize = min(proxy.size.width - 8, 372)
                let captionWidth = min(artworkSize, 360)

                VStack(spacing: 12) {
                    artwork(artworkSize)
                        .shadow(color: .black.opacity(0.46), radius: 32, y: 18)

                    VStack(spacing: 7) {
                        Text(title)
                            .font(.system(size: 27, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)

                        Text(subtitle)
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(.white.opacity(0.92))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.74)
                    }
                    .frame(width: captionWidth - 28)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 15)
                    .background(.black.opacity(0.92), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(.white.opacity(0.24), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.52), radius: 22, y: 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 4)
            }
        }
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
