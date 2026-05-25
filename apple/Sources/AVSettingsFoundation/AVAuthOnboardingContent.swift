import AVBrandFoundation
import SwiftUI

public struct AVAuthOnboardingContent: Sendable {
    public var title: String
    public var subtitle: String
    public var primaryTitle: String
    public var secondaryTitle: String?
    public var brandAccessibilityLabel: String
    public var backgroundStart: Color
    public var backgroundMid: Color
    public var backgroundEnd: Color

    public init(
        title: String,
        subtitle: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        brandAccessibilityLabel: String,
        backgroundStart: Color = AVBrandColor.launchSurfaceStart,
        backgroundMid: Color = AVBrandColor.neutral50,
        backgroundEnd: Color = AVBrandColor.neutral100
    ) {
        self.title = title
        self.subtitle = subtitle
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.brandAccessibilityLabel = brandAccessibilityLabel
        self.backgroundStart = backgroundStart
        self.backgroundMid = backgroundMid
        self.backgroundEnd = backgroundEnd
    }

    public init(
        identity: AVAppIdentity,
        title: String,
        subtitle: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        backgroundStart: Color = AVBrandColor.launchSurfaceStart,
        backgroundMid: Color = AVBrandColor.neutral50,
        backgroundEnd: Color = AVBrandColor.neutral100
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle,
            brandAccessibilityLabel: identity.displayName,
            backgroundStart: backgroundStart,
            backgroundMid: backgroundMid,
            backgroundEnd: backgroundEnd
        )
    }
}
