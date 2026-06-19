import Testing
import Foundation
@testable import AVExternalLinkFoundation

@Test func externalSearchEngineResolvesUnknownValuesToGoogle() {
    #expect(AVExternalSearchEngine.resolved(from: nil) == .google)
    #expect(AVExternalSearchEngine.resolved(from: "unknown") == .google)
    #expect(AVExternalSearchEngine.resolved(from: "duckduckgo") == .duckDuckGo)
}

@Test func externalWebOpenModeDefaultsToInApp() {
    #expect(AVExternalWebOpenMode.resolved(from: nil) == .inApp)
    #expect(AVExternalWebOpenMode.resolved(from: "system") == .system)
    #expect(AVExternalWebOpenMode.resolved(from: "other") == .inApp)
}

@Test func webSearchBuildsEngineUrls() {
    #expect(AVExternalSearchURL.webSearch(query: "One   Piece 1999", engine: .google)?.absoluteString == "https://www.google.com/search?q=One%20Piece%201999")
    #expect(AVExternalSearchURL.webSearch(query: "One Piece", engine: .duckDuckGo)?.absoluteString == "https://duckduckgo.com/?q=One%20Piece")
    #expect(AVExternalSearchURL.webSearch(query: "One Piece", engine: .bing)?.absoluteString == "https://www.bing.com/search?q=One%20Piece")
}

@Test func imdbSearchBuildsFindUrl() {
    #expect(AVExternalSearchURL.imdbSearch(query: "One Piece 1999")?.absoluteString == "https://www.imdb.com/find/?q=One%20Piece%201999")
    #expect(AVExternalSearchURL.imdbSearch(query: "   ") == nil)
}
