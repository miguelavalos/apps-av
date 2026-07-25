import CoreGraphics

public struct AVAppShellFooterConfiguration: Sendable {
    public var backdropHeight: CGFloat
    public var playerTabSpacing: CGFloat
    public var showsBackdrop: Bool

    public init(
        backdropHeight: CGFloat,
        playerTabSpacing: CGFloat = 10,
        showsBackdrop: Bool = true
    ) {
        self.backdropHeight = backdropHeight
        self.playerTabSpacing = playerTabSpacing
        self.showsBackdrop = showsBackdrop
    }

    public static let contentOnly = AVAppShellFooterConfiguration(
        backdropHeight: 156,
        playerTabSpacing: 10
    )

    public static let compact = AVAppShellFooterConfiguration(
        backdropHeight: 142,
        playerTabSpacing: 10
    )

    /// A footer-only presentation for embedding the shared controls over an
    /// independently rendered app surface. The capsules keep their native
    /// material while the area around them remains transparent.
    public static let floating = AVAppShellFooterConfiguration(
        backdropHeight: 104,
        playerTabSpacing: 10,
        showsBackdrop: false
    )
}
