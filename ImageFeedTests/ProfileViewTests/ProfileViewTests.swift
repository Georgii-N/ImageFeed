@testable import ImageFeed
import XCTest
import Kingfisher

final class ProfileViewTests: XCTestCase {
    
    
    func testProfileViewControllerCalledFunctions() {
        
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        
        //when
        profileViewController.presenter?.updateProfileInfo()
        profileViewController.presenter?.updateAvatar()
        profileViewController.presenter?.addObserverToProfileViewController()
        profileViewController.presenter?.clean()
        
        //then
        XCTAssertTrue(presenter.updateProfileInfoDidCalled)
        XCTAssertTrue(presenter.updateAvatarDidCalled)
        XCTAssertTrue(presenter.addObserverToProfileViewControllerDidCalled)
        XCTAssertTrue(presenter.cleanCalled)
    }
    
    func testSetProfileInfo() {
        
        //given
        let profileViewController = ProfileViewController()
        let profile = ProfileModel(username: "2", name: "1", loginName: "4", bio: "3")
        
        //when
        profileViewController.setProfileInfo(profile: profile)
        
        //then
        XCTAssertEqual(profileViewController.nameLabel.text, "1") 
        XCTAssertEqual(profileViewController.nicknameLabel.text, "2")
        XCTAssertEqual(profileViewController.descriptionLabel.text, "3")
    }
    
    func testSetAvatar() {
        
        //given
        let profileViewController = ProfileViewController()
        guard let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/be/Apus_apus_-Barcelona%2C_Spain-8_%281%29.jpg") else { return }
        
        //when
        profileViewController.setAvatar(url: url)
        
        //then
        XCTAssertNotNil(profileViewController.avatarImage.image)
    }
    
    func testLogOutButtonTapped() {
        
        //given
        let profileViewController = ProfileViewController()
        let alertPresenter = AlertPresenterSpy()
        profileViewController.alertPresenter = alertPresenter
        
        //when
        profileViewController.logOutButtonTapped()
        
        //then
        XCTAssertTrue(alertPresenter.presentLogoutAlertCalled)
    }
}
