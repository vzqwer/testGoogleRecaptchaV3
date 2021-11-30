//
//  ReCAPTCHAViewModel.swift
//  testGoogleRecapcha
//
//  Created by Oleg Shulakov on 30.11.2021.
//

import WebKit

protocol ReCAPTCHAViewModelDelegate: AnyObject {
    func didSolveCAPTCHA(token: String)
}

final class ReCAPTCHAViewModel: NSObject {
    weak var delegate: ReCAPTCHAViewModelDelegate?

    var html: String {
        guard let filePath = Bundle.main.path(
            forResource: "recaptchaV3", ofType: "html"
            ) else {
                assertionFailure("Unable to find the file.")

                return ""
        }

        let contents = try! String(
            contentsOfFile: filePath, encoding: .utf8
        )

        return parse(contents, with: ["siteKey": siteKey])
    }

    let siteKey: String
    let url: URL

    /// Creates a ReCAPTCHAViewModel
    /// - Parameters:
    ///   - siteKey: ReCAPTCHA's site key
    ///   - url: The URL for registered with Google
    init(siteKey: String, url: URL) {
        self.siteKey = siteKey
        self.url = url

        super.init()
    }
}

// MARK: - WKScriptMessageHandler
extension ReCAPTCHAViewModel: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let message = message.body as? String else {
            assertionFailure("Expected a string")
            return
        }

        delegate?.didSolveCAPTCHA(token: message)
    }
}

private extension ReCAPTCHAViewModel {
    func parse(_ string: String, with valueMap: [String: String]) -> String {
        var parsedString = string

        valueMap.forEach { key, value in
            parsedString = parsedString.replacingOccurrences(
                of: "${\(key)}", with: value
            )
        }

        return parsedString
    }
}
