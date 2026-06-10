@testable import AVProductAccountFoundation
import Testing

private actor StubProvider: AVProductAccountProviderSessioning {
    var restoreResult: AVProductAccountProviderRestoreResult
    var tokenResult: Result<String?, Error>
    private(set) var didSignOut = false

    init(
        restoreResult: AVProductAccountProviderRestoreResult,
        tokenResult: Result<String?, Error> = .success("provider-token")
    ) {
        self.restoreResult = restoreResult
        self.tokenResult = tokenResult
    }

    func restoreProviderSession() async -> AVProductAccountProviderRestoreResult {
        restoreResult
    }

    func getProviderToken() async throws -> String? {
        try tokenResult.get()
    }

    func signOutProvider() async throws {
        didSignOut = true
    }
}

private actor StubResolver: AVProductAccountResolving {
    var result: Result<AVProductAccountUser, Error>
    private(set) var receivedTokens: [String] = []

    init(result: Result<AVProductAccountUser, Error>) {
        self.result = result
    }

    func resolveProductAccount(
        providerToken: String,
        configuration: AVProductAccountConfiguration
    ) async throws -> AVProductAccountUser {
        _ = configuration
        receivedTokens.append(providerToken)
        return try result.get()
    }
}

private actor SpyDiagnostics: AVProductAccountDiagnostics {
    private(set) var events: [AVProductAccountDiagnosticEvent] = []

    func recordAccountEvent(_ event: AVProductAccountDiagnosticEvent) {
        events.append(event)
    }
}

private actor LogoutSpy {
    private(set) var didRun = false

    func run() {
        didRun = true
    }
}

private enum StubAccountError: Error {
    case temporary
}

@Suite("AVProductAccountSessionController")
struct AVProductAccountSessionControllerTests {
    private let configuration = AVProductAccountConfiguration(
        appIdentifier: "test-av",
        appDisplayName: "Test AV"
    )

    @Test("Initial restore resolves active provider through /v1/me and caches internal user")
    func restoreActiveProviderResolvesAndCachesInternalUser() async {
        let resolvedUser = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let provider = StubProvider(restoreResult: .active)
        let resolver = StubResolver(result: .success(resolvedUser))
        let persistence = AVInMemoryProductAccountPersistence()
        let diagnostics = SpyDiagnostics()
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence,
            diagnostics: diagnostics
        )

        let state = await controller.restore()
        let cachedUser = await persistence.loadLastKnownUser()
        let tokens = await resolver.receivedTokens

        #expect(state == .signedIn(AVProductAccountSession(user: resolvedUser)))
        #expect(cachedUser == resolvedUser)
        #expect(tokens == ["provider-token"])
        #expect(await diagnostics.events == [
            .restoreStarted,
            .providerSessionActive,
            .productUserResolutionStarted,
            .productUserResolutionSucceeded(userID: resolvedUser.id)
        ])
    }

    @Test("Temporary provider unavailability keeps last-known user signed in")
    func restoreTemporaryProviderUnavailableKeepsLastKnownUser() async {
        let lastKnownUser = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let provider = StubProvider(restoreResult: .temporarilyUnavailable)
        let resolver = StubResolver(result: .failure(StubAccountError.temporary))
        let persistence = AVInMemoryProductAccountPersistence(storedUser: lastKnownUser)
        let diagnostics = SpyDiagnostics()
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence,
            diagnostics: diagnostics
        )

        let state = await controller.restore()

        #expect(state.user == lastKnownUser)
        #expect(state.isSignedIn)
        #expect(state.isTemporarilyUnavailable)
        #expect(await diagnostics.events == [
            .restoreStarted,
            .providerSessionUnavailable,
            .lastKnownUserRestored(userID: lastKnownUser.id)
        ])
    }

    @Test("Temporary /v1/me failure keeps last-known user signed in")
    func restoreMeFailureKeepsLastKnownUser() async {
        let lastKnownUser = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let provider = StubProvider(restoreResult: .active)
        let resolver = StubResolver(result: .failure(StubAccountError.temporary))
        let persistence = AVInMemoryProductAccountPersistence(storedUser: lastKnownUser)
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence
        )

        let state = await controller.restore()

        #expect(state.user == lastKnownUser)
        #expect(state.isSignedIn)
        #expect(state.isTemporarilyUnavailable)
    }

    @Test("Provider signed out with last-known user does not log out locally")
    func providerSignedOutWithLastKnownUserDoesNotLogout() async {
        let lastKnownUser = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let provider = StubProvider(restoreResult: .signedOut)
        let resolver = StubResolver(result: .failure(StubAccountError.temporary))
        let persistence = AVInMemoryProductAccountPersistence(storedUser: lastKnownUser)
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence
        )

        let state = await controller.restore()

        #expect(state.user == lastKnownUser)
        #expect(state.isSignedIn)
        #expect(state.isTemporarilyUnavailable)
    }

    @Test("Provider signed out without last-known user becomes guest")
    func providerSignedOutWithoutLastKnownUserBecomesGuest() async {
        let provider = StubProvider(restoreResult: .signedOut)
        let resolver = StubResolver(result: .failure(StubAccountError.temporary))
        let persistence = AVInMemoryProductAccountPersistence()
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence
        )

        let state = await controller.restore()

        #expect(state == .guest)
    }

    @Test("Manual logout clears provider, cache, state, and app hooks")
    func manualLogoutClearsProviderCacheStateAndHooks() async throws {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let provider = StubProvider(restoreResult: .active)
        let resolver = StubResolver(result: .success(user))
        let persistence = AVInMemoryProductAccountPersistence(storedUser: user)
        let logoutSpy = LogoutSpy()
        let hooks = AVProductAccountManualLogoutHooks {
            await logoutSpy.run()
        }
        let controller = AVProductAccountSessionController(
            configuration: configuration,
            provider: provider,
            resolver: resolver,
            persistence: persistence,
            manualLogoutHooks: hooks
        )

        let state = try await controller.signOutManually()
        let cachedUser = await persistence.loadLastKnownUser()
        let didSignOut = await provider.didSignOut
        let didRunHook = await logoutSpy.didRun

        #expect(state == .guest)
        #expect(cachedUser == nil)
        #expect(didSignOut)
        #expect(didRunHook)
    }
}
