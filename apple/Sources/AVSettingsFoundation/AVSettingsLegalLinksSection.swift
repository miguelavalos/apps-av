import AVBrandFoundation
import SwiftUI

public struct AVSettingsLegalLinksSection: View {
    private let title: String
    private let identity: AVAppIdentity
    private let legalLinks: AVAppLegalLinks
    private let openURL: (URL) -> Void

    public init(
        title: String = "Help",
        identity: AVAppIdentity,
        legalLinks: AVAppLegalLinks,
        openURL: @escaping (URL) -> Void
    ) {
        self.title = title
        self.identity = identity
        self.legalLinks = legalLinks
        self.openURL = openURL
    }

    public var body: some View {
        AVSettingsGroupedActionList(title: title) {
            if let supportURL = legalLinks.supportURL {
                AVSettingsGroupedActionRow(
                    systemImage: "questionmark.circle.fill",
                    title: "Support",
                    detail: "Open \(identity.shortName) support.",
                    showsDivider: nextLink(after: .support),
                    action: { openURL(supportURL) }
                )
            }

            if let privacyURL = legalLinks.privacyURL {
                AVSettingsGroupedActionRow(
                    systemImage: "hand.raised.fill",
                    title: "Privacy policy",
                    detail: "Review how \(identity.shortName) handles account and app data.",
                    showsDivider: nextLink(after: .privacy),
                    action: { openURL(privacyURL) }
                )
            }

            if let termsURL = legalLinks.termsURL {
                AVSettingsGroupedActionRow(
                    systemImage: "doc.text.fill",
                    title: "Terms",
                    detail: "Review the terms that apply to \(identity.shortName).",
                    showsDivider: nextLink(after: .terms),
                    action: { openURL(termsURL) }
                )
            }

            if let accountDeletionURL = legalLinks.accountDeletionURL {
                AVSettingsGroupedActionRow(
                    systemImage: "person.crop.circle.badge.xmark",
                    title: "Delete account",
                    detail: "Open \(identity.accountName) account deletion.",
                    action: { openURL(accountDeletionURL) }
                )
            }
        }
    }

    private func nextLink(after link: LegalLink) -> Bool {
        switch link {
        case .support:
            legalLinks.privacyURL != nil || legalLinks.termsURL != nil || legalLinks.accountDeletionURL != nil
        case .privacy:
            legalLinks.termsURL != nil || legalLinks.accountDeletionURL != nil
        case .terms:
            legalLinks.accountDeletionURL != nil
        }
    }
}

public struct AVSettingsLegalActionRows: View {
    private let legalLinks: AVAppLegalLinks
    private let supportTitle: String
    private let supportDetail: String
    private let privacyTitle: String
    private let privacyDetail: String
    private let termsTitle: String
    private let termsDetail: String
    private let accountDeletionTitle: String
    private let accountDeletionDetail: String
    private let openURL: (URL) -> Void

    public init(
        legalLinks: AVAppLegalLinks,
        supportTitle: String,
        supportDetail: String,
        privacyTitle: String,
        privacyDetail: String,
        termsTitle: String,
        termsDetail: String,
        accountDeletionTitle: String,
        accountDeletionDetail: String,
        openURL: @escaping (URL) -> Void
    ) {
        self.legalLinks = legalLinks
        self.supportTitle = supportTitle
        self.supportDetail = supportDetail
        self.privacyTitle = privacyTitle
        self.privacyDetail = privacyDetail
        self.termsTitle = termsTitle
        self.termsDetail = termsDetail
        self.accountDeletionTitle = accountDeletionTitle
        self.accountDeletionDetail = accountDeletionDetail
        self.openURL = openURL
    }

    public var body: some View {
        if let supportURL = legalLinks.supportURL {
            AVSettingsActionRow(
                systemImage: "questionmark.bubble",
                title: supportTitle,
                detail: supportDetail,
                action: { openURL(supportURL) }
            )
        }

        if let termsURL = legalLinks.termsURL {
            AVSettingsActionRow(
                systemImage: "doc.text",
                title: termsTitle,
                detail: termsDetail,
                action: { openURL(termsURL) }
            )
        }

        if let privacyURL = legalLinks.privacyURL {
            AVSettingsActionRow(
                systemImage: "hand.raised",
                title: privacyTitle,
                detail: privacyDetail,
                action: { openURL(privacyURL) }
            )
        }

        if let accountDeletionURL = legalLinks.accountDeletionURL {
            AVSettingsActionRow(
                systemImage: "person.crop.circle.badge.xmark",
                title: accountDeletionTitle,
                detail: accountDeletionDetail,
                action: { openURL(accountDeletionURL) }
            )
        }
    }
}

public struct AVSettingsHelpLegalSection: View {
    private let title: String
    private let subtitle: String
    private let openSourceTitle: String?
    private let openSourceDetail: String?
    private let sourceCodeURL: URL?
    private let sourceCodeTitle: String
    private let sourceCodeDetail: String
    private let legalLinks: AVAppLegalLinks
    private let supportTitle: String
    private let supportDetail: String
    private let privacyTitle: String
    private let privacyDetail: String
    private let termsTitle: String
    private let termsDetail: String
    private let accountDeletionTitle: String
    private let accountDeletionDetail: String
    private let openURL: (URL) -> Void

    public init(
        title: String,
        subtitle: String,
        openSourceTitle: String? = nil,
        openSourceDetail: String? = nil,
        sourceCodeURL: URL? = nil,
        sourceCodeTitle: String = "Source code",
        sourceCodeDetail: String = "Open the source code repository.",
        legalLinks: AVAppLegalLinks,
        supportTitle: String = "Support",
        supportDetail: String,
        privacyTitle: String = "Privacy policy",
        privacyDetail: String,
        termsTitle: String = "Terms",
        termsDetail: String,
        accountDeletionTitle: String = "Delete account",
        accountDeletionDetail: String,
        openURL: @escaping (URL) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.openSourceTitle = openSourceTitle
        self.openSourceDetail = openSourceDetail
        self.sourceCodeURL = sourceCodeURL
        self.sourceCodeTitle = sourceCodeTitle
        self.sourceCodeDetail = sourceCodeDetail
        self.legalLinks = legalLinks
        self.supportTitle = supportTitle
        self.supportDetail = supportDetail
        self.privacyTitle = privacyTitle
        self.privacyDetail = privacyDetail
        self.termsTitle = termsTitle
        self.termsDetail = termsDetail
        self.accountDeletionTitle = accountDeletionTitle
        self.accountDeletionDetail = accountDeletionDetail
        self.openURL = openURL
    }

    public var body: some View {
        AVSettingsSectionCard(title: title, subtitle: subtitle) {
            VStack(spacing: 12) {
                if let openSourceTitle, let openSourceDetail {
                    AVSettingsInfoRow(
                        systemImage: "chevron.left.forwardslash.chevron.right",
                        title: openSourceTitle,
                        detail: openSourceDetail
                    )
                }

                if let sourceCodeURL {
                    AVSettingsActionRow(
                        systemImage: "book.pages",
                        title: sourceCodeTitle,
                        detail: sourceCodeDetail,
                        action: { openURL(sourceCodeURL) }
                    )
                }

                AVSettingsLegalActionRows(
                    legalLinks: legalLinks,
                    supportTitle: supportTitle,
                    supportDetail: supportDetail,
                    privacyTitle: privacyTitle,
                    privacyDetail: privacyDetail,
                    termsTitle: termsTitle,
                    termsDetail: termsDetail,
                    accountDeletionTitle: accountDeletionTitle,
                    accountDeletionDetail: accountDeletionDetail,
                    openURL: openURL
                )
            }
        }
    }
}

private enum LegalLink {
    case support
    case privacy
    case terms
}
