import AVBrandFoundation
import SwiftUI

public struct AVOnboardingHeroText: View {
    @Environment(\.avBrandPalette) private var brandPalette
    @Environment(\.colorScheme) private var colorScheme

    private let title: String
    private let subtitle: String
    private let subtitleMaxWidth: CGFloat

    public init(
        title: String,
        subtitle: String,
        subtitleMaxWidth: CGFloat = 316
    ) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleMaxWidth = subtitleMaxWidth
    }

    public var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: subtitleMaxWidth > 316 ? 36 : 30, weight: .black))
                .foregroundStyle(titleColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.86)

            Text(subtitle)
                .font(.system(size: subtitleMaxWidth > 316 ? 18 : 15, weight: .medium))
                .foregroundStyle(subtitleColor)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: subtitleMaxWidth)
        }
        .padding(.horizontal, 42)
        .accessibilityElement(children: .contain)
    }

    private var titleColor: Color {
        colorScheme == .dark ? AVBrandColor.textPrimary : brandPalette.ink
    }

    private var subtitleColor: Color {
        colorScheme == .dark ? AVBrandColor.textSecondary : brandPalette.ink.opacity(0.76)
    }
}
