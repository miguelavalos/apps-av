import SwiftUI

public struct AVAppShellBrandHeaderScaffold<Leading: View, Logo: View, Trailing: View>: View {
    private let spacing: CGFloat
    private let sideSpacerMinLength: CGFloat
    private let logoWidth: CGFloat
    private let logoHeight: CGFloat
    private let leading: Leading
    private let logo: Logo
    private let trailing: Trailing

    public init(
        spacing: CGFloat = 12,
        sideSpacerMinLength: CGFloat = 8,
        logoWidth: CGFloat = 160,
        logoHeight: CGFloat = 54,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder logo: () -> Logo,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.spacing = spacing
        self.sideSpacerMinLength = sideSpacerMinLength
        self.logoWidth = logoWidth
        self.logoHeight = logoHeight
        self.leading = leading()
        self.logo = logo()
        self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: spacing) {
            leading

            Spacer(minLength: sideSpacerMinLength)

            logo
                .frame(width: logoWidth, height: logoHeight)

            Spacer(minLength: sideSpacerMinLength)

            trailing
        }
    }
}
