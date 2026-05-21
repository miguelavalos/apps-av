import AVBrandFoundation
import SwiftUI

public struct AVAviFocusedSummaryCard<Artwork: View, Badge: View>: View {
    private let title: String
    private let subtitle: String
    private let metadata: String?
    private let accessibilityIdentifier: String
    private let artwork: Artwork
    private let badge: Badge

    public init(
        title: String,
        subtitle: String,
        metadata: String? = nil,
        accessibilityIdentifier: String = "avi.focused.summaryCard",
        @ViewBuilder artwork: () -> Artwork,
        @ViewBuilder badge: () -> Badge
    ) {
        self.title = title
        self.subtitle = subtitle
        self.metadata = metadata
        self.accessibilityIdentifier = accessibilityIdentifier
        self.artwork = artwork()
        self.badge = badge()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                artwork
                    .overlay(alignment: .topLeading) {
                        badge
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .lineLimit(2)

                    if let metadata {
                        Text(metadata)
                            .font(.system(size: 12, weight: .black))
                            .foregroundStyle(AVBrandColor.accent)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
        .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AVBrandColor.glassShadow.opacity(0.16), radius: 10, y: 5)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVAviFocusedSummaryCard where Badge == EmptyView {
    init(
        title: String,
        subtitle: String,
        metadata: String? = nil,
        accessibilityIdentifier: String = "avi.focused.summaryCard",
        @ViewBuilder artwork: () -> Artwork
    ) {
        self.title = title
        self.subtitle = subtitle
        self.metadata = metadata
        self.accessibilityIdentifier = accessibilityIdentifier
        self.artwork = artwork()
        self.badge = EmptyView()
    }
}

public struct AVAviStatPill: View {
    private let title: String
    private let value: String
    private let systemImage: String

    public init(title: String, value: String, systemImage: String) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(AVBrandColor.accent)

            Text(value)
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)

            Text(title)
                .font(.system(size: 10, weight: .black))
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .frame(height: 68, alignment: .topLeading)
        .background(AVBrandColor.cardSurface, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.68), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

public struct AVAviInfoLine: View {
    private let title: String
    private let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(AVBrandColor.textSecondary)
                .frame(width: 92, alignment: .leading)

            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}
