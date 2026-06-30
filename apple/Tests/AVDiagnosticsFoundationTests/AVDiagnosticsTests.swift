@testable import AVDiagnosticsFoundation
import Foundation
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

    @Test("Expected cancelled URLSession errors are filtered before sending")
    func cancelledURLSessionErrorsAreFiltered() {
        #expect(!AVDiagnostics.shouldSendSentryEvent(
            errorDomain: NSURLErrorDomain,
            errorCode: NSURLErrorCancelled,
            exceptionType: "NSURLErrorDomain",
            exceptionValue: #"Error Domain=NSURLErrorDomain Code=-999 "Operación cancelada""#,
            requestURL: "https://api-account-av.avalsys.com/v1/me"
        ))
    }

    @Test("Known transient HTTP 503 failed-request events are filtered before sending")
    func knownTransientHTTP503EventsAreFiltered() {
        #expect(!AVDiagnostics.shouldSendSentryEvent(
            errorDomain: nil,
            errorCode: nil,
            exceptionType: "HTTPClientError",
            exceptionValue: "HTTP Client Error with status code: 503",
            requestURL: "https://api-tune-av.avalsys.com/v1/tune/workspace/realtime-sessions"
        ))

        #expect(!AVDiagnostics.shouldSendSentryEvent(
            errorDomain: nil,
            errorCode: nil,
            exceptionType: "HTTPClientError",
            exceptionValue: "HTTP Client Error with status code: 503",
            requestURL: "https://de1.api.radio-browser.info/json/stations/search"
        ))
    }

    @Test("Expected Animate sync not-configured events are filtered before sending")
    func expectedAnimateSyncNotConfiguredEventsAreFiltered() {
        #expect(!AVDiagnostics.shouldSendSentryEvent(
            errorDomain: nil,
            errorCode: nil,
            exceptionType: "AnimateAV.AnimateSyncError",
            exceptionValue: "notConfigured (Code: 0)",
            feature: "animate.sync",
            errorCodeTag: "notConfigured",
            requestURL: nil
        ))
    }

    @Test("Actionable Sentry events are still sent")
    func actionableSentryEventsAreStillSent() {
        #expect(AVDiagnostics.shouldSendSentryEvent(
            errorDomain: nil,
            errorCode: nil,
            exceptionType: "HTTPClientError",
            exceptionValue: "HTTP Client Error with status code: 503",
            requestURL: "https://api-tune-av.avalsys.com/v1/tune/feedback"
        ))

        #expect(AVDiagnostics.shouldSendSentryEvent(
            errorDomain: NSURLErrorDomain,
            errorCode: NSURLErrorTimedOut,
            exceptionType: "NSURLErrorDomain",
            exceptionValue: #"Error Domain=NSURLErrorDomain Code=-1001 "The request timed out.""#,
            requestURL: "https://api-account-av.avalsys.com/v1/me"
        ))
    }
}
