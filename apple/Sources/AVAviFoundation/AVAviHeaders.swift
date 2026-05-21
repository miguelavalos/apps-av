import AVBrandFoundation
import SwiftUI

public struct AVAviScreenHeader<Avatar: View>: View {
    private let title: String
    private let summary: String
    private let status: String?
    private let accessibilityIdentifier: String
    private let avatar: Avatar

    public init(
        title: String,
        summary: String,
        status: String? = nil,
        accessibilityIdentifier: String,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.title = title
        self.summary = summary
        self.status = status
        self.accessibilityIdentifier = accessibilityIdentifier
        self.avatar = avatar()
    }

    public var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.md) {
            avatar

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.68)
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 7) {
                    Text(summary)
                        .font(AVBrandTypography.captionStrong)
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    if let status {
                        Text(status)
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(AVBrandColor.accent)
                            .padding(.horizontal, AVBrandSpacing.xs)
                            .padding(.vertical, 5)
                            .background(AVBrandColor.accent.opacity(0.11), in: Capsule(style: .continuous))
                    }

                    Spacer(minLength: 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public extension AVAviScreenHeader where Avatar == EmptyView {
    init(
        title: String,
        summary: String,
        status: String? = nil,
        accessibilityIdentifier: String
    ) {
        self.title = title
        self.summary = summary
        self.status = status
        self.accessibilityIdentifier = accessibilityIdentifier
        self.avatar = EmptyView()
    }
}

public struct AVAviFullPlayerHeaderScaffold<Avatar: View>: View {
    private let label: String
    private let title: String
    private let summary: String
    private let accessibilityValue: String?
    private let accessibilityIdentifier: String
    private let avatar: Avatar

    public init(
        label: String,
        title: String,
        summary: String,
        accessibilityValue: String? = nil,
        accessibilityIdentifier: String = "avi.fullPlayer.header",
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.label = label
        self.title = title
        self.summary = summary
        self.accessibilityValue = accessibilityValue
        self.accessibilityIdentifier = accessibilityIdentifier
        self.avatar = avatar()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: AVBrandSpacing.lg) {
            avatar

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(AVBrandColor.accent)
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .allowsTightening(true)
                    .frame(height: 12)

                Text(title)
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .allowsTightening(true)
                    .truncationMode(.tail)
                    .frame(height: 46, alignment: .topLeading)

                Text(summary)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.76)
                    .allowsTightening(true)
                    .truncationMode(.tail)
                    .frame(height: 28, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 2)
        .frame(height: 96)
        .accessibilityElement(children: .contain)
        .accessibilityValue(accessibilityValue ?? "")
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
