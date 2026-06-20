@testable import AVProductAccountFoundation
import Foundation
import Testing

@Suite("AVProductAccountPersistence")
struct AVProductAccountPersistenceTests {
    @Test("In-memory persistence loads empty by default")
    func loadsEmptyByDefault() async {
        let persistence = AVInMemoryProductAccountPersistence()

        let user = await persistence.loadLastKnownUser()

        #expect(user == nil)
    }

    @Test("In-memory persistence saves and loads the internal product user")
    func savesAndLoadsProductUser() async throws {
        let expected = AVProductAccountUser(
            id: "apps-av-user-id",
            displayName: "Apps AV User",
            emailAddress: "user@example.com"
        )
        let persistence = AVInMemoryProductAccountPersistence()

        try await persistence.saveLastKnownUser(expected)
        let loaded = await persistence.loadLastKnownUser()

        #expect(loaded == expected)
    }

    @Test("In-memory persistence clears the last-known user")
    func clearsLastKnownUser() async throws {
        let persistence = AVInMemoryProductAccountPersistence(
            storedUser: AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        )

        try await persistence.clearLastKnownUser()
        let loaded = await persistence.loadLastKnownUser()

        #expect(loaded == nil)
    }

    @Test("UserDefaults persistence saves and loads the internal product user")
    func userDefaultsPersistenceSavesAndLoadsProductUser() async throws {
        let key = "test.productAccount.lastKnownUser"
        let suiteName = "AVProductAccountPersistenceTests.\(UUID().uuidString)"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let expected = AVProductAccountUser(
            id: "apps-av-user-id",
            displayName: "Apps AV User",
            emailAddress: "user@example.com"
        )
        let persistence = AVUserDefaultsProductAccountPersistence(userDefaults: userDefaults, key: key)

        try await persistence.saveLastKnownUser(expected)
        let loaded = await persistence.loadLastKnownUser()

        #expect(loaded == expected)
    }

    @Test("UserDefaults persistence clears the last-known user")
    func userDefaultsPersistenceClearsLastKnownUser() async throws {
        let key = "test.productAccount.lastKnownUser"
        let suiteName = "AVProductAccountPersistenceTests.\(UUID().uuidString)"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let persistence = AVUserDefaultsProductAccountPersistence(userDefaults: userDefaults, key: key)
        try await persistence.saveLastKnownUser(AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User"))

        try await persistence.clearLastKnownUser()
        let loaded = await persistence.loadLastKnownUser()

        #expect(loaded == nil)
    }
}
