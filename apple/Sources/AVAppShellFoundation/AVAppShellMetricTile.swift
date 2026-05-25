import AVBrandFoundation
import SwiftUI

public struct AVAppShellMetric: Identifiable, Sendable {
    public var id: String
    public var title: String
    public var value: String
    public var systemImage: String?

    public init(
        id: String,
        title: String,
        value: String,
        systemImage: String? = nil
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.systemImage = systemImage
    }
}

public struct AVAppShellMetricTile: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let metric: AVAppShellMetric
    private let minHeight: CGFloat
    private let valueFont: Font

    public init(
        metric: AVAppShellMetric,
        minHeight: CGFloat = 86,
        valueFont: Font = .title3.weight(.semibold)
    ) {
        self.metric = metric
        self.minHeight = minHeight
        self.valueFont = valueFont
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AVBrandSpacing.xs) {
            if let systemImage = metric.systemImage {
                Image(systemName: systemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(brandPalette.accent)
            }

            Text(metric.value)
                .font(valueFont)
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.76)

            Text(metric.title)
                .font(AVBrandTypography.caption)
                .foregroundStyle(AVBrandColor.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
        }
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .leading)
        .padding(AVBrandSpacing.md)
        .background(brandPalette.accent.opacity(0.08), in: RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.xs, style: .continuous)
                .stroke(brandPalette.accent.opacity(0.12), lineWidth: 1)
        }
    }
}

public struct AVAppShellMetricStrip: View {
    private let metrics: [AVAppShellMetric]
    private let spacing: CGFloat
    private let minTileHeight: CGFloat

    public init(
        metrics: [AVAppShellMetric],
        spacing: CGFloat = AVBrandSpacing.sm,
        minTileHeight: CGFloat = 86
    ) {
        self.metrics = metrics
        self.spacing = spacing
        self.minTileHeight = minTileHeight
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(metrics) { metric in
                AVAppShellMetricTile(metric: metric, minHeight: minTileHeight)
            }
        }
    }
}
