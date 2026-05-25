import CoreGraphics

public struct AVAppShellFooterConfiguration: Sendable {
    public var backdropHeight: CGFloat
    public var playerTabSpacing: CGFloat

    public init(
        backdropHeight: CGFloat,
        playerTabSpacing: CGFloat = 10
    ) {
        self.backdropHeight = backdropHeight
        self.playerTabSpacing = playerTabSpacing
    }

    public static let contentOnly = AVAppShellFooterConfiguration(
        backdropHeight: 156,
        playerTabSpacing: 10
    )

    public static let compact = AVAppShellFooterConfiguration(
        backdropHeight: 142,
        playerTabSpacing: 10
    )
}
