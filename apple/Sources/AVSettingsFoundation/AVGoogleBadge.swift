import SwiftUI

public struct AVGoogleBadge: View {
    public init() {}

    public var body: some View {
        ZStack {
            Circle()
                .fill(.white)

            Text("G")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(red: 0.26, green: 0.52, blue: 0.96),
                            Color(red: 0.22, green: 0.74, blue: 0.35),
                            Color(red: 0.99, green: 0.84, blue: 0.21),
                            Color(red: 0.92, green: 0.31, blue: 0.23)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .frame(width: 20, height: 20)
    }
}
