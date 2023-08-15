import Foundation

enum TypeOfImage {
    case large
    case thumb
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
   
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    
    private var imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private var isLiked = false
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    func viewDidLoad() {
        fetchPhotosNextPage()
        view?.showLoadingIndicator()
        setImageListObserver()
    }
    
    func setImageListObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
    }
    
    func didSelectImage(at indexPath: IndexPath, type: TypeOfImage) -> String {
        switch type {
        case .large:
            return photos[indexPath.row].largeImageURL
        case .thumb:
            return photos[indexPath.row].thumbImageURL
        }
    }
    
    func dateForSelectedPhoto(at indexPath: IndexPath) -> Date? {
        return photos[indexPath.row].createdAt
    }
    
    func isLiked(at indexPath: IndexPath) -> Bool {
        photos[indexPath.row].isLiked
    }
    
    func countOfPhotos() -> Int {
        photos.count
    }
    
    func countOfPhotosInImageListService() -> Int {
        imagesListService.photos.count
    }
    
    func fetchPhotosNextPage() {
        guard let token = oAuth2TokenStorage.token else {return}
        imagesListService.fetchPhotosNextPage(token: token)
    }
    
    func updatePhotos() {
        photos = imagesListService.photos
    }
    
    func imageListCellDidTapLike(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        let photo = photos[indexPath.row]
        view?.showLoadingIndicator()
        guard let token = oAuth2TokenStorage.token else {return}
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, token: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.isLiked = self.photos[indexPath.row].isLiked
                completion(self.isLiked)
            case .failure(let error):
                print(error)
            }
            view?.dismissLoadingIndicator()
        }
    }
}
