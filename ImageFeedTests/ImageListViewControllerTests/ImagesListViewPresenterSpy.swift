@testable import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didCallDidSelectImage = false
    var fetchPhotosNextPageCalled = false
    var photos: [Photo] = []
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func setImageListObserver() {
    }
    
    func didSelectImage(at indexPath: IndexPath, type: ImageFeed.TypeOfImage) -> String {
        didCallDidSelectImage = true
        return ""
    }
    
    func dateForSelectedPhoto(at indexPath: IndexPath) -> Date? {
        return nil
    }
    
    func isLiked(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func countOfPhotos() -> Int {
        photos.count
    }
    
    func countOfPhotosInImageListService() -> Int {
        10
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
    
    func updatePhotos() {
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
    }
    
    
}
