import Foundation

public enum AVProductAccountDiagnosticEvent: Equatable, Sendable {
    case restoreStarted
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
    func recordAccountEvent(_ event: AVProductAccountDiagnosticEvent)
}

public struct AVNoopProductAccountDiagnostics: AVProductAccountDiagnostics {
    public init() {}

    public func recordAccountEvent(_ event: AVProductAccountDiagnosticEvent) {
        _ = event
    }
}
