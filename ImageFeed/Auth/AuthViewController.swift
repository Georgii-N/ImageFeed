import UIKit

final class AuthViewController: UIViewController {
    private lazy var button = UIButton()
    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    
    
    weak var delegate: AuthViewControllerDelegate?
    
    
}

extension AuthViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        addViews()
        constraintViews()
    }
    
    private func configureAppearance() {
        view.backgroundColor = Res.Colors.background
        
        imageView.image = Res.Images.Auth.imageAuth
        
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(Res.Colors.background, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.accessibilityIdentifier = "Authenticate"
        button.addTarget(self,
                         action: #selector(buttonTapped),
                         for: .touchUpInside)
        
    }
    
    private func addViews() {
        [button,imageView].forEach(self.view.setupView)
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func buttonTapped() {
        
        let webViewViewController = WebViewViewController()
        webViewViewController.modalPresentationStyle = .overFullScreen
        webViewViewController.delegate = self
        let webViewHelper = WebViewHelper()
        let webViewPresenter = WebViewPresenter(webViewHelper: webViewHelper)
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        present(webViewViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

