import Foundation

public struct AVProductAccountSession: Equatable, Sendable {
    public var user: AVProductAccountUser
    public var isTemporarilyUnavailable: Bool

    public init(
        user: AVProductAccountUser,
        isTemporarilyUnavailable: Bool = false
    ) {
        self.user = user
        self.isTemporarilyUnavailable = isTemporarilyUnavailable
    }
}
