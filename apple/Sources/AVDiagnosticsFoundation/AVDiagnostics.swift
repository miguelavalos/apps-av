import Foundation

#if canImport(Sentry)
import Sentry
#endif

public enum AVDiagnosticsEnvironment: String, Sendable {
    case debug
    case testflight
    case production
    case preview
}

public struct AVDiagnosticsConfiguration: Sendable {
    public let dsn: String
    public let environment: AVDiagnosticsEnvironment
    public let releaseName: String?
    public let tracesSampleRate: Double
    public let isEnabled: Bool

    public init(
        dsn: String,
        environment: AVDiagnosticsEnvironment,
        releaseName: String? = nil,
        tracesSampleRate: Double = 0,
        isEnabled: Bool
    ) {
        self.dsn = dsn.trimmingCharacters(in: .whitespacesAndNewlines)
        self.environment = environment
        self.releaseName = releaseName
        self.tracesSampleRate = tracesSampleRate
        self.isEnabled = isEnabled
    }

    public var shouldStartProvider: Bool {
        isEnabled && !dsn.isEmpty
    }
}

public struct AVDiagnosticsContext: Sendable {
    public let feature: String
    public let code: String?
    public let data: [String: String]

    public init(feature: String, code: String? = nil, data: [String: String] = [:]) {
        self.feature = feature
        self.code = code
        self.data = data
    }
}

public struct AVDiagnosticsBreadcrumb: Sendable {
    public let category: String
    public let message: String
    public let data: [String: String]

    public init(category: String, message: String, data: [String: String] = [:]) {
        self.category = category
        self.message = message
        self.data = data
    }
}

public struct AVDiagnosticsUserContext: Sendable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

public enum AVDiagnostics {
    private static let forbiddenKeyFragments = [
        "token",
        "authorization",
        "auth",
        "email",
        "mail",
        "name",
        "body",
        "payload",
        "receipt",
        "url",
        "filename",
        "file_name",
        "filepath",
        "file_path"
    ]

    private static let maxValueLength = 160

    public static func configure(_ configuration: AVDiagnosticsConfiguration) {
        guard configuration.shouldStartProvider else { return }

        #if canImport(Sentry)
        SentrySDK.start { options in
            options.dsn = configuration.dsn
            options.environment = configuration.environment.rawValue
            options.tracesSampleRate = NSNumber(value: max(0, min(configuration.tracesSampleRate, 1)))
            if let releaseName = configuration.releaseName, !releaseName.isEmpty {
                options.releaseName = releaseName
            }
        }
        #endif
    }

    public static func capture(error: Error, context: AVDiagnosticsContext) {
        #if canImport(Sentry)
        SentrySDK.capture(error: error) { scope in
            scope.setTag(value: sanitizedValue(context.feature), key: "feature")
            if let code = context.code {
                scope.setTag(value: sanitizedValue(code), key: "error_code")
            }
            let sanitizedData = sanitized(context.data)
            if !sanitizedData.isEmpty {
                scope.setContext(value: sanitizedData, key: "av_context")
            }
        }
        #endif
    }

    public static func addBreadcrumb(_ breadcrumb: AVDiagnosticsBreadcrumb) {
        #if canImport(Sentry)
        let sentryBreadcrumb = Breadcrumb()
        sentryBreadcrumb.category = sanitizedValue(breadcrumb.category)
        sentryBreadcrumb.message = sanitizedValue(breadcrumb.message)
        sentryBreadcrumb.level = .info
        sentryBreadcrumb.data = sanitized(breadcrumb.data)
        SentrySDK.addBreadcrumb(sentryBreadcrumb)
        #endif
    }

    public static func setUserContext(_ userContext: AVDiagnosticsUserContext?) {
        #if canImport(Sentry)
        SentrySDK.configureScope { scope in
            guard let userContext, !userContext.id.isEmpty else {
                scope.setUser(nil)
                return
            }
            let user = User()
            user.userId = sanitizedValue(userContext.id)
            scope.setUser(user)
        }
        #endif
    }

    public static func clearUserContext() {
        setUserContext(nil)
    }

    private static func sanitized(_ data: [String: String]) -> [String: String] {
        data.reduce(into: [:]) { result, entry in
            let key = entry.key.trimmingCharacters(in: .whitespacesAndNewlines)
            guard isAllowedKey(key) else { return }
            result[key] = sanitizedValue(entry.value)
        }
    }

    private static func isAllowedKey(_ key: String) -> Bool {
        guard !key.isEmpty else { return false }
        let lowercasedKey = key.lowercased()
        return !forbiddenKeyFragments.contains { lowercasedKey.contains($0) }
    }

    private static func sanitizedValue(_ value: String) -> String {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedValue.count > maxValueLength else { return trimmedValue }
        return String(trimmedValue.prefix(maxValueLength))
    }
}
