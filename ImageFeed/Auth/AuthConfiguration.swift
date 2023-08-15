import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Res.Constants.AuthStandart.accessKey,
            secretKey: Res.Constants.AuthStandart.secretKey,
            redirectURI: Res.Constants.AuthStandart.redirectURI,
            accessScope: Res.Constants.AuthStandart.accessScope,
            authURLString: Res.ApiLinks.unsplashAuthorizeURLString,
            defaultBaseURL: Res.ApiLinks.defaultBaseURL)
    }
}
