import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            assertionFailure("Unable to instantiate ImagesListViewController from storyboard")
            return
        }
        
        let imagesListViewPresenter = ImagesListViewPresenter()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        let alertPresenter = AlertPresenter()
        profileViewController.presenter = profileViewPresenter
        profileViewController.alertPresenter = alertPresenter
        profileViewPresenter.view = profileViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                           image: Res.Images.TabBar.imagesList,
                                                           selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: Res.Images.TabBar.profile,
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
