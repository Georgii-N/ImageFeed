@testable import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    func logOutButtonTapped() {
    }
    
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var alertPresenter: ImageFeed.AlertPresenterProtocol?
    var setProfileInfoCalled = false
    var setAvatarCalled = false
    
    func setProfileInfo(profile: ImageFeed.ProfileModel) {
        setProfileInfoCalled = true
    }
    
    func setAvatar(url: URL) {
        setAvatarCalled = true
    }
}
