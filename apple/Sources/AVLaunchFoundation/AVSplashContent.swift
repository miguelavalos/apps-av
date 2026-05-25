import AVBrandFoundation

public struct AVSplashContent: Hashable, Sendable {
    public var identity: AVAppIdentity
    public var tagline: String
    public var status: String

    public init(
        identity: AVAppIdentity,
        tagline: String,
        status: String? = nil
    ) {
        self.identity = identity
        self.tagline = tagline
        self.status = status ?? "Preparing \(identity.shortName)"
    }
}
