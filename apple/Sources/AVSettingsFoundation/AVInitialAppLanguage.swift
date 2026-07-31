import Foundation

/// Resolves the one-time initial interface language for Apps AV products.
///
/// A valid stored choice always wins. Without one, only the device's primary
/// preferred language is considered. Products should persist the returned
/// canonical code so later device-language changes never replace a user's
/// initial or manual choice.
public enum AVInitialAppLanguage {
    public static let suiteSupportedLanguageCodes: Set<String> = [
        "ca",
        "de",
        "en",
        "es",
        "fr"
    ]

    public static func resolve(
        storedLanguageCode: String?,
        preferredLanguages: [String],
        supportedLanguageCodes: Set<String> = suiteSupportedLanguageCodes,
        fallbackLanguageCode: String = "en"
    ) -> String {
        let supported = Set(supportedLanguageCodes.compactMap(normalizedLanguageCode))

        if let stored = normalizedLanguageCode(from: storedLanguageCode),
           supported.contains(stored) {
            return stored
        }

        if let primaryPreferredLanguage = preferredLanguages.first,
           let preferred = normalizedLanguageCode(from: primaryPreferredLanguage),
           supported.contains(preferred) {
            return preferred
        }

        if let fallback = normalizedLanguageCode(from: fallbackLanguageCode),
           supported.contains(fallback) {
            return fallback
        }

        if supported.contains("en") {
            return "en"
        }

        return supported.sorted().first ?? "en"
    }

    public static func normalizedLanguageCode(from rawValue: String?) -> String? {
        guard let rawValue else { return nil }

        let normalizedSeparators = rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "_", with: "-")
        guard let primarySubtag = normalizedSeparators
            .split(separator: "-", omittingEmptySubsequences: false)
            .first,
            !primarySubtag.isEmpty
        else {
            return nil
        }

        let languageCode = primarySubtag.lowercased()
        guard languageCode.unicodeScalars.allSatisfy(CharacterSet.lowercaseLetters.contains) else {
            return nil
        }

        return languageCode
    }
}
