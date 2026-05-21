import AVBrandFoundation
import SwiftUI

public struct AVAviFeedbackOptionButton: View {
    private let title: String
    private let systemImage: String
    private let isSelected: Bool
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        isSelected: Bool = false,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .black))
                .foregroundStyle(isSelected ? AVBrandColor.brandBlack : AVBrandColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(
                    isSelected ? AVBrandColor.accent : AVBrandColor.elevatedSurface,
                    in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                        .stroke(
                            isSelected ? AVBrandColor.accent.opacity(0.62) : AVBrandColor.borderSubtle,
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}

public struct AVAviSelectedFeedbackStatus: View {
    private let title: String
    private let systemImage: String
    private let accessibilityLabel: String

    public init(
        title: String,
        systemImage: String,
        accessibilityLabel: String? = nil
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel ?? title
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 15, weight: .black))
                .foregroundStyle(AVBrandColor.brandBlack)
                .frame(width: 30, height: 30)
                .background(AVBrandColor.accent, in: Circle())

            Text(title)
                .font(.system(size: 13, weight: .black))
                .foregroundStyle(AVBrandColor.textPrimary)
                .lineLimit(1)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(
            AVBrandColor.accent.opacity(0.1),
            in: RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: AVBrandRadius.sm, style: .continuous)
                .stroke(AVBrandColor.accent.opacity(0.22), lineWidth: 1)
        }
        .accessibilityLabel(accessibilityLabel)
    }
}

public struct AVAviCompactFeedbackButton: View {
    private let systemImage: String
    private let accessibilityLabel: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        systemImage: String,
        accessibilityLabel: String,
        accessibilityIdentifier: String,
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(AVBrandColor.textSecondary)
                .frame(width: 34, height: 30)
                .background(
                    AVBrandColor.elevatedSurface,
                    in: RoundedRectangle(cornerRadius: 11, style: .continuous)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
