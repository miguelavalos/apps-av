@testable import AVDiagnosticsFoundation
import Testing

@Suite("AVDiagnostics")
struct AVDiagnosticsTests {
    @Test("HTTP 4xx request failures are kept as breadcrumbs")
    func requestFailure4xxIsBreadcrumbOnly() {
        for code in ["request_failed_400", "request_failed_401", "request_failed_404", "request_failed_499"] {
            let context = AVDiagnosticsContext(feature: "test", code: code)
            #expect(context.shouldKeepAsBreadcrumb)
        }
    }

    @Test("Actionable failures are captured as Sentry events")
    func actionableFailuresAreCaptured() {
        for code in ["request_failed_500", "request_failed_399", "bad_server_response", "missing_base_url"] {
            let context = AVDiagnosticsContext(feature: "test", code: code)
            #expect(!context.shouldKeepAsBreadcrumb)
        }
    }
}
