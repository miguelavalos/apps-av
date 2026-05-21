import SwiftUI

public struct AVAviStableAssetImage<Value: Equatable>: View {
    private let value: Value
    private let assetName: (Value) -> String
    private let transitionPriority: (Value) -> Int
    private let width: CGFloat
    private let height: CGFloat?
    private let defaultMinimumDisplayInterval: TimeInterval
    private let immediateMinimumDisplayInterval: TimeInterval

    @State private var displayedValue: Value
    @State private var lastValueChange = Date.distantPast

    public init(
        value: Value,
        width: CGFloat,
        height: CGFloat? = nil,
        defaultMinimumDisplayInterval: TimeInterval = 2.4,
        immediateMinimumDisplayInterval: TimeInterval = 0.45,
        assetName: @escaping (Value) -> String,
        transitionPriority: @escaping (Value) -> Int
    ) {
        self.value = value
        self.width = width
        self.height = height
        self.defaultMinimumDisplayInterval = defaultMinimumDisplayInterval
        self.immediateMinimumDisplayInterval = immediateMinimumDisplayInterval
        self.assetName = assetName
        self.transitionPriority = transitionPriority
        _displayedValue = State(initialValue: value)
    }

    private var displayedAssetName: String {
        assetName(displayedValue)
    }

    public var body: some View {
        Image(displayedAssetName)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
            .animation(.snappy(duration: 0.24), value: displayedAssetName)
            .onAppear {
                displayedValue = value
                lastValueChange = Date()
            }
            .onChange(of: value) { _, candidate in
                adopt(candidate)
            }
            .task(id: value) {
                await adoptWhenAllowed(value)
            }
    }

    private func adopt(_ candidate: Value) {
        let now = Date()
        guard shouldAdopt(
            displayed: displayedValue,
            candidate: candidate,
            elapsedSinceLastChange: now.timeIntervalSince(lastValueChange)
        ) else { return }

        displayedValue = candidate
        lastValueChange = now
    }

    @MainActor
    private func adoptWhenAllowed(_ candidate: Value) async {
        guard displayedValue != candidate else { return }
        let minimumInterval = transitionPriority(candidate) > transitionPriority(displayedValue)
            ? immediateMinimumDisplayInterval
            : defaultMinimumDisplayInterval
        let elapsed = Date().timeIntervalSince(lastValueChange)
        let remaining = max(0, minimumInterval - elapsed)
        if remaining > 0 {
            do {
                try await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
            } catch {
                return
            }
        }
        guard !Task.isCancelled else { return }
        adopt(candidate)
    }

    private func shouldAdopt(
        displayed: Value,
        candidate: Value,
        elapsedSinceLastChange: TimeInterval
    ) -> Bool {
        guard displayed != candidate else { return false }
        if transitionPriority(candidate) > transitionPriority(displayed) {
            return elapsedSinceLastChange >= immediateMinimumDisplayInterval
        }
        return elapsedSinceLastChange >= defaultMinimumDisplayInterval
    }
}
