import AVBrandFoundation
import SwiftUI

public struct AVSettingsMaintenanceAction<Target: Identifiable>: Identifiable {
    public var id: Target.ID { target.id }
    public var systemImage: String
    public var title: String
    public var detail: String
    public var target: Target

    public init(
        systemImage: String,
        title: String,
        detail: String,
        target: Target
    ) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.target = target
    }
}

public struct AVSettingsMaintenanceSheet<Target: Identifiable>: View {
    private let title: String
    private let subtitle: String
    private let closeTitle: String
    private let groupTitle: String
    private let actions: [AVSettingsMaintenanceAction<Target>]
    private let destructiveSectionTitle: String
    private let destructiveSystemImage: String
    private let destructiveTitle: String
    private let destructiveDetail: String
    private let destructiveTarget: Target
    private let backgroundStyle: AnyShapeStyle
    private let alertTitle: (Target) -> String
    private let alertMessage: (Target) -> String
    private let confirmTitle: (Target) -> String
    private let onConfirmTarget: (Target) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var pendingTarget: Target?

    public init(
        title: String,
        subtitle: String,
        closeTitle: String,
        groupTitle: String,
        actions: [AVSettingsMaintenanceAction<Target>],
        destructiveSectionTitle: String,
        destructiveSystemImage: String = "trash",
        destructiveTitle: String,
        destructiveDetail: String,
        destructiveTarget: Target,
        backgroundStyle: AnyShapeStyle = AnyShapeStyle(AVBrandColor.canvas),
        alertTitle: @escaping (Target) -> String,
        alertMessage: @escaping (Target) -> String,
        confirmTitle: @escaping (Target) -> String,
        onConfirmTarget: @escaping (Target) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.closeTitle = closeTitle
        self.groupTitle = groupTitle
        self.actions = actions
        self.destructiveSectionTitle = destructiveSectionTitle
        self.destructiveSystemImage = destructiveSystemImage
        self.destructiveTitle = destructiveTitle
        self.destructiveDetail = destructiveDetail
        self.destructiveTarget = destructiveTarget
        self.backgroundStyle = backgroundStyle
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.confirmTitle = confirmTitle
        self.onConfirmTarget = onConfirmTarget
    }

    public var body: some View {
        AVSettingsSheetScaffold(
            backgroundStyle: backgroundStyle,
            closeTitle: closeTitle,
            onClose: { dismiss() }
        ) {
            AVSettingsSheetHeader(title: title, subtitle: subtitle)

            AVSettingsGroupedActionList(title: groupTitle) {
                ForEach(Array(actions.enumerated()), id: \.element.id) { index, action in
                    AVSettingsGroupedActionRow(
                        systemImage: action.systemImage,
                        title: action.title,
                        detail: action.detail,
                        showsDivider: index < actions.count - 1
                    ) {
                        pendingTarget = action.target
                    }
                }
            }

            AVSettingsDestructiveActionCard(
                sectionTitle: destructiveSectionTitle,
                systemImage: destructiveSystemImage,
                title: destructiveTitle,
                detail: destructiveDetail
            ) {
                pendingTarget = destructiveTarget
            }
        }
        .alert(
            pendingTarget.map(alertTitle) ?? "",
            isPresented: pendingTargetIsPresented
        ) {
            Button(closeTitle, role: .cancel) {
                pendingTarget = nil
            }
            Button(pendingTarget.map(confirmTitle) ?? "", role: .destructive) {
                guard let pendingTarget else { return }
                onConfirmTarget(pendingTarget)
                self.pendingTarget = nil
                dismiss()
            }
        } message: {
            if let pendingTarget {
                Text(alertMessage(pendingTarget))
            }
        }
    }

    private var pendingTargetIsPresented: Binding<Bool> {
        Binding(
            get: { pendingTarget != nil },
            set: { if !$0 { pendingTarget = nil } }
        )
    }
}
