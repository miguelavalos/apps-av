import AVBrandFoundation
import SwiftUI

public struct AVAppShellSearchField: View {
    @Environment(\.avBrandPalette) private var brandPalette

    @Binding private var query: String
    private let prompt: String
    private let clearTitle: String
    private let focusRequest: Int?

    @FocusState private var isFocused: Bool

    public init(
        query: Binding<String>,
        prompt: String,
        clearTitle: String,
        focusRequest: Int? = nil
    ) {
        _query = query
        self.prompt = prompt
        self.clearTitle = clearTitle
        self.focusRequest = focusRequest
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AVBrandColor.textSecondary)

            searchTextField

            if !query.isEmpty {
                Button(clearTitle) {
                    query = ""
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(brandPalette.accent)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AVBrandColor.cardSurface)
                .overlay {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AVBrandColor.borderSubtle, lineWidth: 1)
                }
        )
        .task(id: focusRequest) {
            guard focusRequest != nil else { return }
            try? await Task.sleep(for: .milliseconds(180))
            guard !Task.isCancelled else { return }
            isFocused = true
        }
    }

    private var searchTextField: some View {
        TextField(
            text: $query,
            prompt: Text(prompt)
                .foregroundStyle(AVBrandColor.textSecondary.opacity(0.68))
        ) {
        }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(AVBrandColor.textPrimary)
            .tint(brandPalette.accent)
            .applySearchTextInputBehavior()
            .focused($isFocused)
    }
}

private extension View {
    @ViewBuilder
    func applySearchTextInputBehavior() -> some View {
        #if os(iOS)
        self
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .submitLabel(.search)
        #else
        self
        #endif
    }
}
