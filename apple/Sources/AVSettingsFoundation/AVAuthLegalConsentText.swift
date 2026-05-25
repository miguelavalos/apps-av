import AVBrandFoundation
import Foundation
import SwiftUI

public enum AVAuthLegalConsentText {
    public static func make(
        identity: AVAppIdentity,
        legalLinks: AVAppLegalLinks,
        textColor: Color = AVBrandColor.textSecondary
    ) -> AttributedString {
        let termsTitle = "terms"
        let privacyTitle = "privacy policy"
        let markdown = "By continuing, you agree to the \(linkedTitle(termsTitle, url: legalLinks.termsURL)) and \(linkedTitle(privacyTitle, url: legalLinks.privacyURL))."

        var consentText: AttributedString
        if let parsed = try? AttributedString(markdown: markdown) {
            consentText = parsed
        } else {
            consentText = AttributedString("By continuing, you agree to the \(identity.displayName) \(termsTitle) and \(privacyTitle).")
        }
        consentText.foregroundColor = textColor
        return consentText
    }

    private static func linkedTitle(_ title: String, url: URL?) -> String {
        guard let url else { return title }
        return "[\(title)](\(url.absoluteString))"
    }
}
