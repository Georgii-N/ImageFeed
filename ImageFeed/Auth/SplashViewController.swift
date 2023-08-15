import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    private var isFirstAppear = true
    private lazy var imageView = UIImageView()
    
    
    let oAuth2Service = OAuth2Service()
    let oAuth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imageListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        addViews()
        constraintViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstAppear == true {
            if  let token = oAuth2TokenStorage.token {
                self.fetchProfile(token: token)
            } else {
                let authViewController = AuthViewController()
                authViewController.delegate = self
                authViewController.modalPresentationStyle = .fullScreen
                present(authViewController, animated: true)
                isFirstAppear = false
            }
        }
    }
}

extension SplashViewController {
    
    private func configureAppearance() {
        view.backgroundColor = Res.Colors.background
        imageView.image = Res.Images.Auth.imageAuth
    }
    
    private func addViews() {
        view.setupView(imageView)
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlertError()
                break
            }
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "ОК", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    func setIsFirstAppearTrue() {
        isFirstAppear = true
    }
}


