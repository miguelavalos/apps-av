import AVBrandFoundation
import SwiftUI

public struct AVAuthOptionsPanelScaffold<Actions: View, Accessory: View>: View {
    @Environment(\.avBrandPalette) private var brandPalette
    @Environment(\.colorScheme) private var colorScheme

    private let title: String
    private let subtitle: String
    private let legalConsentText: AttributedString
    private let unavailableMessage: String?
    private let skipTitle: String?
    private let actionsAreDisabled: Bool
    private let onSkip: (() -> Void)?
    private let actions: Actions
    private let accessory: Accessory

    public init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String? = nil,
        actionsAreDisabled: Bool = false,
        onSkip: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.legalConsentText = legalConsentText
        self.unavailableMessage = unavailableMessage
        self.skipTitle = skipTitle
        self.actionsAreDisabled = actionsAreDisabled
        self.onSkip = onSkip
        self.actions = actions()
        self.accessory = accessory()
    }

    public var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(handleColor)
                .frame(width: 46, height: 4)
                .padding(.top, 12)

            VStack(spacing: 7) {
                Text(title)
                    .font(.system(size: 22, weight: .black, design: .serif))
                    .foregroundStyle(titleColor)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(subtitleColor)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 16)

            VStack(spacing: 10) {
                actions
            }
            .padding(.top, 20)
            .disabled(actionsAreDisabled)

            if let unavailableMessage {
                Text(unavailableMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(titleColor.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
            }

            if let skipTitle, let onSkip {
                Button(skipTitle, action: onSkip)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(titleColor.opacity(0.82))
                    .padding(.top, 16)
            }

            Text(legalConsentText)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(titleColor.opacity(0.66))
                .tint(titleColor.opacity(0.9))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(panelSurface)
                .overlay {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(panelStroke, lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.28), radius: 24, y: 14)
        )
        .overlay(alignment: .topTrailing) {
            accessory
        }
    }

    private var titleColor: Color {
        colorScheme == .dark ? AVBrandColor.textPrimary : brandPalette.ink
    }

    private var subtitleColor: Color {
        colorScheme == .dark ? AVBrandColor.textSecondary : AVBrandColor.neutral600
    }

    private var handleColor: Color {
        titleColor.opacity(colorScheme == .dark ? 0.28 : 0.22)
    }

    private var panelSurface: Color {
        colorScheme == .dark ? AVBrandColor.elevatedSurface : AVBrandColor.warmPanelSurface.opacity(0.98)
    }

    private var panelStroke: Color {
        colorScheme == .dark ? AVBrandColor.glassStroke : brandPalette.ink.opacity(0.12)
    }
}

public extension AVAuthOptionsPanelScaffold where Accessory == EmptyView {
    init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String? = nil,
        actionsAreDisabled: Bool = false,
        onSkip: (() -> Void)? = nil,
        @ViewBuilder actions: () -> Actions
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            legalConsentText: legalConsentText,
            unavailableMessage: unavailableMessage,
            skipTitle: skipTitle,
            actionsAreDisabled: actionsAreDisabled,
            onSkip: onSkip,
            actions: actions,
            accessory: { EmptyView() }
        )
    }
}
