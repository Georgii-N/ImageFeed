import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private (set) var profile: ProfileModel?
    private var task: URLSessionTask?
    private let profileImageService = ProfileImageService.shared
    
    private init(){}
    
    private let urlSession = URLSession.shared
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        if task != nil { return }
        
        let request = makeProfileRequest(token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileServiceRespondeBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileResult):
                
                self.profile = ProfileModel(
                    username: profileResult.username,
                    name: (profileResult.firstName + " " + profileResult.lastName),
                    loginName: "@" + profileResult.username,
                    bio: profileResult.bio ?? "")
                self.profileImageService.fetchProfileImageURL(
                    username: self.profile!.username,
                    token: token) {_ in
                    }
                if let profile = self.profile {
                    completion(.success(profile))
                } else {
                    completion(.failure(NetworkError.unknown))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }

    
    private func makeProfileRequest(token: String) -> URLRequest {
        var request = URLRequest(url: Res.ApiLinks.profileBaseURL)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
