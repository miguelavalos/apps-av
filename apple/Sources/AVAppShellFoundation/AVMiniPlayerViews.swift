import AVBrandFoundation
import SwiftUI

public struct AVMiniPlayerScaffold<Artwork: View, Controls: View>: View {
    private let title: String
    private let subtitle: String
    private let detail: String
    private let isSubtitleHighlighted: Bool
    private let accessibilityLabel: String
    private let accessibilityHint: String
    private let accessibilityIdentifier: String
    private let action: () -> Void
    private let artwork: Artwork
    private let controls: Controls

    public init(
        title: String,
        subtitle: String,
        detail: String,
        isSubtitleHighlighted: Bool = false,
        accessibilityLabel: String,
        accessibilityHint: String,
        accessibilityIdentifier: String = "miniPlayer.container",
        action: @escaping () -> Void,
        @ViewBuilder artwork: () -> Artwork,
        @ViewBuilder controls: () -> Controls
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.isSubtitleHighlighted = isSubtitleHighlighted
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.artwork = artwork()
        self.controls = controls()
    }

    public var body: some View {
        HStack(spacing: 12) {
            artwork

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(isSubtitleHighlighted ? AVBrandColor.accent : AVBrandColor.textSecondary)
                    .lineLimit(1)

                Text(detail)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(AVBrandColor.textSecondary.opacity(0.88))
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            controls
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AVBrandColor.elevatedSurface)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [AVBrandColor.glassStroke, AVBrandColor.accent.opacity(0.12)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: AVBrandColor.glassShadow.opacity(0.7), radius: 8, y: 2)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture(perform: action)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVMiniPlayerControlButton<Label: View>: View {
    private let isEnabled: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void
    private let label: Label

    public init(
        isEnabled: Bool = true,
        accessibilityIdentifier: String,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.isEnabled = isEnabled
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
        self.label = label()
    }

    public var body: some View {
        Button(action: action) {
            label
                .foregroundStyle(AVBrandColor.textSecondary.opacity(isEnabled ? 1 : 0.28))
                .frame(width: 34, height: 34)
                .background(.ultraThinMaterial.opacity(isEnabled ? 1 : 0.45), in: Circle())
                .overlay {
                    Circle()
                        .stroke(.white.opacity(isEnabled ? 0.12 : 0.06), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVMiniPlayerControlButton where Label == AnyView {
    init(
        systemImage: String,
        isEnabled: Bool = true,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.init(
            isEnabled: isEnabled,
            accessibilityIdentifier: accessibilityIdentifier,
            action: action
        ) {
            AnyView(
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .bold))
            )
        }
    }
}
