import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    weak var view: ProfileViewControllerProtocol?
    
    func updateProfileInfo() {
        guard let profile = profileService.profile else { return }
        view?.setProfileInfo(profile: profile)
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL) else { return }
        view?.setAvatar(url: url)
    }
    
    func clean() {
        OAuth2TokenStorage().deleteToken()
        WebViewViewController().clean()
        ImagesListService.shared.deletePhotos()
    }
    
    func addObserverToProfileViewController() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
}

