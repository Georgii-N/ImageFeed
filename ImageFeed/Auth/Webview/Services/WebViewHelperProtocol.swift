import Foundation

protocol WebViewHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}
