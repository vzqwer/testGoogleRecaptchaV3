//
//  ViewController.swift
//  testGoogleRecapcha
//
//  Created by Oleg Shulakov on 30.11.2021.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    private var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Show recapcha VC", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.addTarget(self, action: #selector(showRecapchaVC), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()


    private let webConfiguration = WKWebViewConfiguration()
    private let contentController = WKUserContentController()
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
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

        reCAPTCHAViewModel.delegate = self
        contentController.add(reCAPTCHAViewModel, name: "recaptcha")
        webConfiguration.userContentController = contentController

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func showRecapchaVC() {
        let vc = ReCAPTCHAViewController(viewModel: reCAPTCHAViewModel)
        vc.title = "ReCAPTCHAViewController"

        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - ReCAPTCHAViewModelDelegate
extension ViewController: ReCAPTCHAViewModelDelegate {
    func didSolveCAPTCHA(token: String) {
        print("Token: \(token)")
    }
}
