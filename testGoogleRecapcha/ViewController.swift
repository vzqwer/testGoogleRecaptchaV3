//
//  ViewController.swift
//  testGoogleRecapcha
//
//  Created by Oleg Shulakov on 30.11.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    private let webConfiguration = WKWebViewConfiguration()
    private let contentController = WKUserContentController()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isHidden = true
        return webView
    }()

    private var reCAPTCHAViewModel: ReCAPTCHAViewModel = {
        let viewModel = ReCAPTCHAViewModel(
            siteKey: "6Lc2amwdAAAAAEy5QNQ5nAq624FGIXiVCkj_ECdd",
            url: URL(string: "https://vzqwer.github.io/testRecapchaV3/")!
        )

        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)

        reCAPTCHAViewModel.delegate = self
        contentController.add(reCAPTCHAViewModel, name: "recaptcha")
        webConfiguration.userContentController = contentController

        webView.loadHTMLString(reCAPTCHAViewModel.html, baseURL: reCAPTCHAViewModel.url)
    }
}

// MARK: - ReCAPTCHAViewModelDelegate
extension ViewController: ReCAPTCHAViewModelDelegate {
    func didSolveCAPTCHA(token: String) {
        print("Token: \(token)")
    }
}
