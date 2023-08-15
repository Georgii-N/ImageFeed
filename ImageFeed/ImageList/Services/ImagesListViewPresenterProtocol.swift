import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func setImageListObserver()
    func didSelectImage(at indexPath: IndexPath, type: TypeOfImage) -> String
    func dateForSelectedPhoto(at indexPath: IndexPath) -> Date?
    func isLiked(at indexPath: IndexPath) -> Bool
    func countOfPhotos() -> Int
    func countOfPhotosInImageListService() -> Int
    func fetchPhotosNextPage()
    func updatePhotos()
    func imageListCellDidTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void)
}
