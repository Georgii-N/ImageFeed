@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsGreateRequestAndLoad() {
        //given
        let webViewViewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        webViewViewController.presenter = presenter
        presenter.view = webViewViewController
        
        //when
        presenter.greateRequestAndLoad()
        
        //then
        XCTAssertTrue(presenter.greateRequestAndLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let webViewViewController = WebViewViewControllerSpy()
        let webViewHelper = WebViewHelper()
        let presenter = WebViewPresenter(webViewHelper: webViewHelper)
        webViewViewController.presenter = presenter
        presenter.view = webViewViewController
        
        //when
        presenter.greateRequestAndLoad()
        
        //then
        XCTAssertTrue(webViewViewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let webViewHelper = WebViewHelper()
        let presenter = WebViewPresenter(webViewHelper: webViewHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressUnvisibleWhenEqualOne() {
        //given
        let webViewHelper = WebViewHelper()
        let presenter = WebViewPresenter(webViewHelper: webViewHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testWebViewHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let webViewHelper = WebViewHelper(configuration: configuration)
        
        //when
        let url = webViewHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        
    }
    
    func testCodeFromURL() {
        //given
        let webViewHelper = WebViewHelper()
        let url = URL(string: "https://unsplash.com/oauth/authorize/native")!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
        URLQueryItem(name: "code", value: "test code")
        ]
        
        let finalURL = urlComponents.url!
        
        //when
        let code = webViewHelper.code(from: finalURL)
        
        //then
        XCTAssertEqual(code, "test code")
    }
    
}
