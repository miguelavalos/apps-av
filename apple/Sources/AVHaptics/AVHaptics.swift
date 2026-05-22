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
    case loadMore
    case affirm
    case undo
    case positiveFeedback
    case negativeFeedback
    case dismissiveFeedback
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
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .dismissiveFeedback, .clear:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case .impactLight, .primaryAction, .secondaryAction, .step, .loadMore, .stopAction, .undo:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        case .affirm, .positiveFeedback:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .negativeFeedback, .warning, .blocked:
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
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .dismissiveFeedback, .clear:
            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        case .impactLight, .primaryAction, .secondaryAction, .step, .loadMore, .stopAction, .affirm, .undo, .positiveFeedback, .negativeFeedback, .warning, .blocked:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        }
    }
}
#endif
