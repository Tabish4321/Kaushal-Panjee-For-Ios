import Foundation

struct SendMobileOTPResponse: Decodable {

    let responseCode: Int
    let responseDesc: String
    let responseFlag: String?
}
