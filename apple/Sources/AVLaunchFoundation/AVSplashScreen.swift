import AVBrandFoundation
import SwiftUI

public struct AVSplashScreen<Logo: View, Hero: View>: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.avBrandPalette) private var brandPalette

    private let tagline: String
    private let status: String
    private let logo: () -> Logo
    private let hero: () -> Hero

    @State private var backdropExpanded = false
    @State private var contentVisible = false
    @State private var statusVisible = false

    public init(
        tagline: String,
        status: String,
        @ViewBuilder logo: @escaping () -> Logo,
        @ViewBuilder hero: @escaping () -> Hero
    ) {
        self.tagline = tagline
        self.status = status
        self.logo = logo
        self.hero = hero
    }

    public var body: some View {
        ZStack {
            AVBrandSurface.launchBackground(for: brandPalette)
                .ignoresSafeArea()

            AVSplashAmbientBackdrop(expanded: backdropExpanded, palette: brandPalette)

            VStack(spacing: 0) {
                logo()
                    .frame(width: 232, height: 78)
                    .opacity(contentVisible ? 1 : 0)
                    .padding(.top, 92)

                Spacer(minLength: 14)

                hero()
                    .scaleEffect(contentVisible ? 1 : 0.94)
                    .opacity(contentVisible ? 1 : 0.68)
                    .padding(.horizontal, 4)

                Spacer(minLength: 18)

                VStack(spacing: 10) {
                    Text(tagline)
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .foregroundStyle(brandPalette.ink)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 8) {
                        Circle()
                            .fill(brandPalette.accent)
                            .frame(width: 7, height: 7)

                        Text(status)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(brandPalette.ink.opacity(0.72))
                    }
                    .opacity(statusVisible ? 1 : 0)
                    .offset(y: statusVisible ? 0 : 8)
                }
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 10)

                Spacer(minLength: 88)
            }
            .padding(.horizontal, 24)
        }
        .onAppear(perform: startAnimations)
        .accessibilityHidden(true)
    }

    private func startAnimations() {
        guard !reduceMotion else {
            backdropExpanded = true
            contentVisible = true
            statusVisible = true
            return
        }

        withAnimation(.easeOut(duration: 0.7)) {
            backdropExpanded = true
        }

        withAnimation(.spring(response: 0.76, dampingFraction: 0.82).delay(0.1)) {
            contentVisible = true
        }

        withAnimation(.easeOut(duration: 0.45).delay(0.28)) {
            statusVisible = true
        }
    }
}

private struct AVSplashAmbientBackdrop: View {
    let expanded: Bool
    let palette: AVBrandPalette

    var body: some View {
        ZStack {
            RadialGradient(
                colors: [
                    palette.accent.opacity(0.18),
                    palette.accent.opacity(0.06),
                    .clear
                ],
                center: .center,
                startRadius: 12,
                endRadius: 260
            )
            .frame(width: 420, height: 420)
            .blur(radius: 10)
            .scaleEffect(expanded ? 1 : 0.82)

            ForEach(Array([110.0, 166.0, 224.0].enumerated()), id: \.offset) { index, size in
                Circle()
                    .trim(from: 0.05, to: 0.35)
                    .stroke(palette.accent.opacity(0.13 - Double(index) * 0.025), lineWidth: 1.4)
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(-32))
                    .offset(x: 92, y: -18)
                    .scaleEffect(expanded ? 1 : 0.76)
            }

            ForEach(Array([0.0, 1.0, 2.0, 3.0].enumerated()), id: \.offset) { index, _ in
                Circle()
                    .fill(index == 1 ? palette.accent.opacity(0.24) : palette.ink.opacity(0.08))
                    .frame(width: index == 1 ? 7 : 4, height: index == 1 ? 7 : 4)
                    .offset(x: CGFloat(index * 52 - 92), y: CGFloat(index % 2 == 0 ? 132 : -138))
                    .opacity(expanded ? 1 : 0.2)
            }
        }
        .accessibilityHidden(true)
    }
}
