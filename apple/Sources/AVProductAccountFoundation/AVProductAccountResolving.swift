import Foundation

public protocol AVProductAccountResolving: Sendable {
    func resolveProductAccount(
        providerToken: String,
        configuration: AVProductAccountConfiguration
    ) async throws -> AVProductAccountUser
}

public protocol AVProductAccessResolving: Sendable {
    associatedtype AccessState: Sendable

    func resolveAccess(
        for user: AVProductAccountUser,
        configuration: AVProductAccountConfiguration
    ) async throws -> AccessState
}
