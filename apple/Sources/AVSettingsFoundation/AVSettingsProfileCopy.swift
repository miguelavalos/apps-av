import AVBrandFoundation

public enum AVSettingsProfileSurface: Hashable, Sendable {
    case settings
    case account
}

public struct AVSettingsProfileCopy: Hashable, Sendable {
    public var settingsTitle: String
    public var settingsSubtitle: String
    public var accountTitle: String
    public var accountSubtitle: String

    public init(
        settingsTitle: String,
        settingsSubtitle: String,
        accountTitle: String,
        accountSubtitle: String
    ) {
        self.settingsTitle = settingsTitle
        self.settingsSubtitle = settingsSubtitle
        self.accountTitle = accountTitle
        self.accountSubtitle = accountSubtitle
    }

    public init(
        identity: AVAppIdentity,
        settingsTitle: String = "Settings",
        accountTitle: String = "My account",
        settingsDetail: String = "credits, project privacy, and support links",
        accountDetail: String = "sign-in, account identity, credits, and account safety"
    ) {
        self.init(
            settingsTitle: settingsTitle,
            settingsSubtitle: "Manage \(identity.shortName), \(settingsDetail).",
            accountTitle: accountTitle,
            accountSubtitle: "Manage \(accountDetail)."
        )
    }

    public func title(for surface: AVSettingsProfileSurface) -> String {
        switch surface {
        case .settings:
            settingsTitle
        case .account:
            accountTitle
        }
    }

    public func subtitle(for surface: AVSettingsProfileSurface) -> String {
        switch surface {
        case .settings:
            settingsSubtitle
        case .account:
            accountSubtitle
        }
    }
}
