import Foundation
import SwiftUI

public struct AVSplashTransitionPolicy: Equatable {
    public let displayDuration: Duration
    public let dismissAnimationDuration: TimeInterval
    public let isDisabled: Bool

    public init(
        displayDuration: Duration = .milliseconds(1_650),
        dismissAnimationDuration: TimeInterval = 0.35,
        isDisabled: Bool = false
    ) {
        self.displayDuration = displayDuration
        self.dismissAnimationDuration = dismissAnimationDuration
        self.isDisabled = isDisabled
    }

    public var dismissAnimation: Animation {
        .easeOut(duration: dismissAnimationDuration)
    }
}
