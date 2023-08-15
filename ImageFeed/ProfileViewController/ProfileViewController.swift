import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    lazy var avatarImage = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var nicknameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    private lazy var logOutButton = UIButton()
    
    var presenter: ProfileViewPresenterProtocol?
    var alertPresenter: AlertPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        addViews()
        constraintViews()
        presenter?.addObserverToProfileViewController()
        presenter?.updateProfileInfo()
        presenter?.updateAvatar()
    }
    
}

extension ProfileViewController {
    private func configureAppearance() {
        
        view.backgroundColor = Res.Colors.background
        
        avatarImage.image = Res.Images.Profile.defaultAvatar
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 35
        avatarImage.contentMode = .scaleAspectFill
        
        nameLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.text = Res.Strings.Profile.name
        
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = Res.Colors.lableGrey
        nicknameLabel.text = Res.Strings.Profile.nickname
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.text = Res.Strings.Profile.description
        
        logOutButton.setImage(Res.Images.Profile.logOut, for: .normal)
        logOutButton.accessibilityIdentifier = "LogoutButton"
        logOutButton.addTarget(self,
                               action: #selector(logOutButtonTapped),
                               for: .touchUpInside)
    }
    
    private func addViews() {
        [avatarImage, nameLabel, nicknameLabel, descriptionLabel, logOutButton].forEach(self.view.setupView)
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.heightAnchor.constraint(equalTo: avatarImage.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            
            logOutButton.heightAnchor.constraint(equalToConstant: 22),
            logOutButton.widthAnchor.constraint(equalToConstant: 20),
            logOutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26)
        ])
    }
    
    func setProfileInfo(profile: ProfileModel) {
        self.nameLabel.text = profile.name
        self.nicknameLabel.text = profile.username
        self.descriptionLabel.text = profile.bio
    }
    
    func setAvatar(url: URL) {
        avatarImage.kf.setImage(with: url,
                                placeholder: Res.Images.Profile.defaultAvatar,
                                options: [])
    }
    
    @objc func logOutButtonTapped() {
        alertPresenter?.presentLogoutAlert(vc: self,
                                           okAction: {
            [weak self] in
            guard let self = self else { return }
            self.presenter?.clean()
            let splashViewController = SplashViewController()
            splashViewController.modalPresentationStyle = .overFullScreen
            splashViewController.setIsFirstAppearTrue()
            self.present(splashViewController, animated: true) })
    }
}
