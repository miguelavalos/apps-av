import AVBrandFoundation
import SwiftUI

public struct AVAppShellMetadataCard<Content: View>: View {
    private let spacing: CGFloat
    private let padding: CGFloat
    private let content: Content

    public init(
        spacing: CGFloat = 8,
        padding: CGFloat = 10,
        @ViewBuilder content: () -> Content
    ) {
        self.spacing = spacing
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(padding)
        .background(AVBrandColor.cardSurface.opacity(0.72), in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.5), lineWidth: 1)
        }
    }
}

public struct AVAppShellMetadataItem: View {
    private let title: String
    private let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AVBrandColor.textSecondary)

            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

public struct AVAppShellIdentifierRow: View {
    private let title: String
    private let value: String?
    private let lineLimit: Int

    public init(title: String, value: String?, lineLimit: Int = 2) {
        self.title = title
        self.value = value
        self.lineLimit = lineLimit
    }

    public var body: some View {
        if let value, !value.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(AVBrandColor.textSecondary)

                Text(value)
                    .font(.caption.monospaced())
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .textSelection(.enabled)
                    .lineLimit(lineLimit)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}
