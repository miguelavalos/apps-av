import Foundation

public struct AVAppShellTab<ID: Hashable>: Identifiable {
    public let id: ID
    public let title: String
    public let systemImage: String
    public let accessibilityIdentifier: String

    public init(
        id: ID,
        title: String,
        systemImage: String,
        accessibilityIdentifier: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}
