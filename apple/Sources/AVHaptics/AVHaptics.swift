import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public enum AVHapticEvent: Sendable {
    case selection
    case impactLight
    case navigation
    case modeChange
    case openPanel
    case closePanel
    case primaryAction
    case secondaryAction
    case step
    case stopAction
    @available(*, deprecated, renamed: "primaryAction", message: "Use app-generic haptic events in Apps AV.")
    case playbackToggle
    @available(*, deprecated, renamed: "step", message: "Use app-generic haptic events in Apps AV.")
    case queueStep
    case loadMore
    @available(*, deprecated, renamed: "stopAction", message: "Use app-generic haptic events in Apps AV.")
    case stopPlayback
    case affirm
    case undo
    case positiveFeedback
    case negativeFeedback
    case dismissiveFeedback
    @available(*, deprecated, renamed: "affirm", message: "Use app-generic haptic events in Apps AV.")
    case save
    @available(*, deprecated, renamed: "undo", message: "Use app-generic haptic events in Apps AV.")
    case unsave
    @available(*, deprecated, renamed: "positiveFeedback", message: "Use app-generic haptic events in Apps AV.")
    case like
    @available(*, deprecated, renamed: "negativeFeedback", message: "Use app-generic haptic events in Apps AV.")
    case dislike
    @available(*, deprecated, renamed: "dismissiveFeedback", message: "Use app-generic haptic events in Apps AV.")
    case notForMe
    case clear
    case warning
    case blocked
}

@MainActor
public enum AVHaptics {
    public static func perform(_ event: AVHapticEvent) {
        #if os(iOS)
        performIOS(event)
        #elseif os(macOS)
        performMacOS(event)
        #else
        _ = event
        #endif
    }
}

#if os(iOS)
@MainActor
private extension AVHaptics {
    static func performIOS(_ event: AVHapticEvent) {
        switch event {
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .dismissiveFeedback, .notForMe, .clear:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case .impactLight, .primaryAction, .secondaryAction, .step, .loadMore, .stopAction, .undo, .playbackToggle, .queueStep, .stopPlayback, .unsave:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        case .affirm, .positiveFeedback, .save, .like:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .negativeFeedback, .dislike, .warning, .blocked:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.warning)
        }
    }
}
#endif

#if os(macOS)
@MainActor
private extension AVHaptics {
    static func performMacOS(_ event: AVHapticEvent) {
        switch event {
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .dismissiveFeedback, .notForMe, .clear:
            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        case .impactLight, .primaryAction, .secondaryAction, .step, .loadMore, .stopAction, .affirm, .undo, .positiveFeedback, .negativeFeedback, .playbackToggle, .queueStep, .stopPlayback, .save, .unsave, .like, .dislike, .warning, .blocked:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        }
    }
}
#endif
