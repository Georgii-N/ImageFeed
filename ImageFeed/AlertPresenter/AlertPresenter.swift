import UIKit

class AlertPresenter: AlertPresenterProtocol {
    func presentErrorAlert(vc: UIViewController, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Что-то пошло не так:(",
                                      message: "Попробовать ещё раз?",
                                      preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Повторить", style: .default) { _ in
            okAction()
        }
        let alertActionNo = UIAlertAction(title: "Не надо", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(alertActionNo)
        alert.addAction(alertActionOk)
        vc.present(alert, animated: true)
    }
    
    func presentLogoutAlert(vc: UIViewController, okAction: @escaping () -> Void) {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Да", style: .default) { _ in
            okAction()
        }
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionNo)
        alert.addAction(actionOK)
        vc.present(alert, animated: true)
    }
}
