import AVBrandFoundation
import SwiftUI

public struct AVAppShellAssetBrandHeader: View {
    private let identity: AVAppIdentity
    private let logoAssetName: String
    private let activeItem: AVAppShellChromeItem?
    private let settingsAccessibilityLabel: String
    private let accountAccessibilityLabel: String?
    private let selectedAccessibilityValue: String
    private let openSettings: () -> Void
    private let openAccount: () -> Void

    public init(
        identity: AVAppIdentity,
        logoAssetName: String,
        activeItem: AVAppShellChromeItem? = nil,
        settingsAccessibilityLabel: String = "Settings",
        accountAccessibilityLabel: String? = nil,
        selectedAccessibilityValue: String = "Selected",
        openSettings: @escaping () -> Void,
        openAccount: @escaping () -> Void
    ) {
        self.identity = identity
        self.logoAssetName = logoAssetName
        self.activeItem = activeItem
        self.settingsAccessibilityLabel = settingsAccessibilityLabel
        self.accountAccessibilityLabel = accountAccessibilityLabel
        self.selectedAccessibilityValue = selectedAccessibilityValue
        self.openSettings = openSettings
        self.openAccount = openAccount
    }

    public var body: some View {
        AVAppShellBrandHeader(
            identity: identity,
            activeItem: activeItem,
            settingsAccessibilityLabel: settingsAccessibilityLabel,
            accountAccessibilityLabel: accountAccessibilityLabel,
            selectedAccessibilityValue: selectedAccessibilityValue
        ) {
            Image(logoAssetName)
                .resizable()
                .scaledToFit()
                .accessibilityLabel(identity.displayName)
        } openSettings: {
            openSettings()
        } openAccount: {
            openAccount()
        }
    }
}
