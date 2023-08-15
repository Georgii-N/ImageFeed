import UIKit

protocol AlertPresenterProtocol {
    
    func presentErrorAlert(vc: UIViewController, okAction: @escaping () -> Void)
    func presentLogoutAlert(vc: UIViewController, okAction: @escaping () -> Void)
}
