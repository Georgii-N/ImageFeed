@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateProfileInfoDidCalled = false
    var updateAvatarDidCalled = false
    var addObserverToProfileViewControllerDidCalled = false
    var cleanCalled = false
    
    func updateProfileInfo() {
        updateProfileInfoDidCalled = true
    }
    
    func updateAvatar() {
        updateAvatarDidCalled = true
    }
    
    func clean() {
        cleanCalled = true
    }
    
    func addObserverToProfileViewController() {
        addObserverToProfileViewControllerDidCalled = true
    }
    
    
}
