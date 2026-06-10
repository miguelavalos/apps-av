import Foundation

public struct AVProductAccountUser: Codable, Equatable, Hashable, Identifiable, Sendable {
    public var id: String
    public var displayName: String
    public var emailAddress: String?

    public init(
        id: String,
        displayName: String,
        emailAddress: String? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.emailAddress = emailAddress
    }
}
