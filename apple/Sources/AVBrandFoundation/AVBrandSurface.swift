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
        colors: [
            AVBrandColor.launchSurfaceStart,
            AVBrandColor.launchSurfaceMid,
            AVBrandColor.neutral50
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let accentGradient = LinearGradient(
        colors: [AVBrandColor.accentBase.opacity(0.96), AVBrandColor.canvas.opacity(0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
