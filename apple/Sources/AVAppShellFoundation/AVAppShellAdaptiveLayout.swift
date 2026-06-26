import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public enum AVAppShellLayoutClass {
    case compact
    case regular
    case expansive

    public init(width: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?, isPad: Bool) {
        if !isPad && horizontalSizeClass == .compact {
            self = .compact
        } else if width < 700 {
            self = .compact
        } else if width < 1100 {
            self = .regular
        } else {
            self = .expansive
        }
    }

    public var isTabletLike: Bool {
        self != .compact
    }

    public var readableContentWidth: CGFloat? {
        switch self {
        case .compact:
            nil
        case .regular:
            760
        case .expansive:
            1080
        }
    }

    public var formContentWidth: CGFloat? {
        switch self {
        case .compact:
            nil
        case .regular:
            620
        case .expansive:
            680
        }
    }
}

public struct AVAppShellLayoutContext {
    public let width: CGFloat
    public let horizontalSizeClass: UserInterfaceSizeClass?
    public let isPad: Bool
    public let layoutClass: AVAppShellLayoutClass

    public init(width: CGFloat, horizontalSizeClass: UserInterfaceSizeClass?, isPad: Bool) {
        self.width = width
        self.horizontalSizeClass = horizontalSizeClass
        self.isPad = isPad
        self.layoutClass = AVAppShellLayoutClass(width: width, horizontalSizeClass: horizontalSizeClass, isPad: isPad)
    }

    public var isTabletLike: Bool {
        layoutClass.isTabletLike
    }

    public var readableContentWidth: CGFloat? {
        layoutClass.readableContentWidth
    }

    public var formContentWidth: CGFloat? {
        layoutClass.formContentWidth
    }
}

public struct AVAppShellAdaptiveLayoutReader<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private let content: (AVAppShellLayoutContext) -> Content

    public init(@ViewBuilder content: @escaping (AVAppShellLayoutContext) -> Content) {
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            content(
                AVAppShellLayoutContext(
                    width: proxy.size.width,
                    horizontalSizeClass: horizontalSizeClass,
                    isPad: currentDeviceIsPad
                )
            )
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }

    private var currentDeviceIsPad: Bool {
        #if os(iOS)
        UIDevice.current.userInterfaceIdiom == .pad
        #else
        false
        #endif
    }
}

private struct AVAppShellReadableContentModifier: ViewModifier {
    let maxWidth: CGFloat?
    let alignment: Alignment

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth ?? .infinity, alignment: alignment)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

public extension View {
    func avAppShellReadableContent(maxWidth: CGFloat?, alignment: Alignment = .topLeading) -> some View {
        modifier(AVAppShellReadableContentModifier(maxWidth: maxWidth, alignment: alignment))
    }
}
