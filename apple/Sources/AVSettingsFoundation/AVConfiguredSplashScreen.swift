import AVBrandFoundation
import AVLaunchFoundation
import SwiftUI

public struct AVConfiguredSplashScreen: View {
    @Environment(\.avCommonAppExperience) private var appExperience
    @Environment(\.avBrandPalette) private var brandPalette

    public init() {}

    public var body: some View {
        AVSplashScreen(
            content: appExperience.splashContent,
            logo: {
                Image(appExperience.visualAssets?.splashLogoName ?? appExperience.identity.shortName)
                    .resizable()
                    .scaledToFit()
            },
            hero: {
                AVConfiguredSplashHero(
                    heroAssetName: appExperience.visualAssets?.splashHeroName,
                    assistantAssetName: appExperience.visualAssets?.footerAssistantName,
                    accentColor: brandPalette.accent
                )
            }
        )
    }
}

public struct AVConfiguredSplashHero: View {
    private let heroAssetName: String?
    private let assistantAssetName: String?
    private let accentColor: Color

    public init(
        heroAssetName: String? = nil,
        assistantAssetName: String? = nil,
        accentColor: Color = AVBrandColor.accent
    ) {
        self.heroAssetName = heroAssetName
        self.assistantAssetName = assistantAssetName
        self.accentColor = accentColor
    }

    public var body: some View {
        if let heroAssetName {
            AVSplashAssetHero(
                heroAssetName: heroAssetName,
                accentColor: accentColor
            )
        } else {
            AVSplashMemoryFilmHero(
                assistantAssetName: assistantAssetName,
                accentColor: accentColor
            )
        }
    }
}

private struct AVSplashAssetHero: View {
    let heroAssetName: String
    let accentColor: Color

    var body: some View {
        ZStack {
            Image(heroAssetName)
                .resizable()
                .scaledToFill()
                .frame(width: 330, height: 386)
                .clipped()
                .opacity(0.96)
                .overlay {
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.04),
                            Color.white.opacity(0.20)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .shadow(color: AVBrandColor.ink.opacity(0.08), radius: 16, y: 8)

            AVSplashAccentRings(
                sizes: [136, 184, 232],
                trim: 0.04...0.24,
                opacity: 0.16,
                opacityStep: 0.032,
                rotation: .degrees(-22),
                offset: CGSize(width: 94, height: 28),
                color: accentColor
            )
        }
        .frame(width: 330, height: 386)
        .accessibilityHidden(true)
    }
}
