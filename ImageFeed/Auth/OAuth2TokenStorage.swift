import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    private let authToken = "auth"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: authToken)
        }
        set {
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: authToken)
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: authToken)
    }
}
