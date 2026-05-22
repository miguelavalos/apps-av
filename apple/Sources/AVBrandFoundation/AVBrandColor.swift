import SwiftUI

#if os(iOS)
import UIKit
typealias AVBrandPlatformColor = UIColor
#elseif os(macOS)
import AppKit
typealias AVBrandPlatformColor = NSColor
#endif

public enum AVBrandColor {
    public static let ink = Color(red: 58 / 255, green: 58 / 255, blue: 54 / 255)
    public static let accentBase = Color(red: 109 / 255, green: 190 / 255, blue: 69 / 255)
    public static let canvas = Color.white

    public static let neutral50 = Color(red: 247 / 255, green: 249 / 255, blue: 248 / 255)
    public static let neutral100 = Color(red: 238 / 255, green: 242 / 255, blue: 239 / 255)
    public static let neutral300 = Color(red: 200 / 255, green: 209 / 255, blue: 203 / 255)
    public static let neutral600 = Color(red: 95 / 255, green: 104 / 255, blue: 98 / 255)
    public static let neutral800 = Color(red: 26 / 255, green: 29 / 255, blue: 27 / 255)

    public static let accent = accentBase
    public static let destructive = Color(red: 0.84, green: 0.16, blue: 0.22)
    public static let textPrimary = dynamicColor(
        light: AVBrandPlatformColor(red: 58 / 255, green: 58 / 255, blue: 54 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 242 / 255, green: 245 / 255, blue: 243 / 255, alpha: 1)
    )
    public static let textSecondary = dynamicColor(
        light: AVBrandPlatformColor(red: 95 / 255, green: 104 / 255, blue: 98 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 161 / 255, green: 170 / 255, blue: 165 / 255, alpha: 1)
    )
    public static let textInverse = canvas

    public static let cardSurface = dynamicColor(
        light: AVBrandPlatformColor(red: 251 / 255, green: 252 / 255, blue: 251 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 30 / 255, green: 34 / 255, blue: 31 / 255, alpha: 1)
    )
    public static let mutedSurface = dynamicColor(
        light: AVBrandPlatformColor(red: 238 / 255, green: 242 / 255, blue: 239 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 42 / 255, green: 46 / 255, blue: 43 / 255, alpha: 1)
    )
    public static let borderSubtle = dynamicColor(
        light: AVBrandPlatformColor(red: 200 / 255, green: 209 / 255, blue: 203 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 72 / 255, green: 79 / 255, blue: 74 / 255, alpha: 1)
    )
    public static let borderStrong = dynamicColor(
        light: AVBrandPlatformColor(red: 149 / 255, green: 159 / 255, blue: 152 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 108 / 255, green: 116 / 255, blue: 111 / 255, alpha: 1)
    )
    public static let darkSurface = ink
    public static let darkSurfaceAlt = neutral800
    public static let footerGlass = dynamicColor(
        light: AVBrandPlatformColor.white.withAlphaComponent(0.86),
        dark: AVBrandPlatformColor.white.withAlphaComponent(0.28)
    )
    public static let footerGlassSelected = dynamicColor(
        light: AVBrandPlatformColor.white.withAlphaComponent(0.92),
        dark: AVBrandPlatformColor.white.withAlphaComponent(0.34)
    )
    public static let footerBackdrop = dynamicColor(
        light: AVBrandPlatformColor(red: 247 / 255, green: 249 / 255, blue: 248 / 255, alpha: 1),
        dark: AVBrandPlatformColor(red: 13 / 255, green: 13 / 255, blue: 13 / 255, alpha: 1)
    )
    public static let glassStroke = dynamicColor(
        light: AVBrandPlatformColor.white.withAlphaComponent(0.5),
        dark: AVBrandPlatformColor.white.withAlphaComponent(0.18)
    )
    public static let glassShadow = dynamicColor(
        light: AVBrandPlatformColor.black.withAlphaComponent(0.08),
        dark: AVBrandPlatformColor.black.withAlphaComponent(0.28)
    )
    public static let elevatedSurface = dynamicColor(
        light: AVBrandPlatformColor.white.withAlphaComponent(0.94),
        dark: AVBrandPlatformColor(red: 35 / 255, green: 39 / 255, blue: 36 / 255, alpha: 0.96)
    )
    public static let skeletonHighlight = dynamicColor(
        light: AVBrandPlatformColor.white.withAlphaComponent(0.95),
        dark: AVBrandPlatformColor(red: 58 / 255, green: 64 / 255, blue: 60 / 255, alpha: 1)
    )

    public static let softShadow = dynamicColor(
        light: AVBrandPlatformColor.black.withAlphaComponent(0.12),
        dark: AVBrandPlatformColor.black.withAlphaComponent(0.34)
    )

    static func dynamicColor(light: AVBrandPlatformColor, dark: AVBrandPlatformColor) -> Color {
        #if os(iOS)
        return Color(
            uiColor: UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        )
        #elseif os(macOS)
        return Color(nsColor: NSColor(name: nil) { appearance in
            let best = appearance.bestMatch(from: [.darkAqua, .aqua])
            return best == .darkAqua ? dark : light
        })
        #endif
    }
}
