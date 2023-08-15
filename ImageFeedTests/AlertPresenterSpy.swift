@testable import ImageFeed
import UIKit

final class AlertPresenterSpy: AlertPresenterProtocol {
    
    
    var presentLogoutAlertCalled = false
    var presentErrorAlertCalled = false
    
    func presentErrorAlert(vc: UIViewController, okAction: @escaping () -> Void) {
        presentErrorAlertCalled = true
    }
    
    func presentLogoutAlert(vc: UIViewController, okAction: @escaping () -> Void) {
        presentLogoutAlertCalled = true
    }
}
