import SwiftUI

public extension View {
    func avSplashTransition<Splash: View>(
        policy: AVSplashTransitionPolicy,
        onCompleted: ((Date) -> Void)? = nil,
        @ViewBuilder splash: @escaping () -> Splash
    ) -> some View {
        modifier(
            AVSplashTransitionOverlay(
                policy: policy,
                onCompleted: onCompleted,
                splash: splash
            )
        )
    }
}

private struct AVSplashTransitionOverlay<Splash: View>: ViewModifier {
    let policy: AVSplashTransitionPolicy
    let onCompleted: ((Date) -> Void)?
    let splash: () -> Splash

    @State private var transition = AVSplashTransitionState()

    func body(content: Content) -> some View {
        content
            .overlay {
                if transition.isShowing {
                    splash()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                await showInitialSplashIfNeeded()
            }
    }

    private func showInitialSplashIfNeeded() async {
        guard transition.beginIfNeeded(policy: policy) else { return }
        let startedAt = Date()
        try? await Task.sleep(for: policy.displayDuration)

        await MainActor.run {
            withAnimation(policy.dismissAnimation) {
                transition.dismiss()
            }
            onCompleted?(startedAt)
        }
    }
}
