import Foundation

public enum AVExternalSearchEngine: String, CaseIterable, Identifiable, Sendable {
    case google
    case duckDuckGo = "duckduckgo"
    case bing

    public var id: String { rawValue }

    public static func resolved(from rawValue: String?) -> AVExternalSearchEngine {
        guard let rawValue else { return .google }
        return AVExternalSearchEngine(rawValue: rawValue) ?? .google
    }
}

public enum AVExternalWebOpenMode: String, CaseIterable, Identifiable, Sendable {
    case inApp
    case system

    public var id: String { rawValue }

    public static func resolved(from rawValue: String?) -> AVExternalWebOpenMode {
        guard let rawValue else { return .inApp }
        return AVExternalWebOpenMode(rawValue: rawValue) ?? .inApp
    }
}

public enum AVExternalSearchURL {
    public static func webSearch(query: String, engine: AVExternalSearchEngine = .google) -> URL? {
        let normalizedQuery = normalizedQuery(query)
        guard normalizedQuery.isEmpty == false else { return nil }

        switch engine {
        case .google:
            return url(base: "https://www.google.com/search", queryItemName: "q", query: normalizedQuery)
        case .duckDuckGo:
            return url(base: "https://duckduckgo.com/", queryItemName: "q", query: normalizedQuery)
        case .bing:
            return url(base: "https://www.bing.com/search", queryItemName: "q", query: normalizedQuery)
        }
    }

    public static func imdbSearch(query: String) -> URL? {
        let normalizedQuery = normalizedQuery(query)
        guard normalizedQuery.isEmpty == false else { return nil }
        return url(base: "https://www.imdb.com/find/", queryItemName: "q", query: normalizedQuery)
    }

    public static func normalizedQuery(_ query: String) -> String {
        query
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
    }

    private static func url(base: String, queryItemName: String, query: String) -> URL? {
        var components = URLComponents(string: base)
        components?.queryItems = [
            URLQueryItem(name: queryItemName, value: query)
        ]
        return components?.url
    }
}
