import UIKit

enum Res {
    enum Colors {
        static let background = UIColor(hexString: "#1A1B22")
        static let lableGrey = UIColor(hexString: "#AEAFB4")
        static let buttonRed = UIColor(hexString: "#F56B6C")
    }
    
    enum Images {
        enum Profile {
            static let defaultAvatar = UIImage(named: "avatar")
            static let logOut = UIImage(named: "logout")
        }
        
        enum TabBar {
            static let imagesList = UIImage(named: "tab_editorial_active")
            static let profile = UIImage(named: "tab_profile_active")
        }
        
        enum SingleView {
            static let backButton = UIImage(named: "backward")
            static let shareButton = UIImage(named: "sharing")
        }
        
        enum ImageList {
            static let placeholderCell = UIImage(named: "stub")
            static let isLiked = UIImage(named: "liked")
            static let isDisliked = UIImage(named: "notLiked")
        }
        
        enum Auth {
            static let imageAuth = UIImage(named: "auth")
        }
        
        enum WebView {
            static let backNavButton = UIImage(named: "nav_back_button")
        }
    }
    
    enum Strings {
        enum Profile {
            static let name = "Екатерина Новикова"
            static let nickname = "@ekaterina_nov"
            static let description = "Hello, world!"
        }
    }
    
    enum Constants {
        enum AuthStandart{
            static let accessKey = "2L518ye3_mIu4pI7BKEIQLTnbNGr1iOAOFeVeRRkGrY"
            static let secretKey = "ICk9wndZ0v16_qXsZkW498Dx1YUSG3_gJCk-6F-XuFU"
            static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
            static let accessScope = "public+read_user+write_likes"
        }
    }
    
    enum ApiLinks {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let defaultBaseURL = URL(string: "https://api.unsplash.com/")!
        static let profileBaseURL = URL(string: "https://api.unsplash.com/me")!
        static let profileUserURL = URL(string: "https://api.unsplash.com/users/")!
        static let imageListPhotosURL = URL(string: "https://api.unsplash.com/photos")!
    }
}
