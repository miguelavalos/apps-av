import Foundation

public struct AVProductAccountConfiguration: Equatable, Sendable {
    public var appIdentifier: String
    public var appDisplayName: String
    public var allowsGuestMode: Bool

    public init(
        appIdentifier: String,
        appDisplayName: String,
        allowsGuestMode: Bool = false
    ) {
        self.appIdentifier = appIdentifier
        self.appDisplayName = appDisplayName
        self.allowsGuestMode = allowsGuestMode
    }
}
