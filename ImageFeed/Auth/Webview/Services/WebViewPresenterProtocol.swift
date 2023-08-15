import Foundation
protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func greateRequestAndLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
