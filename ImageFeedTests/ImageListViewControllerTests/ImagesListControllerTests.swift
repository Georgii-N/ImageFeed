@testable import ImageFeed
import XCTest
import UIKit

final class ImagesListControllerTests: XCTestCase {
    
    func testViewControllerCallPresenter() {
        
        //given
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenterSpy()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        //when
        _ = imagesListViewController.view
        
        //then
        XCTAssertTrue(imagesListViewPresenter.viewDidLoadCalled)
        
    }
    
    func testPrepareForSegueAndCallsPresenter() {
        //given
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenterSpy()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        let segue = UIStoryboardSegue(identifier: "ShowSingleImage", source: imagesListViewController, destination: SingleImageViewController())
        let indexPath = IndexPath(row: 0, section: 0)
        
        //when
        imagesListViewController.prepare(for: segue, sender: indexPath)
        
        //then
        XCTAssertTrue(segue.destination is SingleImageViewController)
        XCTAssertTrue(imagesListViewPresenter.didCallDidSelectImage)
    }
    
    func testTableViewWillDisplayCallsPresenter() {
        
        //given
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenterSpy()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        imagesListViewPresenter.photos = [
            Photo(id: "1", size: CGSize(width: 1920, height: 1080), createdAt: Date(), welcomeDescription: "Swift", thumbImageURL: "https://example.com/thumb1.jpg", largeImageURL: "https://example.com/large1.jpg", isLiked: false),
            Photo(id: "2", size: CGSize(width: 1280, height: 720), createdAt: Date(), welcomeDescription: "Potniy Sprint", thumbImageURL: "https://example.com/thumb2.jpg", largeImageURL: "https://example.com/large2.jpg", isLiked: false),
            Photo(id: "3", size: CGSize(width: 640, height: 480), createdAt: Date(), welcomeDescription: "lol", thumbImageURL: "https://example.com/thumb3.jpg", largeImageURL: "https://example.com/large3.jpg", isLiked: true)
        ]
        let lastRow = imagesListViewPresenter.countOfPhotos() - 1
        let tableView = UITableView()
        imagesListViewController.view.addSubview(tableView)
        imagesListViewController.tableView = tableView
        
        //when
        imagesListViewController.tableView(imagesListViewController.tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: lastRow, section: 0))
        
        //then
        XCTAssertTrue(imagesListViewPresenter.fetchPhotosNextPageCalled)
    }
    
    func testCountOfPhotos() {
        
        //given
        let imagesListViewController = ImagesListViewController()
        let imagesListViewPresenter = ImagesListViewPresenterSpy()
        imagesListViewController.presenter = imagesListViewPresenter
        imagesListViewPresenter.view = imagesListViewController
        
        //when
        imagesListViewPresenter.photos = [
            Photo(id: "1", size: CGSize(width: 1920, height: 1080), createdAt: Date(), welcomeDescription: "Swift", thumbImageURL: "https://example.com/thumb1.jpg", largeImageURL: "https://example.com/large1.jpg", isLiked: false),
            Photo(id: "2", size: CGSize(width: 1280, height: 720), createdAt: Date(), welcomeDescription: "Potniy Sprint", thumbImageURL: "https://example.com/thumb2.jpg", largeImageURL: "https://example.com/large2.jpg", isLiked: false)
        ]
        
        //then
        XCTAssertEqual(imagesListViewPresenter.countOfPhotos(), 2)
    }
    
    func testProfileViewControllerCallAlert() {
        
        //given
        let imagesListViewController = ImagesListViewController()
        let alertPresenter = AlertPresenterSpy()
        imagesListViewController.alertPresenter = alertPresenter
        
        //when
        imagesListViewController.alertPresenter?.presentErrorAlert(vc: imagesListViewController, okAction: {})
        
        //then
        XCTAssertTrue(alertPresenter.presentErrorAlertCalled)
    }
}
