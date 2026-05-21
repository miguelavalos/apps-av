import AVBrandFoundation
import SwiftUI

public struct AVSelectionSheetScaffold<Rows: View>: View {
    private let title: String
    private let closeTitle: String
    private let detents: Set<PresentationDetent>
    private let onClose: () -> Void
    private let rows: Rows

    public init(
        title: String,
        closeTitle: String,
        detents: Set<PresentationDetent> = [.medium],
        onClose: @escaping () -> Void,
        @ViewBuilder rows: () -> Rows
    ) {
        self.title = title
        self.closeTitle = closeTitle
        self.detents = detents
        self.onClose = onClose
        self.rows = rows()
    }

    public var body: some View {
        NavigationStack {
            List {
                rows
            }
            .navigationTitle(title)
            .avInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(closeTitle, action: onClose)
                }
            }
        }
        .presentationDetents(detents)
    }
}

private extension View {
    @ViewBuilder
    func avInlineNavigationTitle() -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

public struct AVSelectionSheetRow: View {
    private let title: String
    private let detail: String
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        title: String,
        detail: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.detail = detail
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(isSelected ? AVBrandColor.accent : AVBrandColor.textSecondary.opacity(0.55))

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .black))
                        .foregroundStyle(AVBrandColor.textPrimary)

                    Text(detail)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AVBrandColor.textSecondary)
                }
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}
