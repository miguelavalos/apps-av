import Foundation

public struct AVAppIdentity: Hashable, Sendable {
    public var displayName: String
    public var shortName: String
    public var assistantName: String
    public var accountName: String

    public init(
        displayName: String,
        shortName: String? = nil,
        assistantName: String = "Avi",
        accountName: String = "Apps AV"
    ) {
        self.displayName = displayName
        self.shortName = shortName ?? displayName
        self.assistantName = assistantName
        self.accountName = accountName
    }
}

public struct AVAppLegalLinks: Hashable, Sendable {
    public var supportURL: URL?
    public var privacyURL: URL?
    public var termsURL: URL?
    public var accountDeletionURL: URL?

    public init(
        supportURL: URL? = nil,
        privacyURL: URL? = nil,
        termsURL: URL? = nil,
        accountDeletionURL: URL? = nil
    ) {
        self.supportURL = supportURL
        self.privacyURL = privacyURL
        self.termsURL = termsURL
        self.accountDeletionURL = accountDeletionURL
    }
}
