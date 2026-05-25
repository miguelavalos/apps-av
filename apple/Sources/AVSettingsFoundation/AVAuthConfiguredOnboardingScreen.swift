import AVAviFoundation
import AVBrandFoundation
import SwiftUI

public enum AVAuthConfiguredCompanionPlacement: Sendable {
    case callToAction
    case authPanel
}

public struct AVAuthConfiguredCompanionArtwork: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    private let placement: AVAuthConfiguredCompanionPlacement
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let frameWidth: CGFloat
    private let frameHeight: CGFloat
    private let imageOffset: CGSize
    private let groundShadowColor: Color?

    public init(
        placement: AVAuthConfiguredCompanionPlacement,
        imageWidth: CGFloat = 146,
        imageHeight: CGFloat = 146,
        frameWidth: CGFloat = 146,
        frameHeight: CGFloat = 150,
        imageOffset: CGSize = .zero,
        groundShadowColor: Color? = AVBrandColor.ink.opacity(0.08)
    ) {
        self.placement = placement
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.imageOffset = imageOffset
        self.groundShadowColor = groundShadowColor
    }

    public var body: some View {
        AVAviCompanionArtwork(
            assetName: assetName,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            frameWidth: frameWidth,
            frameHeight: frameHeight,
            imageOffset: imageOffset,
            shadow: .init(color: AVBrandColor.ink.opacity(0.1), radius: 8, y: 5),
            groundShadowColor: groundShadowColor
        )
    }

    private var assetName: String {
        guard let visualAssets = appExperience.visualAssets else {
            return "AviFooterIcon"
        }

        switch placement {
        case .callToAction:
            return visualAssets.onboardingCTACompanionName
        case .authPanel:
            return visualAssets.onboardingAuthPanelCompanionName
        }
    }
}

public struct AVAuthConfiguredHeroArtwork: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    public init() {}

    public var body: some View {
        Group {
            if let assetName = appExperience.visualAssets?.onboardingHeroName {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
            } else {
                AVAuthMemoryFilmHeroArtwork()
            }
        }
        .accessibilityHidden(true)
    }
}

public struct AVAuthConfiguredOnboardingScreen<HeroArtwork: View, AuthPanel: View>: View {
    @Binding private var authOptionsArePresented: Bool

    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let brandWidth: CGFloat
    private let brandHeight: CGFloat
    private let ctaCompanionOffset: CGSize
    private let heroArtwork: HeroArtwork
    private let authPanel: AuthPanel

    @Environment(\.avCommonAppExperience) private var appExperience

    public init(
        authOptionsArePresented: Binding<Bool>,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        brandWidth: CGFloat = 168,
        brandHeight: CGFloat = 54,
        ctaCompanionOffset: CGSize = CGSize(width: -2, height: -98),
        @ViewBuilder heroArtwork: () -> HeroArtwork,
        @ViewBuilder authPanel: () -> AuthPanel
    ) {
        self._authOptionsArePresented = authOptionsArePresented
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.brandWidth = brandWidth
        self.brandHeight = brandHeight
        self.ctaCompanionOffset = ctaCompanionOffset
        self.heroArtwork = heroArtwork()
        self.authPanel = authPanel()
    }

    public var body: some View {
        AVAuthOnboardingScreen(
            authOptionsArePresented: $authOptionsArePresented,
            content: appExperience.onboardingContent,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            brand: {
                Image(appExperience.visualAssets?.onboardingBrandName ?? appExperience.identity.displayName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: brandWidth, height: brandHeight)
            },
            heroArtwork: {
                heroArtwork
            },
            ctaCompanion: {
                AVAuthConfiguredCompanionArtwork(placement: .callToAction)
                    .offset(ctaCompanionOffset)
            },
            authPanel: {
                authPanel
            }
        )
    }
}

public extension AVAuthConfiguredOnboardingScreen where HeroArtwork == AVAuthConfiguredHeroArtwork {
    init(
        authOptionsArePresented: Binding<Bool>,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        brandWidth: CGFloat = 168,
        brandHeight: CGFloat = 54,
        ctaCompanionOffset: CGSize = CGSize(width: -2, height: -98),
        @ViewBuilder authPanel: () -> AuthPanel
    ) {
        self.init(
            authOptionsArePresented: authOptionsArePresented,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            brandWidth: brandWidth,
            brandHeight: brandHeight,
            ctaCompanionOffset: ctaCompanionOffset,
            heroArtwork: {
                AVAuthConfiguredHeroArtwork()
            },
            authPanel: authPanel
        )
    }
}
