@testable import AVSettingsFoundation
import Testing

@Suite("AVInitialAppLanguage")
struct AVInitialAppLanguageTests {
    @Test("Every suite locale resolves from exact and regional device tags", arguments: [
        ("en", "en-US"),
        ("es", "es-ES"),
        ("ca", "ca_ES"),
        ("fr", "fr-CA"),
        ("de", "de-DE")
    ])
    func resolvesSupportedDeviceLanguages(expected: String, preferred: String) {
        #expect(AVInitialAppLanguage.resolve(
            storedLanguageCode: nil,
            preferredLanguages: [preferred]
        ) == expected)
    }

    @Test("A valid stored choice wins over the current device language")
    func storedChoiceWins() {
        #expect(AVInitialAppLanguage.resolve(
            storedLanguageCode: "fr",
            preferredLanguages: ["es-ES"]
        ) == "fr")
    }

    @Test("An invalid stored value can be repaired from the primary device language")
    func invalidStoredChoiceUsesDeviceLanguage() {
        #expect(AVInitialAppLanguage.resolve(
            storedLanguageCode: "unknown",
            preferredLanguages: ["de-DE"]
        ) == "de")
    }

    @Test("Unsupported or missing primary device language falls back to English", arguments: [
        ["it-IT", "es-ES"],
        [],
        [""],
        ["-es"],
        ["123"]
    ])
    func unsupportedPrimaryFallsBackToEnglish(preferredLanguages: [String]) {
        #expect(AVInitialAppLanguage.resolve(
            storedLanguageCode: nil,
            preferredLanguages: preferredLanguages
        ) == "en")
    }

    @Test("Prefix lookalikes are not treated as supported locales", arguments: [
        "catalog",
        "desktop",
        "english",
        "esoteric",
        "french"
    ])
    func rejectsPrefixLookalikes(rawValue: String) {
        #expect(AVInitialAppLanguage.resolve(
            storedLanguageCode: rawValue,
            preferredLanguages: []
        ) == "en")
    }

    @Test("The resolver canonicalizes whitespace, case, scripts, and separators")
    func canonicalizesLanguageTags() {
        #expect(AVInitialAppLanguage.normalizedLanguageCode(from: " ES_latn_ES ") == "es")
        #expect(AVInitialAppLanguage.normalizedLanguageCode(from: "ca-ES") == "ca")
        #expect(AVInitialAppLanguage.normalizedLanguageCode(from: nil) == nil)
    }
}
