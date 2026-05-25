import AVAppShellFoundation

public extension AVAppShellConfiguredAssistant {
    init(
        experience: AVCommonAppExperience,
        id: String = "avi",
        accessibilityIdentifier: String,
        fallbackAssetName: String = "AviFooterIcon"
    ) {
        self.init(
            id: id,
            name: experience.identity.assistantName,
            accessibilityIdentifier: accessibilityIdentifier,
            assetName: experience.visualAssets?.footerAssistantName ?? fallbackAssetName
        )
    }
}
