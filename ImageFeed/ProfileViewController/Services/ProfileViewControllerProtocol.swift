import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    var alertPresenter: AlertPresenterProtocol? { get set }
    func setProfileInfo(profile: ProfileModel)
    func setAvatar(url: URL)
    func logOutButtonTapped()
}
