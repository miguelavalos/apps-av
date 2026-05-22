import AVBrandFoundation
import SwiftUI

public enum AVAviAvatarBadgeBackground {
    case accentSoft
    case elevated
    case muted
    case mutedSoft
}

public enum AVAviAvatarBadgeStroke {
    case accentSoft
    case subtle
}

public struct AVAviAvatarBadge<Avatar: View>: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let imageSize: CGFloat
    private let badgeSize: CGFloat
    private let padding: CGFloat
    private let backgroundStyle: AVAviAvatarBadgeBackground
    private let strokeStyle: AVAviAvatarBadgeStroke
    private let avatar: Avatar

    public init(
        imageSize: CGFloat = 22,
        badgeSize: CGFloat = 36,
        padding: CGFloat = 0,
        backgroundStyle: AVAviAvatarBadgeBackground = .muted,
        strokeStyle: AVAviAvatarBadgeStroke = .subtle,
        @ViewBuilder avatar: () -> Avatar
    ) {
        self.imageSize = imageSize
        self.badgeSize = badgeSize
        self.padding = padding
        self.backgroundStyle = backgroundStyle
        self.strokeStyle = strokeStyle
        self.avatar = avatar()
    }

    public var body: some View {
        avatar
            .frame(width: imageSize, height: imageSize)
            .padding(padding)
            .frame(width: badgeSize, height: badgeSize)
            .background(backgroundColor, in: Circle())
            .overlay {
                Circle()
                    .stroke(strokeColor, lineWidth: 1)
            }
            .accessibilityHidden(true)
    }

    private var backgroundColor: Color {
        switch backgroundStyle {
        case .accentSoft:
            brandPalette.accent.opacity(0.1)
        case .elevated:
            AVBrandColor.elevatedSurface
        case .muted:
            AVBrandColor.mutedSurface
        case .mutedSoft:
            AVBrandColor.mutedSurface.opacity(0.85)
        }
    }

    private var strokeColor: Color {
        switch strokeStyle {
        case .accentSoft:
            brandPalette.accent.opacity(0.22)
        case .subtle:
            AVBrandColor.borderSubtle
        }
    }
}
