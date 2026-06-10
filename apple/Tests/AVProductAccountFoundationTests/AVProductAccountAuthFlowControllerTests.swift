@testable import AVProductAccountFoundation
import Foundation
import Testing

private actor StubAuthProvider: AVProductAccountAuthProviding {
    var appleResult: Result<Void, Error> = .success(())
    var googleResult: Result<Void, Error> = .success(())
    var signOutResult: Result<Void, Error> = .success(())
    var shouldBlockApple = false
    private var appleContinuation: CheckedContinuation<Void, Never>?

    private(set) var appleCallCount = 0
    private(set) var googleCallCount = 0
    private(set) var signOutCallCount = 0

    func continueWithApple() async throws {
        appleCallCount += 1
        if shouldBlockApple {
            await withCheckedContinuation { continuation in
                appleContinuation = continuation
            }
        }
        try appleResult.get()
    }

    func continueWithGoogle() async throws {
        googleCallCount += 1
        try googleResult.get()
    }

    func signOutManually() async throws {
        signOutCallCount += 1
        try signOutResult.get()
    }

    func blockAppleUntilResumed() {
        shouldBlockApple = true
    }

    func resumeApple() {
        shouldBlockApple = false
        appleContinuation?.resume()
        appleContinuation = nil
    }
}

private enum StubAuthError: LocalizedError {
    case failed

    var errorDescription: String? {
        "Sign-in failed"
    }
}

@Suite("AVProductAccountAuthFlowController")
struct AVProductAccountAuthFlowControllerTests {
    @Test("Sign-in button opens collapsed auth presenter")
    func signInButtonOpensCollapsedPresenter() async {
        let authProvider = StubAuthProvider()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.presentSignIn(optionsExpanded: false)

        #expect(state == .onboardingCollapsed)
        #expect(state.isPresented)
        #expect(!state.optionsAreExpanded)
    }

    @Test("Indirect sign-in entrypoint opens expanded auth presenter")
    func indirectEntrypointOpensExpandedPresenter() async {
        let authProvider = StubAuthProvider()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.presentSignIn(optionsExpanded: true)

        #expect(state == .onboardingOptions)
        #expect(state.optionsAreExpanded)
    }

    @Test("Double tap while provider is busy is ignored")
    func doubleTapWhileBusyIsIgnored() async {
        let authProvider = StubAuthProvider()
        await authProvider.blockAppleUntilResumed()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        async let firstState = controller.continueWithApple()
        while await controller.presentationState.activeProvider == nil {
            await Task.yield()
        }
        let secondState = await controller.continueWithGoogle()
        await authProvider.resumeApple()
        let finalFirstState = await firstState
        let appleCalls = await authProvider.appleCallCount
        let googleCalls = await authProvider.googleCallCount

        #expect(secondState == .busy(.provider(.apple)))
        #expect(finalFirstState == .hidden)
        #expect(appleCalls == 1)
        #expect(googleCalls == 0)
    }

    @Test("Cancellation returns to expanded auth options without error")
    func cancellationReturnsToOptions() async {
        let authProvider = StubAuthProvider()
        await authProvider.setAppleResult(.failure(AVProductAccountAuthFlowCancellation.cancelled))
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.continueWithApple()

        #expect(state == .onboardingOptions)
        #expect(await controller.outcome == nil)
    }

    @Test("Provider error enters error state with expanded options")
    func providerErrorShowsError() async {
        let authProvider = StubAuthProvider()
        await authProvider.setGoogleResult(.failure(StubAuthError.failed))
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.continueWithGoogle()

        #expect(state == .error(message: "Sign-in failed", optionsExpanded: true))
    }

    @Test("Successful provider sign-in hides presenter and records outcome")
    func successfulProviderSignInHidesPresenter() async {
        let authProvider = StubAuthProvider()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.continueWithApple()

        #expect(state == .hidden)
        #expect(await controller.outcome == .signedIn(provider: .apple))
    }

    @Test("Skip for now hides presenter and records outcome")
    func skipForNowHidesPresenter() async {
        let authProvider = StubAuthProvider()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.skipForNow()

        #expect(state == .hidden)
        #expect(await controller.outcome == .skipped)
    }

    @Test("Manual sign out delegates to provider and hides presenter")
    func manualSignOutDelegatesAndHidesPresenter() async {
        let authProvider = StubAuthProvider()
        let controller = AVProductAccountAuthFlowController(authProvider: authProvider)

        let state = await controller.signOutManually()

        #expect(state == .hidden)
        #expect(await authProvider.signOutCallCount == 1)
        #expect(await controller.outcome == .signedOut)
    }

    @Test("Root gate shows splash, onboarding, or shell")
    func rootGateStates() {
        let user = AVProductAccountUser(id: "apps-av-user-id", displayName: "Apps AV User")

        let splashGate = AVProductAccountAuthFlowRootGate(
            accountState: .restoring(lastKnownUser: user),
            authPresentationState: .hidden
        )
        let onboardingGate = AVProductAccountAuthFlowRootGate(
            accountState: .guest,
            authPresentationState: .onboardingCollapsed
        )
        let shellGate = AVProductAccountAuthFlowRootGate(
            accountState: .signedIn(AVProductAccountSession(user: user)),
            authPresentationState: .hidden
        )

        #expect(splashGate.shouldShowSplash)
        #expect(onboardingGate.shouldShowOnboarding)
        #expect(shellGate.shouldShowShell)
    }
}

private extension StubAuthProvider {
    func setAppleResult(_ result: Result<Void, Error>) {
        appleResult = result
    }

    func setGoogleResult(_ result: Result<Void, Error>) {
        googleResult = result
    }
}
