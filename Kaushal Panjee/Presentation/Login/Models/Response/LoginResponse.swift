import Foundation

struct LoginResponse: Codable {

    let responseCode: Int
    let responseDesc: String
    let responseMsg: String
    let accessToken: String?
}
