import Foundation

public struct AVProductAccountManualLogoutHooks: Sendable {
    private let runHook: @Sendable () async throws -> Void

    public init(_ runHook: @escaping @Sendable () async throws -> Void = {}) {
        self.runHook = runHook
    }

    public func run() async throws {
        try await runHook()
    }
}

public actor AVProductAccountSessionController<
    Provider: AVProductAccountProviderSessioning,
    Resolver: AVProductAccountResolving,
    Persistence: AVProductAccountPersistence,
    Diagnostics: AVProductAccountDiagnostics
> {
    private let configuration: AVProductAccountConfiguration
    private let provider: Provider
    private let resolver: Resolver
    private let persistence: Persistence
    private let diagnostics: Diagnostics
    private let manualLogoutHooks: AVProductAccountManualLogoutHooks

    private var currentState: AVProductAccountState

    public init(
        configuration: AVProductAccountConfiguration,
        provider: Provider,
        resolver: Resolver,
        persistence: Persistence,
        diagnostics: Diagnostics = AVNoopProductAccountDiagnostics(),
        manualLogoutHooks: AVProductAccountManualLogoutHooks = AVProductAccountManualLogoutHooks()
    ) {
        self.configuration = configuration
        self.provider = provider
        self.resolver = resolver
        self.persistence = persistence
        self.diagnostics = diagnostics
        self.manualLogoutHooks = manualLogoutHooks
        self.currentState = .restoring(lastKnownUser: nil)
    }

    public var state: AVProductAccountState {
        currentState
    }

    @discardableResult
    public func restore() async -> AVProductAccountState {
        let lastKnownUser = await persistence.loadLastKnownUser()
        currentState = .initial(lastKnownUser: lastKnownUser)
        await diagnostics.recordAccountEvent(.restoreStarted)

        switch await provider.restoreProviderSession() {
        case .active:
            await diagnostics.recordAccountEvent(.providerSessionActive)
            return await resolveActiveProvider(lastKnownUser: lastKnownUser)
        case .temporarilyUnavailable:
            await diagnostics.recordAccountEvent(.providerSessionUnavailable)
            return await markTemporarilyUnavailable(lastKnownUser: lastKnownUser)
        case .signedOut:
            await diagnostics.recordAccountEvent(.providerSignedOut)
            currentState = currentState.signedOutByProvider()
            return currentState
        case .invalidated:
            await diagnostics.recordAccountEvent(.providerSignedOut)
            currentState = currentState.signedOutByProvider()
            return currentState
        }
    }

    @discardableResult
    public func refreshFromActiveProvider() async -> AVProductAccountState {
        await resolveActiveProvider(lastKnownUser: currentState.user)
    }

    @discardableResult
    public func signOutManually() async throws -> AVProductAccountState {
        await diagnostics.recordAccountEvent(.manualLogoutStarted)
        try await provider.signOutProvider()
        try await persistence.clearLastKnownUser()
        try await manualLogoutHooks.run()
        currentState = .manualLogout
        await diagnostics.recordAccountEvent(.manualLogoutCompleted)
        return currentState
    }

    private func resolveActiveProvider(lastKnownUser: AVProductAccountUser?) async -> AVProductAccountState {
        let token: String?

        do {
            token = try await provider.getProviderToken()
        } catch {
            await diagnostics.recordAccountEvent(.providerTokenUnavailable)
            return await markTemporarilyUnavailable(lastKnownUser: lastKnownUser)
        }

        guard let token, !token.isEmpty else {
            await diagnostics.recordAccountEvent(.providerTokenUnavailable)
            return await markTemporarilyUnavailable(lastKnownUser: lastKnownUser)
        }

        await diagnostics.recordAccountEvent(.productUserResolutionStarted)

        do {
            let user = try await resolver.resolveProductAccount(
                providerToken: token,
                configuration: configuration
            )
            try? await persistence.saveLastKnownUser(user)
            currentState = currentState.resolved(user: user)
            await diagnostics.recordAccountEvent(.productUserResolutionSucceeded(userID: user.id))
            return currentState
        } catch {
            await diagnostics.recordAccountEvent(.productUserResolutionTemporarilyUnavailable)
            return await markTemporarilyUnavailable(lastKnownUser: lastKnownUser)
        }
    }

    private func markTemporarilyUnavailable(lastKnownUser: AVProductAccountUser?) async -> AVProductAccountState {
        if let lastKnownUser {
            await diagnostics.recordAccountEvent(.lastKnownUserRestored(userID: lastKnownUser.id))
            currentState = .temporarilyUnavailable(AVProductAccountSession(
                user: lastKnownUser,
                isTemporarilyUnavailable: true
            ))
            return currentState
        }

        currentState = currentState.temporarilyUnavailable()
        return currentState
    }
}
