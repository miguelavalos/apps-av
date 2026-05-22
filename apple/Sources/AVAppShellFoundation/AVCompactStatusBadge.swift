import AVBrandFoundation
import SwiftUI

public struct AVCompactStatusBadge: View {
    @Environment(\.avBrandPalette) private var brandPalette

    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(brandPalette.accent)
            .lineLimit(1)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(brandPalette.accent.opacity(0.1), in: Capsule())
    }
}
