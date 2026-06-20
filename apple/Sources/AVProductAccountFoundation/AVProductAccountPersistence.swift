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

public struct AVUserDefaultsProductAccountPersistence: AVProductAccountPersistence, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let key: String

    public init(userDefaults: UserDefaults = .standard, key: String) {
        self.userDefaults = userDefaults
        self.key = key
    }

    public func loadLastKnownUser() async -> AVProductAccountUser? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(AVProductAccountUser.self, from: data)
    }

    public func saveLastKnownUser(_ user: AVProductAccountUser) async throws {
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: key)
    }

    public func clearLastKnownUser() async throws {
        userDefaults.removeObject(forKey: key)
    }
}
