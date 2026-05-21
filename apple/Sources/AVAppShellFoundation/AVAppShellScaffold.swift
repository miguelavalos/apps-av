import AVBrandFoundation
import SwiftUI

public struct AVAppShellScaffold<ID: Hashable, Content: View, FooterPlayer: View, AssistantIcon: View>: View {
    private let selectedTabID: ID
    private let tabs: [AVAppShellTab<ID>]
    private let assistantID: ID
    private let assistantAccessibilityLabel: String
    private let assistantAccessibilityIdentifier: String
    private let hasAssistantActiveContext: Bool
    private let footerBackdropHeight: CGFloat
    private let footerPlayerTabSpacing: CGFloat
    private let onSelectTab: (ID) -> Void
    private let onSelectAssistant: () -> Void
    private let content: () -> Content
    private let footerPlayer: () -> FooterPlayer
    private let assistantIcon: (_ isSelected: Bool) -> AssistantIcon

    @Namespace private var footerSelectionAnimation

    public init(
        selectedTabID: ID,
        tabs: [AVAppShellTab<ID>],
        assistantID: ID,
        assistantAccessibilityLabel: String,
        assistantAccessibilityIdentifier: String,
        hasAssistantActiveContext: Bool,
        footerBackdropHeight: CGFloat,
        footerPlayerTabSpacing: CGFloat,
        onSelectTab: @escaping (ID) -> Void,
        onSelectAssistant: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footerPlayer: @escaping () -> FooterPlayer,
        @ViewBuilder assistantIcon: @escaping (_ isSelected: Bool) -> AssistantIcon
    ) {
        self.selectedTabID = selectedTabID
        self.tabs = tabs
        self.assistantID = assistantID
        self.assistantAccessibilityLabel = assistantAccessibilityLabel
        self.assistantAccessibilityIdentifier = assistantAccessibilityIdentifier
        self.hasAssistantActiveContext = hasAssistantActiveContext
        self.footerBackdropHeight = footerBackdropHeight
        self.footerPlayerTabSpacing = footerPlayerTabSpacing
        self.onSelectTab = onSelectTab
        self.onSelectAssistant = onSelectAssistant
        self.content = content
        self.footerPlayer = footerPlayer
        self.assistantIcon = assistantIcon
    }

    public var body: some View {
        ZStack {
            AVBrandSurface.shellBackground.ignoresSafeArea()

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(alignment: .bottom) {
            footer
        }
    }

    private var footer: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [
                    AVBrandColor.footerBackdrop.opacity(0),
                    AVBrandColor.footerBackdrop.opacity(0.94),
                    AVBrandColor.footerBackdrop
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: footerBackdropHeight)
            .allowsHitTesting(false)

            VStack(spacing: footerPlayerTabSpacing) {
                footerPlayer()

                HStack(spacing: 18) {
                    HStack {
                        ForEach(tabs) { tab in
                            AVAppShellFooterTabButton(
                                title: tab.title,
                                systemImage: tab.systemImage,
                                isSelected: selectedTabID == tab.id,
                                selectionNamespace: footerSelectionAnimation,
                                accessibilityIdentifier: tab.accessibilityIdentifier
                            ) {
                                onSelectTab(tab.id)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background {
                        Capsule(style: .continuous)
                            .fill(AVBrandColor.footerGlass)
                            .background(.ultraThinMaterial.opacity(0.95), in: Capsule(style: .continuous))
                            .overlay {
                                Capsule(style: .continuous)
                                    .stroke(AVBrandColor.glassStroke, lineWidth: 1)
                            }
                    }
                    .shadow(color: AVBrandColor.glassShadow, radius: 18, y: 10)

                    AVAppShellAssistantButton(
                        isSelected: selectedTabID == assistantID,
                        hasActiveContext: hasAssistantActiveContext,
                        accessibilityLabel: assistantAccessibilityLabel,
                        accessibilityIdentifier: assistantAccessibilityIdentifier,
                        icon: assistantIcon,
                        action: onSelectAssistant
                    )
                    .shadow(color: AVBrandColor.glassShadow, radius: 18, y: 10)
                }
                .frame(maxWidth: 430)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, -8)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

private struct AVAppShellFooterTabButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let selectionNamespace: Namespace.ID
    let accessibilityIdentifier: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                        .fill(AVBrandColor.footerGlassSelected)
                        .matchedGeometryEffect(id: "footerSelection", in: selectionNamespace)
                        .overlay {
                            RoundedRectangle(cornerRadius: AVBrandRadius.footerSelection, style: .continuous)
                                .stroke(AVBrandColor.glassStroke, lineWidth: 0.8)
                        }
                }

                Image(systemName: displayedSystemImage)
                    .font(.system(size: AVBrandIconSize.footerTab, weight: isSelected ? .semibold : .regular))
                    .frame(width: AVBrandIconSize.footerTab, height: AVBrandIconSize.footerTab)
                    .symbolRenderingMode(.monochrome)
            }
            .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textSecondary)
            .frame(width: 64, height: 46)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }

    private var displayedSystemImage: String {
        guard !isSelected else { return systemImage }
        return systemImage.replacingOccurrences(of: ".fill", with: "")
    }
}

private struct AVAppShellAssistantButton<Icon: View>: View {
    let isSelected: Bool
    let hasActiveContext: Bool
    let accessibilityLabel: String
    let accessibilityIdentifier: String
    let icon: (_ isSelected: Bool) -> Icon
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(AVBrandColor.footerGlass)
                    .background(.ultraThinMaterial.opacity(0.95), in: Circle())
                    .overlay {
                        Circle()
                            .stroke(AVBrandColor.glassStroke, lineWidth: 1)
                    }

                if isSelected {
                    Circle()
                        .fill(AVBrandColor.footerGlassSelected)
                        .padding(4)

                    Circle()
                        .fill(AVBrandColor.accent.opacity(0.14))
                        .padding(9)
                }

                icon(isSelected)
                    .frame(width: isSelected ? 42 : 40, height: isSelected ? 32 : 30)
                    .opacity(isSelected ? 1 : 0.84)
                    .saturation(isSelected ? 1.06 : 0.82)
                    .padding(8)
                    .shadow(color: AVBrandColor.accent.opacity(isSelected ? 0.24 : 0), radius: 6, y: 2)

                if hasActiveContext && !isSelected {
                    Image(systemName: "waveform")
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(AVBrandColor.accent)
                        .frame(width: 20, height: 20)
                        .background(AVBrandColor.cardSurface, in: Circle())
                        .overlay {
                            Circle()
                                .stroke(AVBrandColor.accent.opacity(0.32), lineWidth: 1)
                        }
                        .shadow(color: AVBrandColor.accent.opacity(0.18), radius: 4, y: 2)
                        .offset(x: 20, y: -18)
                }
            }
            .frame(width: 62, height: 62)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
