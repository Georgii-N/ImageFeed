import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        XCTAssertTrue(webView.waitForExistence(timeout: 3))
        loginTextField.typeText("")
        app.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("")
        sleep(3)
        webView.swipeUp()
        
        let loginButton = webView.descendants(matching: .button).element
        XCTAssertTrue(webView.waitForExistence(timeout: 1))
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        print(app.debugDescription)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() {
        sleep(3)
        let tableView = app.tables.firstMatch
        let cell = tableView.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(app.waitForExistence(timeout: 3))
        
        let cellToLike = tableView.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 3))
        
        let likeButton = cellToLike.buttons["LikeButtonID"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
        
        likeButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
        
        let cellToDislike = tableView.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToDislike.waitForExistence(timeout: 3))

        let disLikeButton = cellToLike.buttons["LikeButtonID"]
        XCTAssertTrue(disLikeButton.waitForExistence(timeout: 3))

        disLikeButton.tap()
        XCTAssertTrue(disLikeButton.waitForExistence(timeout: 3))
        
        cell.tap()
        XCTAssertTrue(cell.waitForExistence(timeout: 7))

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["BackButton"]
        backButton.tap()
        XCTAssertTrue(likeButton.waitForExistence(timeout: 3))
    }
    
    
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Georgiy Neguritsa"].exists)
        XCTAssertTrue(app.staticTexts["georgiy_n"].exists)
        
        let logoutButton = app.buttons["LogoutButton"]
        logoutButton.tap()
        
        sleep(1)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
