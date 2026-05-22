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
        AVMaterialControlButton(
            size: 34,
            isEnabled: isEnabled,
            accessibilityIdentifier: accessibilityIdentifier,
            action: action
        ) {
            label
        }
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

public struct AVExpandedFooterPlayerScaffold<Artwork: View, Controls: View>: View {
    private let primaryTitle: String
    private let subtitle: String
    private let title: String
    private let isSubtitleHighlighted: Bool
    private let primaryTitleAccessibilityIdentifier: String
    private let artworkAccessibilityLabel: String
    private let artworkAccessibilityIdentifier: String
    private let metadataAccessibilityIdentifier: String
    private let accessibilityLabel: String
    private let accessibilityHint: String
    private let accessibilityIdentifier: String
    private let primaryAction: () -> Void
    private let artworkAction: () -> Void
    private let metadataAction: () -> Void
    private let artwork: Artwork
    private let controls: Controls

    public init(
        primaryTitle: String,
        subtitle: String,
        title: String,
        isSubtitleHighlighted: Bool = false,
        primaryTitleAccessibilityIdentifier: String = "footerPlayer.primaryTitle",
        artworkAccessibilityLabel: String,
        artworkAccessibilityIdentifier: String = "footerPlayer.artworkZoom",
        metadataAccessibilityIdentifier: String = "footerPlayer.textZoom",
        accessibilityLabel: String,
        accessibilityHint: String,
        accessibilityIdentifier: String = "footerPlayer.container",
        primaryAction: @escaping () -> Void,
        artworkAction: @escaping () -> Void,
        metadataAction: @escaping () -> Void,
        @ViewBuilder artwork: () -> Artwork,
        @ViewBuilder controls: () -> Controls
    ) {
        self.primaryTitle = primaryTitle
        self.subtitle = subtitle
        self.title = title
        self.isSubtitleHighlighted = isSubtitleHighlighted
        self.primaryTitleAccessibilityIdentifier = primaryTitleAccessibilityIdentifier
        self.artworkAccessibilityLabel = artworkAccessibilityLabel
        self.artworkAccessibilityIdentifier = artworkAccessibilityIdentifier
        self.metadataAccessibilityIdentifier = metadataAccessibilityIdentifier
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
        self.primaryAction = primaryAction
        self.artworkAction = artworkAction
        self.metadataAction = metadataAction
        self.artwork = artwork()
        self.controls = controls()
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: primaryAction) {
                primaryTitleText
            }
            .buttonStyle(.plain)
            .accessibilityLabel(primaryTitle)
            .accessibilityIdentifier(primaryTitleAccessibilityIdentifier)
            .frame(height: 22)

            Spacer()
                .frame(height: 8)

            Button(action: artworkAction) {
                artwork
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(artworkAccessibilityLabel)
            .accessibilityIdentifier(artworkAccessibilityIdentifier)
            .frame(height: 152)

            Spacer()
                .frame(height: 14)

            Button(action: metadataAction) {
                metadataText
            }
            .buttonStyle(.plain)
            .accessibilityLabel(artworkAccessibilityLabel)
            .accessibilityIdentifier(metadataAccessibilityIdentifier)
            .frame(height: 58)

            Spacer(minLength: 0)

            controls
                .frame(height: 72)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(height: 360)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AVBrandColor.cardSurface)
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
        .accessibilityElement(children: .contain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityIdentifier(accessibilityIdentifier)
    }

    private var metadataText: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(subtitle)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(isSubtitleHighlighted ? AVBrandColor.accent : AVBrandColor.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(height: 19, alignment: .center)

            Text(title)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.86)
                .truncationMode(.tail)
                .frame(height: 40, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .contentShape(Rectangle())
    }

    private var primaryTitleText: some View {
        Text(primaryTitle)
            .font(.system(size: 13, weight: .black, design: .rounded))
            .foregroundStyle(AVBrandColor.textSecondary)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .minimumScaleFactor(0.78)
            .truncationMode(.tail)
            .frame(height: 18, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
    }
}

public struct AVFooterPlayerControlButton<Label: View>: View {
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
        AVMaterialControlButton(
            size: 54,
            isEnabled: isEnabled,
            accessibilityIdentifier: accessibilityIdentifier,
            action: action
        ) {
            label
        }
    }
}

public extension AVFooterPlayerControlButton where Label == AnyView {
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
                    .font(.system(size: 18, weight: .bold))
            )
        }
    }
}

private struct AVMaterialControlButton<Label: View>: View {
    let size: CGFloat
    let isEnabled: Bool
    let accessibilityIdentifier: String
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            label()
                .foregroundStyle(AVBrandColor.textSecondary.opacity(isEnabled ? 1 : 0.28))
                .frame(width: size, height: size)
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
