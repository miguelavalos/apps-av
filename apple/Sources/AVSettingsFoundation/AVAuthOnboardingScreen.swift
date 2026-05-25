import AVBrandFoundation
import SwiftUI

public struct AVAuthOnboardingScreen<Brand: View, HeroArtwork: View, CTACompanion: View, AuthPanel: View>: View {
    @Binding private var authOptionsArePresented: Bool

    private let title: String
    private let subtitle: String
    private let primaryTitle: String
    private let secondaryTitle: String?
    private let primaryAction: () -> Void
    private let secondaryAction: (() -> Void)?
    private let brandAccessibilityLabel: String
    private let backgroundStart: Color
    private let backgroundMid: Color
    private let backgroundEnd: Color
    private let brand: Brand
    private let heroArtwork: HeroArtwork
    private let ctaCompanion: CTACompanion
    private let authPanel: AuthPanel

    @GestureState private var authOptionsDragOffset: CGFloat = 0

    public init(
        authOptionsArePresented: Binding<Bool>,
        content: AVAuthOnboardingContent,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        @ViewBuilder brand: () -> Brand,
        @ViewBuilder heroArtwork: () -> HeroArtwork,
        @ViewBuilder ctaCompanion: () -> CTACompanion,
        @ViewBuilder authPanel: () -> AuthPanel
    ) {
        self.init(
            authOptionsArePresented: authOptionsArePresented,
            title: content.title,
            subtitle: content.subtitle,
            primaryTitle: content.primaryTitle,
            secondaryTitle: content.secondaryTitle,
            brandAccessibilityLabel: content.brandAccessibilityLabel,
            backgroundStart: content.backgroundStart,
            backgroundMid: content.backgroundMid,
            backgroundEnd: content.backgroundEnd,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction,
            brand: brand,
            heroArtwork: heroArtwork,
            ctaCompanion: ctaCompanion,
            authPanel: authPanel
        )
    }

    public init(
        authOptionsArePresented: Binding<Bool>,
        title: String,
        subtitle: String,
        primaryTitle: String,
        secondaryTitle: String? = nil,
        brandAccessibilityLabel: String,
        backgroundStart: Color = AVBrandColor.launchSurfaceStart,
        backgroundMid: Color = AVBrandColor.neutral50,
        backgroundEnd: Color = AVBrandColor.neutral100,
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil,
        @ViewBuilder brand: () -> Brand,
        @ViewBuilder heroArtwork: () -> HeroArtwork,
        @ViewBuilder ctaCompanion: () -> CTACompanion,
        @ViewBuilder authPanel: () -> AuthPanel
    ) {
        self._authOptionsArePresented = authOptionsArePresented
        self.title = title
        self.subtitle = subtitle
        self.primaryTitle = primaryTitle
        self.secondaryTitle = secondaryTitle
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.brandAccessibilityLabel = brandAccessibilityLabel
        self.backgroundStart = backgroundStart
        self.backgroundMid = backgroundMid
        self.backgroundEnd = backgroundEnd
        self.brand = brand()
        self.heroArtwork = heroArtwork()
        self.ctaCompanion = ctaCompanion()
        self.authPanel = authPanel()
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                AVBrandColor.canvas.ignoresSafeArea()

                onboardingBackdrop
                    .overlay {
                        LinearGradient(
                            colors: [
                                AVBrandColor.neutral50.opacity(0.16),
                                AVBrandColor.neutral50.opacity(authOptionsArePresented ? 0.54 : 0.28),
                                AVBrandColor.neutral50.opacity(authOptionsArePresented ? 0.94 : 0.86)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .blur(radius: authOptionsArePresented ? 6 : 0)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: max(proxy.safeAreaInsets.top + 44, 62))

                    AVOnboardingHeroText(title: title, subtitle: subtitle)

                    Spacer(minLength: authOptionsArePresented ? 18 : 246)

                    if authOptionsArePresented {
                        authPanel
                            .padding(.horizontal, 14)
                            .padding(.bottom, max(4, proxy.safeAreaInsets.bottom - 10))
                            .offset(y: authOptionsDragOffset)
                            .gesture(authOptionsDismissGesture)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        AVOnboardingCallToActionSection(
                            primaryTitle: primaryTitle,
                            secondaryTitle: secondaryTitle,
                            primaryAction: primaryAction,
                            secondaryAction: secondaryAction
                        ) {
                            ctaCompanion
                                .allowsHitTesting(false)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, max(16, proxy.safeAreaInsets.bottom + 6))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                brand
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(brandAccessibilityLabel)
                    .padding(.top, 24)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .animation(.spring(response: 0.36, dampingFraction: 0.88), value: authOptionsArePresented)
    }

    private var onboardingBackdrop: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: [backgroundStart, backgroundMid, backgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                heroArtwork
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .offset(y: 50)
                    .clipped()
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .black.opacity(0.18), location: 0.1),
                                .init(color: .black, location: 0.23),
                                .init(color: .black, location: 1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .opacity(0.82)
                    .saturation(0.92)

                VStack {
                    Spacer()

                    AVOnboardingCurvedWave()
                        .stroke(AVBrandColor.accent.opacity(0.1), lineWidth: 2)
                        .frame(height: 180)

                    AVOnboardingCurvedWave(offset: 50)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1.5)
                        .frame(height: 210)
                        .offset(y: -24)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private var authOptionsDismissGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .updating($authOptionsDragOffset) { value, state, _ in
                state = max(0, value.translation.height)
            }
            .onEnded { value in
                let shouldDismiss =
                    value.translation.height > 120 ||
                    value.predictedEndTranslation.height > 180

                guard shouldDismiss else { return }

                withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
                    authOptionsArePresented = false
                }
            }
    }
}

private struct AVOnboardingCurvedWave: Shape {
    var offset: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: -40, y: rect.height * 0.72 - offset))
        path.addCurve(
            to: CGPoint(x: rect.width + 40, y: rect.height * 0.86 - offset),
            control1: CGPoint(x: rect.width * 0.25, y: rect.height * 0.12 - offset),
            control2: CGPoint(x: rect.width * 0.75, y: rect.height * 0.18 - offset)
        )
        return path
    }
}
