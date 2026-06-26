import SwiftUI

public enum AVAppShellTabletSidebarMetric {
    public static let horizontalPadding: CGFloat = 18
    public static let verticalPadding: CGFloat = 22
    public static let rowHorizontalInset: CGFloat = 12
    public static let rowVerticalInset: CGFloat = 10
    public static let rowCornerRadius: CGFloat = 8
}

public struct AVAppShellTabletSidebarBrandHeader: View {
    private let logoAssetName: String
    private let accessibilityLabel: String
    private let logoWidth: CGFloat
    private let logoHeight: CGFloat
    private let logoLeadingCorrection: CGFloat

    public init(
        logoAssetName: String,
        accessibilityLabel: String,
        logoWidth: CGFloat,
        logoHeight: CGFloat,
        logoLeadingCorrection: CGFloat = 0
    ) {
        self.logoAssetName = logoAssetName
        self.accessibilityLabel = accessibilityLabel
        self.logoWidth = logoWidth
        self.logoHeight = logoHeight
        self.logoLeadingCorrection = logoLeadingCorrection
    }

    public var body: some View {
        HStack {
            Image(logoAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: logoWidth, height: logoHeight)
                .offset(x: logoLeadingCorrection)
                .accessibilityLabel(accessibilityLabel)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, AVAppShellTabletSidebarMetric.rowHorizontalInset)
        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
    }
}

public struct AVAppShellTabletSidebarButton: View {
    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let fontSize: CGFloat
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool,
        fontSize: CGFloat = 16,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.fontSize = fontSize
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: fontSize, weight: isSelected ? .semibold : .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AVAppShellTabletSidebarMetric.rowHorizontalInset)
                .padding(.vertical, AVAppShellTabletSidebarMetric.rowVerticalInset)
                .background(
                    isSelected ? Color.primary.opacity(0.08) : Color.clear,
                    in: RoundedRectangle(
                        cornerRadius: AVAppShellTabletSidebarMetric.rowCornerRadius,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
    }
}
