import SwiftUI

public struct AVBrandPalette: Equatable, @unchecked Sendable {
    public var ink: Color
    public var accent: Color
    public var canvas: Color
    public var launchSurfaceStart: Color
    public var launchSurfaceMid: Color
    public var darkSurfaceAlt: Color

    public init(
        ink: Color = AVBrandColor.ink,
        accent: Color = AVBrandColor.accentBase,
        canvas: Color = AVBrandColor.canvas,
        launchSurfaceStart: Color = AVBrandColor.launchSurfaceStart,
        launchSurfaceMid: Color = AVBrandColor.launchSurfaceMid,
        darkSurfaceAlt: Color = AVBrandColor.darkSurfaceAlt
    ) {
        self.ink = ink
        self.accent = accent
        self.canvas = canvas
        self.launchSurfaceStart = launchSurfaceStart
        self.launchSurfaceMid = launchSurfaceMid
        self.darkSurfaceAlt = darkSurfaceAlt
    }

    public static let standard = AVBrandPalette()
}

private struct AVBrandPaletteKey: EnvironmentKey {
    static let defaultValue = AVBrandPalette.standard
}

public extension EnvironmentValues {
    var avBrandPalette: AVBrandPalette {
        get { self[AVBrandPaletteKey.self] }
        set { self[AVBrandPaletteKey.self] = newValue }
    }
}

public extension View {
    func avBrandPalette(_ palette: AVBrandPalette) -> some View {
        environment(\.avBrandPalette, palette)
    }
}
