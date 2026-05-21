import AVBrandFoundation
import SwiftUI

public struct AVPlanSummaryPill: View {
    private let title: String
    private let detail: String

    public init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
            Text(title)
                .font(.system(size: 12, weight: .black, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(detail)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 66, alignment: .topLeading)
        .padding(AVBrandSpacing.sm)
        .background(
            AVBrandColor.cardSurface,
            in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                .stroke(AVBrandColor.borderSubtle.opacity(0.55), lineWidth: 1)
        }
    }
}

public struct AVPlanComparisonCard: View {
    private let title: String
    private let subtitle: String
    private let rows: [String]
    private let currentLabel: String?
    private let isHighlighted: Bool

    public init(
        title: String,
        subtitle: String,
        rows: [String],
        currentLabel: String? = nil,
        isHighlighted: Bool = false
    ) {
        self.title = title
        self.subtitle = subtitle
        self.rows = rows
        self.currentLabel = currentLabel
        self.isHighlighted = isHighlighted
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.md) {
            HStack(alignment: .top, spacing: AVBrandSpacing.sm) {
                VStack(alignment: .leading, spacing: AVBrandSpacing.xxs) {
                    Text(title)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundStyle(AVBrandColor.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(AVBrandColor.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: AVBrandSpacing.sm)

                if let currentLabel {
                    Text(currentLabel)
                        .font(.system(size: 11, weight: .black, design: .rounded))
                        .foregroundStyle(AVBrandColor.textInverse)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal, AVBrandSpacing.sm)
                        .padding(.vertical, 6)
                        .background(
                            AVBrandColor.accent,
                            in: Capsule()
                        )
                }
            }

            VStack(alignment: .leading, spacing: AVBrandSpacing.sm) {
                ForEach(rows, id: \.self) { row in
                    AVPlanFeatureRow(text: row)
                }
            }
        }
        .padding(AVBrandSpacing.xl)
        .background(
            isHighlighted ? AVBrandColor.accent.opacity(0.08) : AVBrandColor.elevatedSurface,
            in: RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous)
                .stroke(
                    isHighlighted ? AVBrandColor.accent.opacity(0.34) : AVBrandColor.borderSubtle.opacity(0.55),
                    lineWidth: 1
                )
        }
    }
}

private struct AVPlanFeatureRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: AVBrandSpacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AVBrandColor.accent)
                .padding(.top, 2)

            Text(text)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(AVBrandColor.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
