import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func updateProfileInfo()
    func updateAvatar()
    func clean()
    func addObserverToProfileViewController()
}
