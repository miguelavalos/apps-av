import AVBrandFoundation
import SwiftUI

public struct AVAuthOptionsPanelScaffold<Actions: View, Accessory: View>: View {
    private let title: String
    private let subtitle: String
    private let legalConsentText: AttributedString
    private let unavailableMessage: String?
    private let skipTitle: String
    private let actionsAreDisabled: Bool
    private let onSkip: () -> Void
    private let actions: Actions
    private let accessory: Accessory

    public init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String,
        actionsAreDisabled: Bool = false,
        onSkip: @escaping () -> Void,
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
                .fill(AVBrandColor.ink.opacity(0.22))
                .frame(width: 46, height: 4)
                .padding(.top, 12)

            VStack(spacing: 7) {
                Text(title)
                    .font(.system(size: 22, weight: .black, design: .serif))
                    .foregroundStyle(AVBrandColor.ink)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(AVBrandColor.neutral600)
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
                    .foregroundStyle(AVBrandColor.ink.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
            }

            Button(skipTitle, action: onSkip)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AVBrandColor.ink.opacity(0.82))
                .padding(.top, 16)

            Text(legalConsentText)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(AVBrandColor.ink.opacity(0.66))
                .tint(AVBrandColor.ink.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.top, 14)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AVBrandColor.warmPanelSurface.opacity(0.98))
                .overlay {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .stroke(AVBrandColor.ink.opacity(0.12), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.28), radius: 24, y: 14)
        )
        .overlay(alignment: .topTrailing) {
            accessory
        }
    }
}

public extension AVAuthOptionsPanelScaffold where Accessory == EmptyView {
    init(
        title: String,
        subtitle: String,
        legalConsentText: AttributedString,
        unavailableMessage: String? = nil,
        skipTitle: String,
        actionsAreDisabled: Bool = false,
        onSkip: @escaping () -> Void,
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
