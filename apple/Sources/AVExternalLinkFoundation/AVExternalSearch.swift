import Foundation

public enum AVExternalSearchEngine: String, CaseIterable, Identifiable, Sendable {
    case google
    case bing
    case yahoo
    case duckDuckGo = "duckduckgo"
    case yandex
    case baidu
    case brave
    case ecosia
    case startpage
    case qwant

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
        case .bing:
            return url(base: "https://www.bing.com/search", queryItemName: "q", query: normalizedQuery)
        case .yahoo:
            return url(base: "https://search.yahoo.com/search", queryItemName: "p", query: normalizedQuery)
        case .duckDuckGo:
            return url(base: "https://duckduckgo.com/", queryItemName: "q", query: normalizedQuery)
        case .yandex:
            return url(base: "https://yandex.com/search/", queryItemName: "text", query: normalizedQuery)
        case .baidu:
            return url(base: "https://www.baidu.com/s", queryItemName: "wd", query: normalizedQuery)
        case .brave:
            return url(base: "https://search.brave.com/search", queryItemName: "q", query: normalizedQuery)
        case .ecosia:
            return url(base: "https://www.ecosia.org/search", queryItemName: "q", query: normalizedQuery)
        case .startpage:
            return url(base: "https://www.startpage.com/sp/search", queryItemName: "query", query: normalizedQuery)
        case .qwant:
            return url(base: "https://www.qwant.com/", queryItemName: "q", query: normalizedQuery)
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
