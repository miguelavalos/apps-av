import SwiftUI

public struct AVAppShellFooterAssistantAssetIcon: View {
    private let assetName: String

    public init(assetName: String) {
        self.assetName = assetName
    }

    public var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
    }
}

public struct AVAppShellStandardScaffold<ID: Hashable, Content: View, FooterPlayer: View>: View {
    private let selectedTabID: ID
    private let tabs: [AVAppShellTab<ID>]
    private let assistantID: ID
    private let assistantName: String
    private let assistantAccessibilityIdentifier: String
    private let assistantAssetName: String
    private let hasAssistantActiveContext: Bool
    private let assistantActiveContextSystemImage: String
    private let footerConfiguration: AVAppShellFooterConfiguration
    private let onSelectTab: (ID) -> Void
    private let onSelectAssistant: () -> Void
    private let content: () -> Content
    private let footerPlayer: () -> FooterPlayer

    public init(
        selectedTabID: ID,
        tabs: [AVAppShellTab<ID>],
        assistantID: ID,
        assistantName: String,
        assistantAccessibilityIdentifier: String,
        assistantAssetName: String,
        hasAssistantActiveContext: Bool = false,
        assistantActiveContextSystemImage: String = "waveform",
        footerConfiguration: AVAppShellFooterConfiguration = .contentOnly,
        onSelectTab: @escaping (ID) -> Void,
        onSelectAssistant: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footerPlayer: @escaping () -> FooterPlayer
    ) {
        self.selectedTabID = selectedTabID
        self.tabs = tabs
        self.assistantID = assistantID
        self.assistantName = assistantName
        self.assistantAccessibilityIdentifier = assistantAccessibilityIdentifier
        self.assistantAssetName = assistantAssetName
        self.hasAssistantActiveContext = hasAssistantActiveContext
        self.assistantActiveContextSystemImage = assistantActiveContextSystemImage
        self.footerConfiguration = footerConfiguration
        self.onSelectTab = onSelectTab
        self.onSelectAssistant = onSelectAssistant
        self.content = content
        self.footerPlayer = footerPlayer
    }

    public var body: some View {
        AVAppShellScaffold(
            selectedTabID: selectedTabID,
            tabs: tabs,
            assistantID: assistantID,
            assistantAccessibilityLabel: assistantName,
            assistantAccessibilityIdentifier: assistantAccessibilityIdentifier,
            hasAssistantActiveContext: hasAssistantActiveContext,
            assistantActiveContextSystemImage: assistantActiveContextSystemImage,
            footerConfiguration: footerConfiguration,
            onSelectTab: onSelectTab,
            onSelectAssistant: onSelectAssistant,
            content: content,
            footerPlayer: footerPlayer
        ) { _ in
            AVAppShellFooterAssistantAssetIcon(assetName: assistantAssetName)
        }
    }
}
