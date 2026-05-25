import AVBrandFoundation
import SwiftUI

public struct AVAviGuidanceCard<Content: View>: View {
    private let title: String
    private let detail: String
    private let spacing: CGFloat
    private let content: Content

    public init(
        title: String,
        detail: String,
        spacing: CGFloat = AVBrandSpacing.lg,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.detail = detail
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            VStack(alignment: .leading, spacing: AVBrandSpacing.xs) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.78)

                Text(detail)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
        .padding(AVBrandSpacing.xxl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AVBrandColor.elevatedSurface, in: RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.64), lineWidth: 1)
        }
    }
}
