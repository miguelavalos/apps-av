@testable import AVProductAccountFoundation
import AuthenticationServices
import Foundation
import Testing

@Suite("AVProductAccountAuthCancellation")
struct AVProductAccountAuthCancellationTests {
    @Test("Apple authorization cancellation maps to product account auth cancellation")
    func appleAuthorizationCancellation() {
        let error = NSError(
            domain: ASAuthorizationError.errorDomain,
            code: ASAuthorizationError.Code.canceled.rawValue
        )

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("AuthenticationServices unknown cancellation maps to product account auth cancellation")
    func authenticationServicesUnknownCancellation() {
        let error = NSError(
            domain: "com.apple.AuthenticationServices.Authorization",
            code: ASAuthorizationError.Code.unknown.rawValue
        )

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("Web authentication cancellation maps to product account auth cancellation")
    func webAuthenticationCancellation() {
        let error = NSError(
            domain: ASWebAuthenticationSessionError.errorDomain,
            code: ASWebAuthenticationSessionError.Code.canceledLogin.rawValue
        )

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("URL cancellation maps to product account auth cancellation")
    func urlCancellation() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("Localized cancellation descriptions map to product account auth cancellation")
    func localizedCancellationDescription() {
        let error = NSError(
            domain: "AccountAV.Test",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Operación cancelada por el usuario"]
        )

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("Underlying cancellation maps to product account auth cancellation")
    func underlyingCancellation() {
        let underlying = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)
        let error = NSError(
            domain: "AccountAV.Test",
            code: 1,
            userInfo: [NSUnderlyingErrorKey: underlying]
        )

        #expect(error.avProductAccountIsAuthenticationCancellation)
    }

    @Test("Ordinary errors are not product account auth cancellations")
    func ordinaryError() {
        let error = NSError(
            domain: "AccountAV.Test",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Sign-in failed"]
        )

        #expect(!error.avProductAccountIsAuthenticationCancellation)
    }
}
