import AVBrandFoundation
import SwiftUI

public struct AVAviHomeBriefCard<Avatar: View>: View {
    private let identity: AVAppIdentity
    private let detail: String
    private let actionAccessibilityLabel: String
    private let accessibilityIdentifier: String
    private let openAvi: () -> Void
    private let avatar: Avatar

    public init(
        identity: AVAppIdentity,
        detail: String,
        actionAccessibilityLabel: String,
        accessibilityIdentifier: String,
        openAvi: @escaping () -> Void,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.identity = identity
        self.detail = detail
        self.actionAccessibilityLabel = actionAccessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.openAvi = openAvi
        self.avatar = avatar()
    }

    public var body: some View {
        AVAviCompanionCard(
            identity: identity,
            detail: detail,
            actionAccessibilityLabel: actionAccessibilityLabel,
            accessibilityIdentifier: accessibilityIdentifier,
            action: openAvi
        ) {
            avatar
        }
    }
}
