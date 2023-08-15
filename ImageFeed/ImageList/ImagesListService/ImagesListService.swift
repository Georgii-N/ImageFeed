import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    private init(){}
    
    
    func fetchPhotosNextPage(token: String) {
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        let request = makeProfileImageRequest(nextPage: nextPage, token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                let newPhotos = photoResult.map { $0.convert() }
                self.photos.append(contentsOf: newPhotos)
                self.task = nil
                if self.lastLoadedPage != nil  {
                    self.lastLoadedPage! += 1
                } else {
                    self.lastLoadedPage = 1
                }
                
                NotificationCenter.default
                    .post(name: ImagesListService.DidChangeNotification,
                          object: self,
                          userInfo: ["Photos": self.photos])
            case .failure(let error):
                self.task = nil
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(nextPage: Int, token: String) -> URLRequest {
        var urlComponents = URLComponents(url: Res.ApiLinks.imageListPhotosURL, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage))
        ]
        guard let url = urlComponents.url else {assertionFailure("make request FAILED"); return URLRequest(url: URL(string: "")!)}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func changeLike(photoId: String,
                    isLike: Bool,
                    token: String,
                    _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if likeTask != nil { return }
        
        let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike, token: token)
        print(request)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResponse):
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    var newPhoto = photoResponse.photo.convert()
                    newPhoto.isLiked = !photoResponse.photo.likedByUser
                    self.photos[index] = newPhoto
                    self.likeTask = nil
                    completion(.success(()))
                }
            case .failure(let error):
                self.likeTask = nil
                completion(.failure(error))
            }
        }
        self.likeTask = task
        task.resume()
    }
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool, token: String) -> URLRequest {
        var url = Res.ApiLinks.imageListPhotosURL
        url.appendPathComponent("/\(photoId)/like")
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension ImagesListService {
    func deletePhotos() {
        photos = []
    }
}
