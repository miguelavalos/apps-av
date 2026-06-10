import Foundation

public protocol AVProductAccountPersistence: Sendable {
    func loadLastKnownUser() async -> AVProductAccountUser?
    func saveLastKnownUser(_ user: AVProductAccountUser) async throws
    func clearLastKnownUser() async throws
}

public actor AVInMemoryProductAccountPersistence: AVProductAccountPersistence {
    private var storedUser: AVProductAccountUser?

    public init(storedUser: AVProductAccountUser? = nil) {
        self.storedUser = storedUser
    }

    public func loadLastKnownUser() async -> AVProductAccountUser? {
        storedUser
    }

    public func saveLastKnownUser(_ user: AVProductAccountUser) async throws {
        storedUser = user
    }

    public func clearLastKnownUser() async throws {
        storedUser = nil
    }
}
