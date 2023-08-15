import UIKit
import WebKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    private lazy var webView = WKWebView()
    private lazy var backButton = UIButton(type: .custom)
    private lazy var progressView = UIProgressView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        addViews()
        constraintViews()
        webView.navigationDelegate = self
        presenter?.greateRequestAndLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        estimatedProgressObservation = webView.observe(
                    \.estimatedProgress,
                    options: [],
                    changeHandler: { [weak self] _, _ in
                        guard let self = self else { return }
                        presenter?.didUpdateProgressValue(webView.estimatedProgress)
                    })
    }
}


extension WebViewViewController {
    
    private func configureAppearance() {
        view.backgroundColor = .white
        
        webView.backgroundColor = .white
        webView.accessibilityIdentifier = "UnsplashWebView"
        
        backButton.tintColor = Res.Colors.background
        backButton.setImage(Res.Images.WebView.backNavButton, for: .normal)
        backButton.addTarget(self,
                             action: #selector(didTapBackButton),
                             for: .touchUpInside)
        
        progressView.tintColor = Res.Colors.background
    }
    
    private func addViews() {
        [webView, backButton, progressView].forEach(self.view.setupView)
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 2),
            progressView.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: webView.trailingAnchor)
        ])
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
}
