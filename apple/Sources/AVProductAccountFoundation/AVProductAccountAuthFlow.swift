import Foundation

public enum AVProductAccountAuthProvider: Equatable, Sendable {
    case apple
    case google
}

public enum AVProductAccountAuthBusyOperation: Equatable, Sendable {
    case provider(AVProductAccountAuthProvider)
    case signOut
}

public enum AVProductAccountAuthPresentationState: Equatable, Sendable {
    case hidden
    case onboardingCollapsed
    case onboardingOptions
    case busy(AVProductAccountAuthBusyOperation)
    case error(message: String, optionsExpanded: Bool)

    public var isPresented: Bool {
        switch self {
        case .hidden:
            false
        case .onboardingCollapsed, .onboardingOptions, .busy, .error:
            true
        }
    }

    public var optionsAreExpanded: Bool {
        switch self {
        case .onboardingOptions, .busy, .error(_, true):
            true
        case .hidden, .onboardingCollapsed, .error(_, false):
            false
        }
    }

    public var busyOperation: AVProductAccountAuthBusyOperation? {
        if case .busy(let operation) = self {
            operation
        } else {
            nil
        }
    }

    public var activeProvider: AVProductAccountAuthProvider? {
        if case .busy(.provider(let provider)) = self {
            provider
        } else {
            nil
        }
    }
}

public protocol AVProductAccountAuthProviding: Sendable {
    func continueWithApple() async throws
    func continueWithGoogle() async throws
    func signOutManually() async throws
}

public enum AVProductAccountAuthFlowOutcome: Equatable, Sendable {
    case skipped
    case signedIn(provider: AVProductAccountAuthProvider)
    case signedOut
}

public enum AVProductAccountAuthFlowCancellation: Error, Sendable {
    case cancelled
}

public struct AVProductAccountAuthFlowRootGate: Equatable, Sendable {
    public var accountState: AVProductAccountState
    public var authPresentationState: AVProductAccountAuthPresentationState

    public init(
        accountState: AVProductAccountState,
        authPresentationState: AVProductAccountAuthPresentationState
    ) {
        self.accountState = accountState
        self.authPresentationState = authPresentationState
    }

    public var shouldShowSplash: Bool {
        if case .restoring = accountState {
            return true
        }
        return false
    }

    public var shouldShowOnboarding: Bool {
        !accountState.isSignedIn && authPresentationState.isPresented
    }

    public var shouldShowShell: Bool {
        !shouldShowSplash && !shouldShowOnboarding
    }
}

public actor AVProductAccountAuthFlowController<AuthProvider: AVProductAccountAuthProviding> {
    private let authProvider: AuthProvider
    private var presentationStateStorage: AVProductAccountAuthPresentationState
    private var outcomeStorage: AVProductAccountAuthFlowOutcome?

    public init(
        authProvider: AuthProvider,
        initialState: AVProductAccountAuthPresentationState = .hidden
    ) {
        self.authProvider = authProvider
        self.presentationStateStorage = initialState
    }

    public var presentationState: AVProductAccountAuthPresentationState {
        presentationStateStorage
    }

    public var outcome: AVProductAccountAuthFlowOutcome? {
        outcomeStorage
    }

    @discardableResult
    public func presentSignIn(optionsExpanded: Bool) -> AVProductAccountAuthPresentationState {
        guard presentationStateStorage.activeProvider == nil else {
            return presentationStateStorage
        }

        presentationStateStorage = optionsExpanded ? .onboardingOptions : .onboardingCollapsed
        return presentationStateStorage
    }

    @discardableResult
    public func skipForNow() -> AVProductAccountAuthPresentationState {
        guard presentationStateStorage.activeProvider == nil else {
            return presentationStateStorage
        }

        outcomeStorage = .skipped
        presentationStateStorage = .hidden
        return presentationStateStorage
    }

    @discardableResult
    public func continueWithApple() async -> AVProductAccountAuthPresentationState {
        await continueWithProvider(.apple)
    }

    @discardableResult
    public func continueWithGoogle() async -> AVProductAccountAuthPresentationState {
        await continueWithProvider(.google)
    }

    @discardableResult
    public func signOutManually() async -> AVProductAccountAuthPresentationState {
        guard presentationStateStorage.activeProvider == nil else {
            return presentationStateStorage
        }

        presentationStateStorage = .busy(.signOut)

        do {
            try await authProvider.signOutManually()
            outcomeStorage = .signedOut
            presentationStateStorage = .hidden
        } catch {
            presentationStateStorage = .error(message: error.localizedDescription, optionsExpanded: false)
        }

        return presentationStateStorage
    }

    @discardableResult
    public func cancel() -> AVProductAccountAuthPresentationState {
        guard presentationStateStorage.activeProvider == nil else {
            return presentationStateStorage
        }

        presentationStateStorage = .hidden
        return presentationStateStorage
    }

    private func continueWithProvider(
        _ provider: AVProductAccountAuthProvider
    ) async -> AVProductAccountAuthPresentationState {
        guard presentationStateStorage.activeProvider == nil else {
            return presentationStateStorage
        }

        presentationStateStorage = .busy(.provider(provider))

        do {
            switch provider {
            case .apple:
                try await authProvider.continueWithApple()
            case .google:
                try await authProvider.continueWithGoogle()
            }

            outcomeStorage = .signedIn(provider: provider)
            presentationStateStorage = .hidden
        } catch is AVProductAccountAuthFlowCancellation {
            presentationStateStorage = .onboardingOptions
        } catch {
            presentationStateStorage = .error(message: error.localizedDescription, optionsExpanded: true)
        }

        return presentationStateStorage
    }
}
