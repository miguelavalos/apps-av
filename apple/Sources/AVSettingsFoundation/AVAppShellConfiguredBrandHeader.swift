import AVAppShellFoundation
import SwiftUI

public struct AVAppShellConfiguredBrandHeader: View {
    @Environment(\.avCommonAppExperience) private var appExperience

    private let activeItem: AVAppShellChromeItem?
    private let settingsAccessibilityLabel: String
    private let accountAccessibilityLabel: String?
    private let selectedAccessibilityValue: String
    private let fallbackLogoAssetName: String
    private let openSettings: () -> Void
    private let openAccount: () -> Void

    public init(
        activeItem: AVAppShellChromeItem? = nil,
        settingsAccessibilityLabel: String = "Settings",
        accountAccessibilityLabel: String? = "Account",
        selectedAccessibilityValue: String = "Selected",
        fallbackLogoAssetName: String = "HeaderWordmark",
        openSettings: @escaping () -> Void,
        openAccount: @escaping () -> Void
    ) {
        self.activeItem = activeItem
        self.settingsAccessibilityLabel = settingsAccessibilityLabel
        self.accountAccessibilityLabel = accountAccessibilityLabel
        self.selectedAccessibilityValue = selectedAccessibilityValue
        self.fallbackLogoAssetName = fallbackLogoAssetName
        self.openSettings = openSettings
        self.openAccount = openAccount
    }

    public var body: some View {
        AVAppShellAssetBrandHeader(
            identity: appExperience.identity,
            logoAssetName: appExperience.visualAssets?.headerLogoName ?? fallbackLogoAssetName,
            activeItem: activeItem,
            settingsAccessibilityLabel: settingsAccessibilityLabel,
            accountAccessibilityLabel: accountAccessibilityLabel,
            selectedAccessibilityValue: selectedAccessibilityValue,
            openSettings: openSettings,
            openAccount: openAccount
        )
    }
}
