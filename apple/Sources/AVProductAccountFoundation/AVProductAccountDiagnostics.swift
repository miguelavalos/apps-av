import Foundation

public enum AVProductAccountDiagnosticEvent: Equatable, Sendable {
    case restoreStarted
    case providerSessionActive
    case providerSignedOut
    case providerSessionUnavailable
    case providerTokenUnavailable
    case productUserResolutionStarted
    case productUserResolutionSucceeded(userID: String)
    case productUserResolutionTemporarilyUnavailable
    case lastKnownUserRestored(userID: String)
    case manualLogoutStarted
    case manualLogoutCompleted
}

public protocol AVProductAccountDiagnostics: Sendable {
    func recordAccountEvent(_ event: AVProductAccountDiagnosticEvent) async
}

public struct AVNoopProductAccountDiagnostics: AVProductAccountDiagnostics {
    public init() {}

    public func recordAccountEvent(_ event: AVProductAccountDiagnosticEvent) async {
        _ = event
    }
}
