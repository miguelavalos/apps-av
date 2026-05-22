import SwiftUI

public enum AVBrandSurface {
    public static let shellBackground = LinearGradient(
        colors: [
            AVBrandColor.dynamicColor(
                light: AVBrandPlatformColor.white,
                dark: AVBrandPlatformColor(red: 20 / 255, green: 22 / 255, blue: 20 / 255, alpha: 1)
            ),
            AVBrandColor.dynamicColor(
                light: AVBrandPlatformColor(red: 247 / 255, green: 249 / 255, blue: 248 / 255, alpha: 1),
                dark: AVBrandPlatformColor(red: 32 / 255, green: 35 / 255, blue: 32 / 255, alpha: 1)
            ),
            AVBrandColor.dynamicColor(
                light: AVBrandPlatformColor(red: 238 / 255, green: 242 / 255, blue: 239 / 255, alpha: 1),
                dark: AVBrandPlatformColor(red: 42 / 255, green: 46 / 255, blue: 42 / 255, alpha: 1)
            )
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let onboardingBackground = LinearGradient(
        colors: [AVBrandColor.ink, AVBrandColor.darkSurfaceAlt],
        startPoint: .top,
        endPoint: .bottom
    )

    public static let launchBackground = LinearGradient(
        colors: launchBackgroundColors(for: .standard),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let accentGradient = LinearGradient(
        colors: accentGradientColors(for: .standard),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static func onboardingBackground(for palette: AVBrandPalette) -> LinearGradient {
        LinearGradient(
            colors: [palette.ink, palette.darkSurfaceAlt],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    public static func launchBackground(for palette: AVBrandPalette) -> LinearGradient {
        LinearGradient(
            colors: launchBackgroundColors(for: palette),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static func accentGradient(for palette: AVBrandPalette) -> LinearGradient {
        LinearGradient(
            colors: accentGradientColors(for: palette),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private static func launchBackgroundColors(for palette: AVBrandPalette) -> [Color] {
        [
            palette.launchSurfaceStart,
            palette.launchSurfaceMid,
            AVBrandColor.neutral50
        ]
    }

    private static func accentGradientColors(for palette: AVBrandPalette) -> [Color] {
        [palette.accent.opacity(0.96), palette.canvas.opacity(0.9)]
    }
}
