import AVBrandFoundation
import SwiftUI

public struct AVAppShellShowMoreButton: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        accessibilityIdentifier: String = "list.showMore",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.xs) {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.system(size: 16, weight: .bold))

                Text(title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .foregroundStyle(brandPalette.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 46)
            .background(
                brandPalette.accent.opacity(0.10),
                in: RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: AVBrandRadius.md, style: .continuous)
                    .stroke(brandPalette.accent.opacity(0.20), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
