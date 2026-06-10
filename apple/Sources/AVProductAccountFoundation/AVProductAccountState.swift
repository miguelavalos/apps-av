import Foundation

public enum AVProductAccountState: Equatable, Sendable {
    case restoring(lastKnownUser: AVProductAccountUser?)
    case guest
    case signedIn(AVProductAccountSession)
    case temporarilyUnavailable(AVProductAccountSession)

    public var user: AVProductAccountUser? {
        switch self {
        case .restoring(let lastKnownUser):
            lastKnownUser
        case .guest:
            nil
        case .signedIn(let session), .temporarilyUnavailable(let session):
            session.user
        }
    }

    public var isSignedIn: Bool {
        user != nil
    }

    public var isTemporarilyUnavailable: Bool {
        if case .temporarilyUnavailable = self {
            return true
        }
        return false
    }

    public static func initial(lastKnownUser: AVProductAccountUser?) -> AVProductAccountState {
        .restoring(lastKnownUser: lastKnownUser)
    }

    public func resolved(user: AVProductAccountUser) -> AVProductAccountState {
        .signedIn(AVProductAccountSession(user: user))
    }

    public func temporarilyUnavailable() -> AVProductAccountState {
        guard let user else { return .guest }
        return .temporarilyUnavailable(AVProductAccountSession(
            user: user,
            isTemporarilyUnavailable: true
        ))
    }

    public func signedOutByProvider() -> AVProductAccountState {
        guard let user else { return .guest }
        return .temporarilyUnavailable(AVProductAccountSession(
            user: user,
            isTemporarilyUnavailable: true
        ))
    }

    public static var manualLogout: AVProductAccountState {
        .guest
    }
}
