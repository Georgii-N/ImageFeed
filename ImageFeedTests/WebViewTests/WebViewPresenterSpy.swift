@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var greateRequestAndLoadCalled = false
    var view: WebViewViewControllerProtocol?
    
    func greateRequestAndLoad() {
        greateRequestAndLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        nil
    }
}
