import Foundation

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func showLoadingIndicator()
    func dismissLoadingIndicator()
    func updateTableViewAnimated()
}
