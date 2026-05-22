import AVBrandFoundation
import SwiftUI

public struct AVOnboardingHeroText: View {
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
                .font(.system(size: 30, weight: .black))
                .foregroundStyle(AVBrandColor.ink)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.86)

            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AVBrandColor.ink.opacity(0.76))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: subtitleMaxWidth)
        }
        .padding(.horizontal, 42)
        .accessibilityElement(children: .contain)
    }
}
