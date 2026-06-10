@testable import AVProductAccountFoundation
import Testing

@Suite("AVProductAccountState")
struct AVProductAccountStateTests {
    @Test("Initial state keeps the last-known internal user while restoring")
    func initialStateKeepsLastKnownUser() {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")

        let state = AVProductAccountState.initial(lastKnownUser: user)

        #expect(state == .restoring(lastKnownUser: user))
        #expect(state.user == user)
        #expect(state.isSignedIn)
    }

    @Test("Resolved state publishes the internal product user")
    func resolvedStatePublishesProductUser() {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")

        let state = AVProductAccountState.guest.resolved(user: user)

        #expect(state == .signedIn(AVProductAccountSession(user: user)))
        #expect(state.user == user)
        #expect(state.isSignedIn)
        #expect(!state.isTemporarilyUnavailable)
    }

    @Test("Temporary unavailable state preserves a last-known user")
    func temporaryUnavailablePreservesLastKnownUser() {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let state = AVProductAccountState.signedIn(AVProductAccountSession(user: user))

        let next = state.temporarilyUnavailable()

        #expect(next.user == user)
        #expect(next.isSignedIn)
        #expect(next.isTemporarilyUnavailable)
    }

    @Test("Provider signed-out uncertainty preserves a last-known user")
    func providerSignedOutWithLastKnownUserIsTemporary() {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")
        let state = AVProductAccountState.restoring(lastKnownUser: user)

        let next = state.signedOutByProvider()

        #expect(next.user == user)
        #expect(next.isSignedIn)
        #expect(next.isTemporarilyUnavailable)
    }

    @Test("Provider signed-out without a last-known user becomes guest")
    func providerSignedOutWithoutLastKnownUserBecomesGuest() {
        let state = AVProductAccountState.restoring(lastKnownUser: nil)

        let next = state.signedOutByProvider()

        #expect(next == .guest)
        #expect(!next.isSignedIn)
    }

    @Test("Manual logout clears local signed-in state")
    func manualLogoutClearsState() {
        let state = AVProductAccountState.manualLogout

        #expect(state == .guest)
        #expect(state.user == nil)
        #expect(!state.isSignedIn)
    }
}
