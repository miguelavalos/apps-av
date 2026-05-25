import AVBrandFoundation
import SwiftUI

public struct AVSettingsConfiguredInfoSection: Identifiable, Hashable, Sendable {
    public var id: String
    public var title: String
    public var subtitle: String
    public var items: [AVSettingsInfoSectionItem]

    public init(
        id: String,
        title: String,
        subtitle: String,
        items: [AVSettingsInfoSectionItem]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.items = items
    }
}

public struct AVSettingsConfiguredHelpLegalContent: Sendable {
    public var title: String
    public var subtitle: String
    public var openSourceTitle: String
    public var openSourceDetail: String
    public var legalLinks: AVAppLegalLinks
    public var supportDetail: String
    public var privacyDetail: String
    public var termsDetail: String
    public var accountDeletionDetail: String

    public init(
        title: String,
        subtitle: String,
        openSourceTitle: String,
        openSourceDetail: String,
        legalLinks: AVAppLegalLinks,
        supportDetail: String,
        privacyDetail: String,
        termsDetail: String,
        accountDeletionDetail: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.openSourceTitle = openSourceTitle
        self.openSourceDetail = openSourceDetail
        self.legalLinks = legalLinks
        self.supportDetail = supportDetail
        self.privacyDetail = privacyDetail
        self.termsDetail = termsDetail
        self.accountDeletionDetail = accountDeletionDetail
    }

    public init(
        identity: AVAppIdentity,
        legalLinks: AVAppLegalLinks,
        title: String = "Help",
        subtitle: String? = nil,
        openSourceTitle: String = "Built on Apps AV",
        openSourceDetail: String? = nil,
        supportDetail: String? = nil,
        privacyDetail: String? = nil,
        termsDetail: String? = nil,
        accountDeletionDetail: String? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle ?? "Support, policies, and account safety for \(identity.shortName).",
            openSourceTitle: openSourceTitle,
            openSourceDetail: openSourceDetail ?? "\(identity.shortName) shares account, shell, settings, onboarding, and Avi foundations with Apps AV products.",
            legalLinks: legalLinks,
            supportDetail: supportDetail ?? "Open \(identity.shortName) support.",
            privacyDetail: privacyDetail ?? "Review how \(identity.shortName) handles account, product, and usage data.",
            termsDetail: termsDetail ?? "Review the terms that apply to \(identity.shortName).",
            accountDeletionDetail: accountDeletionDetail ?? "Open \(identity.accountName) account deletion."
        )
    }
}

public struct AVSettingsConfiguredSettingsContent: View {
    private let sections: [AVSettingsConfiguredInfoSection]
    private let helpLegalContent: AVSettingsConfiguredHelpLegalContent?
    private let openURL: (URL) -> Void

    public init(
        sections: [AVSettingsConfiguredInfoSection],
        helpLegalContent: AVSettingsConfiguredHelpLegalContent? = nil,
        openURL: @escaping (URL) -> Void
    ) {
        self.sections = sections
        self.helpLegalContent = helpLegalContent
        self.openURL = openURL
    }

    public var body: some View {
        ForEach(sections) { section in
            AVSettingsInfoSection(
                title: section.title,
                subtitle: section.subtitle,
                items: section.items
            )
        }

        if let helpLegalContent {
            AVSettingsHelpLegalSection(
                title: helpLegalContent.title,
                subtitle: helpLegalContent.subtitle,
                openSourceTitle: helpLegalContent.openSourceTitle,
                openSourceDetail: helpLegalContent.openSourceDetail,
                legalLinks: helpLegalContent.legalLinks,
                supportDetail: helpLegalContent.supportDetail,
                privacyDetail: helpLegalContent.privacyDetail,
                termsDetail: helpLegalContent.termsDetail,
                accountDeletionDetail: helpLegalContent.accountDeletionDetail,
                openURL: openURL
            )
        }
    }
}

public struct AVSettingsConfiguredAccountContent<SignedOutContent: View>: View {
    private let isSignedIn: Bool
    private let signedInTitle: String
    private let signedOutTitle: String
    private let detail: String
    private let overviewItems: [AVSettingsInfoSectionItem]
    private let sections: [AVSettingsConfiguredInfoSection]
    private let signOutDetail: String
    private let onSignOut: () -> Void
    private let signedOutContent: SignedOutContent

    public init(
        isSignedIn: Bool,
        signedInTitle: String = "Connected account",
        signedOutTitle: String = "Account required",
        detail: String,
        overviewItems: [AVSettingsInfoSectionItem],
        sections: [AVSettingsConfiguredInfoSection] = [],
        signOutDetail: String,
        onSignOut: @escaping () -> Void,
        @ViewBuilder signedOutContent: () -> SignedOutContent
    ) {
        self.isSignedIn = isSignedIn
        self.signedInTitle = signedInTitle
        self.signedOutTitle = signedOutTitle
        self.detail = detail
        self.overviewItems = overviewItems
        self.sections = sections
        self.signOutDetail = signOutDetail
        self.onSignOut = onSignOut
        self.signedOutContent = signedOutContent()
    }

    public var body: some View {
        AVSettingsAccountOverviewSection(
            isSignedIn: isSignedIn,
            signedInTitle: signedInTitle,
            signedOutTitle: signedOutTitle,
            detail: detail,
            items: overviewItems
        )

        ForEach(sections) { section in
            AVSettingsInfoSection(
                title: section.title,
                subtitle: section.subtitle,
                items: section.items
            )
        }

        AVSettingsSessionSection(
            isSignedIn: isSignedIn,
            signOutDetail: signOutDetail,
            onSignOut: onSignOut
        ) {
            signedOutContent
        }
    }
}
