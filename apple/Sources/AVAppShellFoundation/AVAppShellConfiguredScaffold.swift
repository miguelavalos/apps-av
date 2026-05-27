import SwiftUI

public struct AVAppShellConfiguredAssistant: Sendable {
    public var id: String
    public var name: String
    public var accessibilityIdentifier: String
    public var assetName: String
    public var activeContextSystemImage: String

    public init(
        id: String = "avi",
        name: String,
        accessibilityIdentifier: String,
        assetName: String,
        activeContextSystemImage: String = "waveform"
    ) {
        self.id = id
        self.name = name
        self.accessibilityIdentifier = accessibilityIdentifier
        self.assetName = assetName
        self.activeContextSystemImage = activeContextSystemImage
    }
}

public struct AVAppShellConfiguredScaffold<ID: Hashable, Content: View, FooterPlayer: View>: View {
    private let selectedTabID: ID
    private let tabs: [AVAppShellTab<ID>]
    private let assistantID: ID
    private let assistant: AVAppShellConfiguredAssistant
    private let hasAssistantActiveContext: Bool
    private let footerConfiguration: AVAppShellFooterConfiguration
    private let onSelectTab: (ID) -> Void
    private let onSelectAssistant: () -> Void
    private let content: () -> Content
    private let footerPlayer: () -> FooterPlayer

    public init(
        selectedTabID: ID,
        tabs: [AVAppShellTab<ID>],
        assistantID: ID,
        assistant: AVAppShellConfiguredAssistant,
        hasAssistantActiveContext: Bool = false,
        footerConfiguration: AVAppShellFooterConfiguration = .contentOnly,
        onSelectTab: @escaping (ID) -> Void,
        onSelectAssistant: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footerPlayer: @escaping () -> FooterPlayer
    ) {
        self.selectedTabID = selectedTabID
        self.tabs = tabs
        self.assistantID = assistantID
        self.assistant = assistant
        self.hasAssistantActiveContext = hasAssistantActiveContext
        self.footerConfiguration = footerConfiguration
        self.onSelectTab = onSelectTab
        self.onSelectAssistant = onSelectAssistant
        self.content = content
        self.footerPlayer = footerPlayer
    }

    public var body: some View {
        AVAppShellStandardScaffold(
            selectedTabID: selectedTabID,
            tabs: tabs,
            assistantID: assistantID,
            assistantName: assistant.name,
            assistantAccessibilityIdentifier: assistant.accessibilityIdentifier,
            assistantAssetName: assistant.assetName,
            hasAssistantActiveContext: hasAssistantActiveContext,
            assistantActiveContextSystemImage: assistant.activeContextSystemImage,
            footerConfiguration: footerConfiguration,
            onSelectTab: onSelectTab,
            onSelectAssistant: onSelectAssistant,
            content: content,
            footerPlayer: footerPlayer
        )
    }
}
