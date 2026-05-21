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
