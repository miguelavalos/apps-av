import SwiftUI

public enum AVAviActionReaction: Equatable {
    case positive
    case negative
    case selection
    case clear
    case save
}

public extension View {
    func avAviActionReaction(_ reaction: AVAviActionReaction, trigger: Int) -> some View {
        modifier(AVAviActionReactionEffect(reaction: reaction, trigger: trigger))
    }
}

private struct AVAviActionReactionEffect: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let reaction: AVAviActionReaction
    let trigger: Int

    func body(content: Content) -> some View {
        content
            .phaseAnimator(AVAviActionReactionPhase.allCases, trigger: trigger) { animatedContent, phase in
                let values = reduceMotion ? .identity : reaction.values(for: phase)

                animatedContent
                    .scaleEffect(values.scale)
                    .rotationEffect(values.angle)
                    .offset(y: values.verticalOffset)
            } animation: { phase in
                reduceMotion ? nil : phase.animation
            }
            .sensoryFeedback(reaction.sensoryFeedback, trigger: trigger)
    }
}

private enum AVAviActionReactionPhase: CaseIterable {
    case resting
    case active
    case settle

    var animation: Animation {
        switch self {
        case .resting:
            return .smooth(duration: 0.08)
        case .active:
            return .snappy(duration: 0.16, extraBounce: 0.22)
        case .settle:
            return .smooth(duration: 0.14)
        }
    }
}

private struct AVAviActionReactionValues {
    static let identity = AVAviActionReactionValues()

    var scale = 1.0
    var verticalOffset = 0.0
    var angle = Angle.zero
}

private extension AVAviActionReaction {
    var sensoryFeedback: SensoryFeedback {
        switch self {
        case .positive, .save:
            return .success
        case .negative:
            return .warning
        case .selection, .clear:
            return .selection
        }
    }

    func values(for phase: AVAviActionReactionPhase) -> AVAviActionReactionValues {
        switch (self, phase) {
        case (_, .resting), (_, .settle):
            return .identity
        case (.positive, .active), (.save, .active):
            return AVAviActionReactionValues(scale: 1.18, verticalOffset: -2, angle: .degrees(-7))
        case (.negative, .active):
            return AVAviActionReactionValues(scale: 1.1, verticalOffset: 1, angle: .degrees(8))
        case (.selection, .active):
            return AVAviActionReactionValues(scale: 1.07)
        case (.clear, .active):
            return AVAviActionReactionValues(scale: 0.9, angle: .degrees(10))
        }
    }
}
