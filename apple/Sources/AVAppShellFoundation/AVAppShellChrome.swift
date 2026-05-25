import AVBrandFoundation
import SwiftUI

public enum AVAppShellChromeItem: Hashable {
    case settings
    case account
}

public struct AVAppShellBrandHeader<Logo: View>: View {
    private let activeItem: AVAppShellChromeItem?
    private let settingsAccessibilityLabel: String
    private let accountAccessibilityLabel: String
    private let selectedAccessibilityValue: String
    private let logo: Logo
    private let openSettings: () -> Void
    private let openAccount: () -> Void

    public init(
        activeItem: AVAppShellChromeItem? = nil,
        settingsAccessibilityLabel: String,
        accountAccessibilityLabel: String,
        selectedAccessibilityValue: String = "Selected",
        @ViewBuilder logo: () -> Logo,
        openSettings: @escaping () -> Void,
        openAccount: @escaping () -> Void
    ) {
        self.activeItem = activeItem
        self.settingsAccessibilityLabel = settingsAccessibilityLabel
        self.accountAccessibilityLabel = accountAccessibilityLabel
        self.selectedAccessibilityValue = selectedAccessibilityValue
        self.logo = logo()
        self.openSettings = openSettings
        self.openAccount = openAccount
    }

    public init(
        identity: AVAppIdentity,
        activeItem: AVAppShellChromeItem? = nil,
        settingsAccessibilityLabel: String = "Settings",
        accountAccessibilityLabel: String? = nil,
        selectedAccessibilityValue: String = "Selected",
        @ViewBuilder logo: () -> Logo,
        openSettings: @escaping () -> Void,
        openAccount: @escaping () -> Void
    ) {
        self.init(
            activeItem: activeItem,
            settingsAccessibilityLabel: settingsAccessibilityLabel,
            accountAccessibilityLabel: accountAccessibilityLabel ?? identity.accountName,
            selectedAccessibilityValue: selectedAccessibilityValue,
            logo: logo,
            openSettings: openSettings,
            openAccount: openAccount
        )
    }

    public var body: some View {
        AVAppShellBrandHeaderScaffold {
            AVAppShellIconButton(
                systemName: "gearshape.fill",
                accessibilityLabel: settingsAccessibilityLabel,
                accessibilityValue: activeItem == .settings ? selectedAccessibilityValue : "",
                accessibilityIdentifier: "header.settings",
                isSelected: activeItem == .settings,
                fontSize: 15,
                action: openSettings
            )
        } logo: {
            logo
        } trailing: {
            AVAppShellIconButton(
                systemName: "person.crop.circle.fill",
                accessibilityLabel: accountAccessibilityLabel,
                accessibilityValue: activeItem == .account ? selectedAccessibilityValue : "",
                accessibilityIdentifier: "header.account",
                isSelected: activeItem == .account,
                fontSize: 16,
                action: openAccount
            )
        }
    }
}
