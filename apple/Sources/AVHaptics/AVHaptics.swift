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
    case playbackToggle
    case queueStep
    case stopPlayback
    case save
    case unsave
    case like
    case dislike
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
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .notForMe, .clear:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        case .impactLight, .playbackToggle, .queueStep, .stopPlayback, .unsave:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
        case .save, .like:
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        case .dislike, .warning, .blocked:
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
        case .selection, .navigation, .modeChange, .openPanel, .closePanel, .notForMe, .clear:
            NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
        case .impactLight, .playbackToggle, .queueStep, .stopPlayback, .save, .unsave, .like, .dislike, .warning, .blocked:
            NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .default)
        }
    }
}
#endif
