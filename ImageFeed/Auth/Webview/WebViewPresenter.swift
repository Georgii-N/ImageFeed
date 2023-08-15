import Foundation

final class WebViewPresenter {
    weak var view: WebViewViewControllerProtocol?
    var webViewHelper: WebViewHelperProtocol
        
        init(webViewHelper: WebViewHelperProtocol) {
            self.webViewHelper = webViewHelper
        }
}

extension WebViewPresenter: WebViewPresenterProtocol {
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.001
    }
    
    func greateRequestAndLoad() {
        let request = webViewHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func code(from url: URL) -> String? {
        return webViewHelper.code(from: url)
    }
}
