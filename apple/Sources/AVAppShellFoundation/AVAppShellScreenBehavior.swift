import SwiftUI

public enum AVAppShellScreenMetric {
    public static let horizontalPadding: CGFloat = 20
    public static let topPadding: CGFloat = 24
    public static let bottomContentPadding: CGFloat = 176
}

public extension View {
    func avShellScreenContentPadding(
        horizontal: CGFloat = AVAppShellScreenMetric.horizontalPadding,
        top: CGFloat = AVAppShellScreenMetric.topPadding,
        bottom: CGFloat = AVAppShellScreenMetric.bottomContentPadding
    ) -> some View {
        padding(.horizontal, horizontal)
            .padding(.top, top)
            .padding(.bottom, bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func avShellScreenScrollBehavior() -> some View {
        contentMargins(.horizontal, 0, for: .scrollContent)
            .scrollIndicators(.hidden)
    }
}
