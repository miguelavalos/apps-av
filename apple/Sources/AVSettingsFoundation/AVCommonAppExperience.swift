import AVAppShellFoundation
import AVBrandFoundation
import AVLaunchFoundation
import SwiftUI

public struct AVCommonAppExperience: Sendable {
    public var identity: AVAppIdentity
    public var legalLinks: AVAppLegalLinks
    public var brandPalette: AVBrandPalette
    public var visualAssets: AVCommonAppVisualAssets?
    public var splashContent: AVSplashContent
    public var onboardingContent: AVAuthOnboardingContent
    public var footerConfiguration: AVAppShellFooterConfiguration

    public init(
        identity: AVAppIdentity,
        legalLinks: AVAppLegalLinks = AVAppLegalLinks(),
        brandPalette: AVBrandPalette = .standard,
        visualAssets: AVCommonAppVisualAssets? = nil,
        splashContent: AVSplashContent,
        onboardingContent: AVAuthOnboardingContent,
        footerConfiguration: AVAppShellFooterConfiguration = .contentOnly
    ) {
        self.identity = identity
        self.legalLinks = legalLinks
        self.brandPalette = brandPalette
        self.visualAssets = visualAssets
        self.splashContent = splashContent
        self.onboardingContent = onboardingContent
        self.footerConfiguration = footerConfiguration
    }

    public init(
        identity: AVAppIdentity,
        legalLinks: AVAppLegalLinks = AVAppLegalLinks(),
        brandPalette: AVBrandPalette = .standard,
        visualAssets: AVCommonAppVisualAssets? = nil,
        splashTagline: String,
        splashStatus: String? = nil,
        onboardingTitle: String,
        onboardingSubtitle: String,
        onboardingPrimaryTitle: String,
        onboardingSecondaryTitle: String? = nil,
        onboardingBackgroundStart: Color = AVBrandColor.launchSurfaceStart,
        onboardingBackgroundMid: Color = AVBrandColor.neutral50,
        onboardingBackgroundEnd: Color = AVBrandColor.neutral100,
        footerConfiguration: AVAppShellFooterConfiguration = .contentOnly
    ) {
        self.init(
            identity: identity,
            legalLinks: legalLinks,
            brandPalette: brandPalette,
            visualAssets: visualAssets,
            splashContent: AVSplashContent(
                identity: identity,
                tagline: splashTagline,
                status: splashStatus
            ),
            onboardingContent: AVAuthOnboardingContent(
                identity: identity,
                title: onboardingTitle,
                subtitle: onboardingSubtitle,
                primaryTitle: onboardingPrimaryTitle,
                secondaryTitle: onboardingSecondaryTitle,
                backgroundStart: onboardingBackgroundStart,
                backgroundMid: onboardingBackgroundMid,
                backgroundEnd: onboardingBackgroundEnd
            ),
            footerConfiguration: footerConfiguration
        )
    }
}

private struct AVCommonAppExperienceKey: EnvironmentKey {
    static let defaultValue = AVCommonAppExperience(
        identity: AVAppIdentity(displayName: "Apps AV", assistantName: "Avi", accountName: "Account AV"),
        splashTagline: "",
        onboardingTitle: "",
        onboardingSubtitle: "",
        onboardingPrimaryTitle: ""
    )
}

public extension EnvironmentValues {
    var avCommonAppExperience: AVCommonAppExperience {
        get { self[AVCommonAppExperienceKey.self] }
        set { self[AVCommonAppExperienceKey.self] = newValue }
    }
}

public extension View {
    func avCommonAppExperience(_ experience: AVCommonAppExperience) -> some View {
        environment(\.avCommonAppExperience, experience)
            .avBrandPalette(experience.brandPalette)
    }
}
