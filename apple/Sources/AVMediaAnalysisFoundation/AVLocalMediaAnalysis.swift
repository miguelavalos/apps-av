import CoreGraphics
import Foundation
import ImageIO
import Vision

public enum AVLocalMediaKind: String, Sendable {
    case photo
    case video
    case unknown
}

public enum AVLocalMediaOrientation: String, Sendable {
    case portrait
    case landscape
    case square
    case unknown
}

public enum AVLocalMediaSceneRole: String, Sendable {
    case people
    case group
    case scenery
    case detail
    case video
    case screenshot
    case unknown
}

public struct AVLocalMediaInput: Sendable {
    public var data: Data
    public var filename: String
    public var contentType: String
    public var kind: AVLocalMediaKind
    public var capturedAt: Date?
    public var pixelWidth: Int?
    public var pixelHeight: Int?

    public init(
        data: Data,
        filename: String,
        contentType: String,
        kind: AVLocalMediaKind,
        capturedAt: Date? = nil,
        pixelWidth: Int? = nil,
        pixelHeight: Int? = nil
    ) {
        self.data = data
        self.filename = filename
        self.contentType = contentType
        self.kind = kind
        self.capturedAt = capturedAt
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
    }
}

public struct AVLocalMediaAnalysis: Equatable, Sendable {
    public var faceCount: Int
    public var hasPeople: Bool
    public var brightnessScore: Double
    public var sharpnessScore: Double
    public var qualityScore: Double
    public var isLikelyScreenshot: Bool
    public var orientation: AVLocalMediaOrientation
    public var sceneRole: AVLocalMediaSceneRole
    public var pixelWidth: Int?
    public var pixelHeight: Int?

    public init(
        faceCount: Int = 0,
        hasPeople: Bool = false,
        brightnessScore: Double = 0.5,
        sharpnessScore: Double = 0.5,
        qualityScore: Double = 0.5,
        isLikelyScreenshot: Bool = false,
        orientation: AVLocalMediaOrientation = .unknown,
        sceneRole: AVLocalMediaSceneRole = .unknown,
        pixelWidth: Int? = nil,
        pixelHeight: Int? = nil
    ) {
        self.faceCount = faceCount
        self.hasPeople = hasPeople
        self.brightnessScore = brightnessScore
        self.sharpnessScore = sharpnessScore
        self.qualityScore = qualityScore
        self.isLikelyScreenshot = isLikelyScreenshot
        self.orientation = orientation
        self.sceneRole = sceneRole
        self.pixelWidth = pixelWidth
        self.pixelHeight = pixelHeight
    }
}

public protocol AVLocalMediaAnalyzing: Sendable {
    func analyze(_ input: AVLocalMediaInput) async -> AVLocalMediaAnalysis
}

public struct AVVisionLocalMediaAnalyzer: AVLocalMediaAnalyzing {
    public init() {}

    public func analyze(_ input: AVLocalMediaInput) async -> AVLocalMediaAnalysis {
        guard input.kind == .photo,
              let imageSource = CGImageSourceCreateWithData(input.data as CFData, nil),
              let image = Self.thumbnailImage(from: imageSource) else {
            return AVLocalMediaAnalysis(
                sceneRole: input.kind == .video ? .video : .unknown,
                pixelWidth: input.pixelWidth,
                pixelHeight: input.pixelHeight
            )
        }

        let pixelWidth = input.pixelWidth ?? image.width
        let pixelHeight = input.pixelHeight ?? image.height
        let orientation = Self.orientation(width: pixelWidth, height: pixelHeight)
        let isLikelyScreenshot = Self.isLikelyScreenshot(
            filename: input.filename,
            width: pixelWidth,
            height: pixelHeight
        )
        let faceCount = Self.detectFaceCount(in: image)
        let quality = Self.qualityScores(for: image)
        let role = Self.sceneRole(
            faceCount: faceCount,
            orientation: orientation,
            isLikelyScreenshot: isLikelyScreenshot,
            kind: input.kind
        )

        return AVLocalMediaAnalysis(
            faceCount: faceCount,
            hasPeople: faceCount > 0,
            brightnessScore: quality.brightness,
            sharpnessScore: quality.sharpness,
            qualityScore: quality.overall,
            isLikelyScreenshot: isLikelyScreenshot,
            orientation: orientation,
            sceneRole: role,
            pixelWidth: pixelWidth,
            pixelHeight: pixelHeight
        )
    }

    private static func thumbnailImage(from source: CGImageSource) -> CGImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: 512
        ]
        return CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
    }

    private static func detectFaceCount(in image: CGImage) -> Int {
        let request = VNDetectFaceRectanglesRequest()
        let handler = VNImageRequestHandler(cgImage: image, options: [:])

        do {
            try handler.perform([request])
            return request.results?.count ?? 0
        } catch {
            return 0
        }
    }

    private static func orientation(width: Int, height: Int) -> AVLocalMediaOrientation {
        guard width > 0, height > 0 else { return .unknown }
        let ratio = Double(width) / Double(height)
        if ratio > 1.12 { return .landscape }
        if ratio < 0.88 { return .portrait }
        return .square
    }

    private static func isLikelyScreenshot(filename: String, width: Int, height: Int) -> Bool {
        let lowercasedName = filename.lowercased()
        if lowercasedName.contains("screenshot") || lowercasedName.contains("screen shot") {
            return true
        }

        let dimensions = Set([width, height])
        let knownScreenEdges: Set<Int> = [1170, 1179, 1206, 1284, 1290, 1320, 2556, 2532, 2622, 2688, 2778, 2796, 2868]
        return !dimensions.isDisjoint(with: knownScreenEdges)
    }

    private static func sceneRole(
        faceCount: Int,
        orientation: AVLocalMediaOrientation,
        isLikelyScreenshot: Bool,
        kind: AVLocalMediaKind
    ) -> AVLocalMediaSceneRole {
        if kind == .video { return .video }
        if isLikelyScreenshot { return .screenshot }
        if faceCount >= 3 { return .group }
        if faceCount > 0 { return .people }
        if orientation == .landscape { return .scenery }
        return .detail
    }

    private static func qualityScores(for image: CGImage) -> (brightness: Double, sharpness: Double, overall: Double) {
        let width = 32
        let height = 32
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        guard let context = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return (0.5, 0.5, 0.5)
        }

        context.interpolationQuality = .low
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

        var luminance = [Double](repeating: 0, count: width * height)
        var total = 0.0
        for index in 0..<(width * height) {
            let offset = index * 4
            let red = Double(pixels[offset]) / 255.0
            let green = Double(pixels[offset + 1]) / 255.0
            let blue = Double(pixels[offset + 2]) / 255.0
            let value = 0.2126 * red + 0.7152 * green + 0.0722 * blue
            luminance[index] = value
            total += value
        }

        let brightness = total / Double(width * height)
        var edgeTotal = 0.0
        for y in 1..<height {
            for x in 1..<width {
                let index = y * width + x
                edgeTotal += abs(luminance[index] - luminance[index - 1])
                edgeTotal += abs(luminance[index] - luminance[index - width])
            }
        }

        let edgeAverage = edgeTotal / Double((width - 1) * (height - 1) * 2)
        let sharpness = min(max(edgeAverage * 6.0, 0), 1)
        let exposurePenalty = abs(brightness - 0.52) * 1.4
        let overall = min(max((0.62 * sharpness) + (0.38 * (1 - exposurePenalty)), 0), 1)

        return (brightness, sharpness, overall)
    }
}
