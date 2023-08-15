import Foundation

struct ProfileServiceRespondeBody: Decodable {
    let username, firstName, lastName: String
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
