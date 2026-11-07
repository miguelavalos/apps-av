import AVBrandFoundation
import SwiftUI
import Testing

// `AVTypeScale` lives in AVBrandFoundation, which has no test target of its own; this target
// already depends on it through AVSettingsFoundation.
@Suite("AVTypeScale")
struct AVTypeScaleTests {
    @Test("Each fixed size scales along the system style whose default size is closest", arguments: [
        (CGFloat(8), Font.TextStyle.caption2),
        (10, .caption2),
        (11, .caption2),
        (12, .caption),
        (13, .footnote),
        (14, .footnote),
        (15, .subheadline),
        (16, .callout),
        (17, .body),
        (18, .body),
        (20, .title3),
        (22, .title2),
        (24, .title2),
        (28, .title),
        (30, .title),
        (34, .largeTitle),
        (40, .largeTitle)
    ])
    func mapsSizesToClosestTextStyle(size: CGFloat, expected: Font.TextStyle) {
        #expect(AVTypeScale.textStyle(for: size) == expected)
    }

    @Test("A larger size never scales along a smaller style than a smaller size")
    func stylesGrowWithTheSize() throws {
        let ordered: [Font.TextStyle] = [
            .caption2, .caption, .footnote, .subheadline, .callout, .body, .title3, .title2, .title, .largeTitle
        ]
        var previousIndex = 0
        for tenth in 10...500 {
            let style = AVTypeScale.textStyle(for: CGFloat(tenth) / 10)
            let index = try #require(ordered.firstIndex(of: style))
            #expect(index >= previousIndex, "size \(CGFloat(tenth) / 10) maps below the previous size's style")
            previousIndex = index
        }
        #expect(previousIndex == ordered.count - 1)
    }
}
