import AVBrandFoundation
import SwiftUI

public struct AVOnboardingCallToActionSection<Companion: View>: View {
    private let primaryTitle: String
    private let secondaryTitle: String
    private let primaryAction: () -> Void
    private let secondaryAction: () -> Void
    private let companion: Companion

    public init(
        primaryTitle: String,
        secondaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void,
        @ViewBuilder companion: () -> Companion
    ) {
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.companion = companion()
    }

    public var body: some View {
        VStack(spacing: 18) {
            Button(action: primaryAction) {
                Text(primaryTitle)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(AVBrandColor.brandBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AVBrandColor.accent, in: Capsule())
            }
            .overlay(alignment: .topTrailing) {
                companion
            }

            Button(secondaryTitle, action: secondaryAction)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(AVBrandColor.brandGraphite.opacity(0.84))
        }
        .background(alignment: .top) {
            RadialGradient(
                colors: [
                    AVBrandColor.accent.opacity(0.18),
                    .clear
                ],
                center: .top,
                startRadius: 24,
                endRadius: 220
            )
            .frame(height: 220)
            .offset(y: -18)
        }
    }
}

public extension AVOnboardingCallToActionSection where Companion == EmptyView {
    init(
        primaryTitle: String,
        secondaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) {
        self.init(
            primaryTitle: primaryTitle,
            secondaryTitle: secondaryTitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            companion: { EmptyView() }
        )
    }
}
