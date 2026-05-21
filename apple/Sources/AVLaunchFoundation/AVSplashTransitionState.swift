import Foundation

public struct AVSplashTransitionState: Equatable {
    public private(set) var isShowing: Bool
    public private(set) var hasShownThisLaunch: Bool

    public init(
        isShowing: Bool = false,
        hasShownThisLaunch: Bool = false
    ) {
        self.isShowing = isShowing
        self.hasShownThisLaunch = hasShownThisLaunch
    }

    @discardableResult
    public mutating func beginIfNeeded(policy: AVSplashTransitionPolicy) -> Bool {
        guard !policy.isDisabled, !hasShownThisLaunch else {
            isShowing = false
            return false
        }

        hasShownThisLaunch = true
        isShowing = true
        return true
    }

    public mutating func dismiss() {
        isShowing = false
    }
}
