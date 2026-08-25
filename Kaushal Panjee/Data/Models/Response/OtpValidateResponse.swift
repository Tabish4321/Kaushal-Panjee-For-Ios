import Foundation

struct OtpValidateResponse: Decodable {

    let responseCode: Int
    let responseDesc: String
    let responseFlag: String?
    let wrappedList: [UserIdName]?
    let candidateId: String?

}

struct UserIdName: Decodable {

    let loginId: String
}
