import SwiftUI

public struct AVSettingsInfoSectionItem: Identifiable, Hashable, Sendable {
    public var id: String
    public var systemImage: String
    public var title: String
    public var detail: String

    public init(
        id: String,
        systemImage: String,
        title: String,
        detail: String
    ) {
        self.id = id
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
    }
}

public struct AVSettingsInfoSection: View {
    private let title: String?
    private let subtitle: String?
    private let items: [AVSettingsInfoSectionItem]

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        items: [AVSettingsInfoSectionItem]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.items = items
    }

    public var body: some View {
        if let title, let subtitle {
            AVSettingsSectionCard(title: title, subtitle: subtitle) {
                rows
            }
        } else {
            AVSettingsCard {
                rows
            }
        }
    }

    private var rows: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                AVSettingsInfoRow(
                    systemImage: item.systemImage,
                    title: item.title,
                    detail: item.detail
                )
            }
        }
    }
}

public struct AVSettingsAccountOverviewSection: View {
    private let isSignedIn: Bool
    private let signedInTitle: String
    private let signedOutTitle: String
    private let detail: String
    private let items: [AVSettingsInfoSectionItem]

    public init(
        isSignedIn: Bool,
        signedInTitle: String = "Connected account",
        signedOutTitle: String = "Account required",
        detail: String,
        items: [AVSettingsInfoSectionItem]
    ) {
        self.isSignedIn = isSignedIn
        self.signedInTitle = signedInTitle
        self.signedOutTitle = signedOutTitle
        self.detail = detail
        self.items = items
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            AVSettingsStatusCard(
                systemImage: isSignedIn ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.exclamationmark",
                title: isSignedIn ? signedInTitle : signedOutTitle,
                detail: detail
            )

            AVSettingsInfoSection(items: items)
        }
    }
}

public struct AVSettingsSessionSection<SignedOutContent: View>: View {
    private let isSignedIn: Bool
    private let title: String
    private let signOutTitle: String
    private let signOutDetail: String
    private let onSignOut: () -> Void
    private let signedOutContent: SignedOutContent

    public init(
        isSignedIn: Bool,
        title: String = "Session",
        signOutTitle: String = "Sign out",
        signOutDetail: String,
        onSignOut: @escaping () -> Void,
        @ViewBuilder signedOutContent: () -> SignedOutContent
    ) {
        self.isSignedIn = isSignedIn
        self.title = title
        self.signOutTitle = signOutTitle
        self.signOutDetail = signOutDetail
        self.onSignOut = onSignOut
        self.signedOutContent = signedOutContent()
    }

    public var body: some View {
        if isSignedIn {
            AVSettingsGroupedActionList(title: title) {
                AVSettingsGroupedActionRow(
                    systemImage: "rectangle.portrait.and.arrow.right",
                    title: signOutTitle,
                    detail: signOutDetail,
                    action: onSignOut
                )
            }
        } else {
            AVSettingsCard {
                signedOutContent
            }
        }
    }
}
