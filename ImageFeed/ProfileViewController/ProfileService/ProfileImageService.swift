import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    private init (){}
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil { return }
        let request = makeProfileImageRequest(username: username, token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileImageResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileImageResponse):
                let avatarURL = profileImageResponse.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(name: ProfileImageService.DidChangeNotification,
                          object: self,
                          userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest {
        var request = URLRequest(url: Res.ApiLinks.profileUserURL.appendingPathComponent("\(username)"))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
