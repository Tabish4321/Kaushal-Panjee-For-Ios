import Foundation

struct CreateUserRes: Decodable {
    let wrappedList: [CreatedUser]
    let responseCode: Int
    let responseDesc: String
    let responseMsg: String
}

struct CreatedUser: Decodable {
    let userId: String
    let appCode: String
}
