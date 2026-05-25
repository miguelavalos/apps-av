public struct AVCommonAppVisualAssets: Hashable, Sendable {
    public var headerLogoName: String
    public var splashLogoName: String
    public var splashHeroName: String?
    public var onboardingBrandName: String
    public var onboardingHeroName: String?
    public var onboardingCTACompanionName: String
    public var onboardingAuthPanelCompanionName: String
    public var footerAssistantName: String

    public init(
        headerLogoName: String,
        splashLogoName: String? = nil,
        splashHeroName: String? = nil,
        onboardingBrandName: String? = nil,
        onboardingHeroName: String? = nil,
        onboardingCTACompanionName: String,
        onboardingAuthPanelCompanionName: String? = nil,
        footerAssistantName: String? = nil
    ) {
        self.headerLogoName = headerLogoName
        self.splashLogoName = splashLogoName ?? headerLogoName
        self.splashHeroName = splashHeroName
        self.onboardingBrandName = onboardingBrandName ?? headerLogoName
        self.onboardingHeroName = onboardingHeroName
        self.onboardingCTACompanionName = onboardingCTACompanionName
        self.onboardingAuthPanelCompanionName = onboardingAuthPanelCompanionName ?? onboardingCTACompanionName
        self.footerAssistantName = footerAssistantName ?? onboardingCTACompanionName
    }
}
