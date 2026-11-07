import SwiftUI

/// Maps a fixed point size to the system text style whose default size is closest, so a
/// view styled at that size follows the text size chosen in Settings (Dynamic Type) along
/// that style's curve. At the default text size the font stays exactly `size` points.
public enum AVTypeScale {
    public static func textStyle(for size: CGFloat) -> Font.TextStyle {
        switch size {
        case ..<11.5:
            .caption2 // 11
        case ..<12.5:
            .caption // 12
        case ..<14.5:
            .footnote // 13
        case ..<15.5:
            .subheadline // 15
        case ..<16.5:
            .callout // 16
        case ..<18.5:
            .body // 17
        case ..<21:
            .title3 // 20
        case ..<25:
            .title2 // 22
        case ..<31:
            .title // 28
        default:
            .largeTitle // 34
        }
    }
}

/// A font size that is `wrappedValue` points at the default text size and grows or shrinks
/// with the text size chosen in Settings, including the accessibility sizes, along the curve
/// of the closest system text style (see `AVTypeScale`) or of `relativeTo`.
///
/// Use it where a view needs the number itself, for an icon drawn with
/// `.font(.system(size:))` whose circle or box must grow with it. The projected value
/// (`$name`) is the number of points the size has gained, so a box that holds the icon can
/// grow by the same amount and keep its padding at every size: `.frame(width: 28 + $iconSize)`.
@propertyWrapper
public struct AVScaledFontSize: DynamicProperty {
    @ScaledMetric private var scaledValue: CGFloat
    private let baseValue: CGFloat

    public init(wrappedValue: CGFloat, relativeTo textStyle: Font.TextStyle? = nil) {
        _scaledValue = ScaledMetric(
            wrappedValue: wrappedValue,
            relativeTo: textStyle ?? AVTypeScale.textStyle(for: wrappedValue)
        )
        baseValue = wrappedValue
    }

    public var wrappedValue: CGFloat {
        scaledValue
    }

    /// The points gained over the default text size; zero at the default size.
    public var projectedValue: CGFloat {
        scaledValue - baseValue
    }
}

/// `Font.system(size:weight:design:)` does not scale with Dynamic Type and SwiftUI has no
/// `relativeTo:` variant for system fonts, so the size is scaled with `ScaledMetric`, which
/// reads the view's `dynamicTypeSize` (and therefore respects a `.dynamicTypeSize(...)` cap
/// placed on a parent). On macOS, which has no Dynamic Type, the size is left as it is.
struct AVScaledSystemFont: ViewModifier {
    @AVScaledFontSize private var size: CGFloat
    private let weight: Font.Weight
    private let design: Font.Design

    init(size: CGFloat, weight: Font.Weight, design: Font.Design, relativeTo textStyle: Font.TextStyle?) {
        _size = AVScaledFontSize(wrappedValue: size, relativeTo: textStyle)
        self.weight = weight
        self.design = design
    }

    func body(content: Content) -> some View {
        content.font(.system(size: size, weight: weight, design: design))
    }
}

public extension View {
    /// A system font that is `size` points at the default text size and grows or shrinks with
    /// the text size chosen in Settings, including the accessibility sizes.
    ///
    /// `textStyle` picks the scaling curve; by default it is the system style whose default
    /// size is closest to `size` (see `AVTypeScale`). Use it where `.font(.system(size:))`
    /// was used before: the rendering at the default size is unchanged.
    func avScaledFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        relativeTo textStyle: Font.TextStyle? = nil
    ) -> some View {
        modifier(AVScaledSystemFont(size: size, weight: weight, design: design, relativeTo: textStyle))
    }
}
