import Foundation

struct PhotoResultElement: Decodable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likedByUser: Bool
    let description: String?
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likedByUser = "liked_by_user"
        case description, urls
    }
}

struct Urls: Decodable {
    let raw, full, regular, small: String
    let thumb: String
}

typealias PhotoResult = [PhotoResultElement]

extension PhotoResultElement {
    func convert() -> Photo {
        return Photo(id: self.id,
                     size: CGSize(width: self.width, height: self.height),
                     createdAt: self.createdAt.toDate(),
                     welcomeDescription: self.description,
                     thumbImageURL: self.urls.thumb,
                     largeImageURL: self.urls.full,
                     isLiked: self.likedByUser)
    }
}

struct LikePhotoResult: Decodable {
    let photo: PhotoResultElement
}
