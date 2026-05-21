import AVBrandFoundation
import SwiftUI

public struct AVAviActionPanel<Content: View, Footer: View>: View {
    private let title: String
    private let pageLabel: String
    private let canGoPrevious: Bool
    private let canGoNext: Bool
    private let previousAccessibilityLabel: String
    private let nextAccessibilityLabel: String
    private let closeAccessibilityLabel: String
    private let previousPage: () -> Void
    private let nextPage: () -> Void
    private let close: () -> Void
    private let content: Content
    private let footer: Footer

    public init(
        title: String,
        pageLabel: String,
        canGoPrevious: Bool,
        canGoNext: Bool,
        previousAccessibilityLabel: String,
        nextAccessibilityLabel: String,
        closeAccessibilityLabel: String,
        previousPage: @escaping () -> Void,
        nextPage: @escaping () -> Void,
        close: @escaping () -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.pageLabel = pageLabel
        self.canGoPrevious = canGoPrevious
        self.canGoNext = canGoNext
        self.previousAccessibilityLabel = previousAccessibilityLabel
        self.nextAccessibilityLabel = nextAccessibilityLabel
        self.closeAccessibilityLabel = closeAccessibilityLabel
        self.previousPage = previousPage
        self.nextPage = nextPage
        self.close = close
        self.content = content()
        self.footer = footer()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            header

            VStack(spacing: 5) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .top)

            footer
        }
        .padding(AVBrandSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 356, alignment: .top)
        .background(AVBrandColor.elevatedSurface.opacity(0.62), in: RoundedRectangle(cornerRadius: AVBrandRadius.card, style: .continuous))
    }

    private var header: some View {
        HStack(alignment: .center, spacing: AVBrandSpacing.sm) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(AVBrandColor.textPrimary)

                Text(pageLabel)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AVBrandColor.textSecondary)
            }

            Spacer(minLength: 0)

            HStack(spacing: 6) {
                pagingButton(
                    systemImage: "chevron.left",
                    isEnabled: canGoPrevious,
                    accessibilityLabel: previousAccessibilityLabel,
                    action: previousPage
                )
                pagingButton(
                    systemImage: "chevron.right",
                    isEnabled: canGoNext,
                    accessibilityLabel: nextAccessibilityLabel,
                    action: nextPage
                )
            }
            .foregroundStyle(AVBrandColor.textSecondary)

            Button(action: close) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .frame(width: 30, height: 30)
                    .background(AVBrandColor.cardSurface, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(closeAccessibilityLabel)
            .accessibilityIdentifier("avi.actions.close")
        }
    }

    private func pagingButton(
        systemImage: String,
        isEnabled: Bool,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 10, weight: .black))
                .frame(width: 28, height: 28)
                .background(AVBrandColor.cardSurface, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.34)
        .accessibilityLabel(accessibilityLabel)
    }
}

public extension AVAviActionPanel where Footer == EmptyView {
    init(
        title: String,
        pageLabel: String,
        canGoPrevious: Bool,
        canGoNext: Bool,
        previousAccessibilityLabel: String,
        nextAccessibilityLabel: String,
        closeAccessibilityLabel: String,
        previousPage: @escaping () -> Void,
        nextPage: @escaping () -> Void,
        close: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.pageLabel = pageLabel
        self.canGoPrevious = canGoPrevious
        self.canGoNext = canGoNext
        self.previousAccessibilityLabel = previousAccessibilityLabel
        self.nextAccessibilityLabel = nextAccessibilityLabel
        self.closeAccessibilityLabel = closeAccessibilityLabel
        self.previousPage = previousPage
        self.nextPage = nextPage
        self.close = close
        self.content = content()
        self.footer = EmptyView()
    }
}

public struct AVAviPopoverActionPanel<Content: View>: View {
    private let title: String
    private let pageLabel: String
    private let showsPagingControls: Bool
    private let canGoPrevious: Bool
    private let canGoNext: Bool
    private let previousAccessibilityLabel: String
    private let nextAccessibilityLabel: String
    private let closeAccessibilityLabel: String
    private let previousPage: () -> Void
    private let nextPage: () -> Void
    private let close: () -> Void
    private let content: Content

    public init(
        title: String,
        pageLabel: String,
        showsPagingControls: Bool = false,
        canGoPrevious: Bool = false,
        canGoNext: Bool = false,
        previousAccessibilityLabel: String,
        nextAccessibilityLabel: String,
        closeAccessibilityLabel: String,
        previousPage: @escaping () -> Void = {},
        nextPage: @escaping () -> Void = {},
        close: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.pageLabel = pageLabel
        self.showsPagingControls = showsPagingControls
        self.canGoPrevious = canGoPrevious
        self.canGoNext = canGoNext
        self.previousAccessibilityLabel = previousAccessibilityLabel
        self.nextAccessibilityLabel = nextAccessibilityLabel
        self.closeAccessibilityLabel = closeAccessibilityLabel
        self.previousPage = previousPage
        self.nextPage = nextPage
        self.close = close
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header

            VStack(spacing: 7) {
                content
            }
        }
        .padding(13)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .background(AVBrandColor.elevatedSurface.opacity(0.96), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(AVBrandColor.accent.opacity(0.2), lineWidth: 1)
        }
        .shadow(color: AVBrandColor.glassShadow, radius: 24, y: 12)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)

                Text(pageLabel)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AVBrandColor.textSecondary)
            }

            Spacer(minLength: 0)

            if showsPagingControls {
                HStack(spacing: 6) {
                    popoverPagingButton(
                        systemImage: "chevron.left",
                        isEnabled: canGoPrevious,
                        accessibilityLabel: previousAccessibilityLabel,
                        action: previousPage
                    )

                    popoverPagingButton(
                        systemImage: "chevron.right",
                        isEnabled: canGoNext,
                        accessibilityLabel: nextAccessibilityLabel,
                        action: nextPage
                    )
                }
                .foregroundStyle(AVBrandColor.textSecondary)
            }

            Button(action: close) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .frame(width: 30, height: 30)
                    .background(AVBrandColor.cardSurface, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(closeAccessibilityLabel)
        }
    }

    private func popoverPagingButton(
        systemImage: String,
        isEnabled: Bool,
        accessibilityLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 10, weight: .black))
                .frame(width: 28, height: 28)
                .background(AVBrandColor.cardSurface, in: Circle())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.34)
        .accessibilityLabel(accessibilityLabel)
    }
}

public struct AVAviCommandButton: View {
    private let title: String
    private let systemImage: String
    private let accessibilityIdentifier: String?
    private let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.md) {
                Image(systemName: systemImage)
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(AVBrandColor.accent)
                    .frame(width: 28, height: 28)
                    .background(AVBrandColor.accent.opacity(0.1), in: Circle())

                Text(title)
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(AVBrandColor.textPrimary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.78)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary.opacity(0.7))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 36)
            .padding(.horizontal, AVBrandSpacing.sm)
            .background(AVBrandColor.cardSurface.opacity(0.92), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.46), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifierIfPresent(accessibilityIdentifier)
    }
}

public struct AVAviCloseSignalPanelButton: View {
    private let title: String
    private let accessibilityIdentifier: String
    private let action: () -> Void

    public init(
        title: String,
        accessibilityIdentifier: String = "avi.actions.closeSignal",
        action: @escaping () -> Void
    ) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AVBrandSpacing.sm) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary)
                    .frame(width: 28, height: 28)
                    .background(AVBrandColor.textSecondary.opacity(0.1), in: Circle())

                Text(title)
                    .font(.system(size: 13, weight: .black))
                    .foregroundStyle(AVBrandColor.textSecondary)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 11)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 38)
            .background(AVBrandColor.cardSurface.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(AVBrandColor.borderSubtle.opacity(0.38), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
}
