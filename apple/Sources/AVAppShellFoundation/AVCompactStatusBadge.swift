import AVBrandFoundation
import SwiftUI

public struct AVCompactStatusBadge: View {
    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        Text(title)
            .font(.system(size: 10, weight: .black))
            .foregroundStyle(AVBrandColor.accent)
            .lineLimit(1)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(AVBrandColor.accent.opacity(0.1), in: Capsule())
    }
}
