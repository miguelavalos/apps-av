import Foundation

public enum AVProductAccountProviderRestoreResult: Equatable, Sendable {
    case signedOut
    case active
    case temporarilyUnavailable
    case invalidated
}

public protocol AVProductAccountProviderSessioning: Sendable {
    func restoreProviderSession() async -> AVProductAccountProviderRestoreResult
    func getProviderToken() async throws -> String?
    func signOutProvider() async throws
}
