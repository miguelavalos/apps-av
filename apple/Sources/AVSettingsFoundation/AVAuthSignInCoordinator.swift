import AuthenticationServices
import Foundation
import SwiftUI

@MainActor
public final class AVAuthSignInCoordinator: ObservableObject {
    @Published public private(set) var activeProvider: AVAuthProvider?
    @Published public var errorMessage = ""
    @Published public var isShowingError = false

    private var signInTask: Task<Void, Never>?

    public init() {}

    public var isBusy: Bool {
        activeProvider != nil
    }

    public func start(
        provider: AVAuthProvider,
        isAvailable: Bool,
        unavailableMessage: @autoclosure () -> String,
        operation: @escaping () async throws -> Void,
        onSuccess: @escaping @MainActor () -> Void = {},
        onFailure: @escaping @MainActor (Error, AVAuthProvider) -> Void = { _, _ in }
    ) {
        guard isAvailable else {
            errorMessage = unavailableMessage()
            isShowingError = true
            return
        }
        guard activeProvider == nil else { return }

        activeProvider = provider
        signInTask?.cancel()

        signInTask = Task {
            do {
                try await operation()
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    activeProvider = nil
                    signInTask = nil
                    onSuccess()
                }
            } catch {
                guard !Task.isCancelled else { return }
                guard !error.avAuthIsAuthenticationCancellation else {
                    await MainActor.run {
                        activeProvider = nil
                        signInTask = nil
                    }
                    return
                }

                await MainActor.run {
                    onFailure(error, provider)
                    activeProvider = nil
                    signInTask = nil
                    errorMessage = error.localizedDescription
                    isShowingError = true
                }
            }
        }
    }

    public func cancel() {
        signInTask?.cancel()
        signInTask = nil
        activeProvider = nil
    }
}

private extension Error {
    var avAuthIsAuthenticationCancellation: Bool {
        let nsError = self as NSError
        if nsError.domain == ASAuthorizationError.errorDomain,
           nsError.code == ASAuthorizationError.Code.canceled.rawValue {
            return true
        }

        if nsError.domain.contains("AuthenticationServices"),
           nsError.code == ASAuthorizationError.Code.unknown.rawValue {
            return true
        }

        if nsError.domain == ASWebAuthenticationSessionError.errorDomain,
           nsError.code == ASWebAuthenticationSessionError.Code.canceledLogin.rawValue {
            return true
        }

        if nsError.domain == NSURLErrorDomain,
           nsError.code == NSURLErrorCancelled {
            return true
        }

        let description = nsError.localizedDescription.lowercased()
        if description.contains("cancel") || description.contains("cancelad") {
            return true
        }

        if let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
            return underlying.avAuthIsAuthenticationCancellation
        }

        return false
    }
}
