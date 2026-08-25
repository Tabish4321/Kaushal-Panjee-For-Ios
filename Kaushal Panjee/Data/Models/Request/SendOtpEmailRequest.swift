import Foundation

struct SendOtpEmailRequest: Encodable {

    let imeiNo: String
    let email: String
    let appVersion: String
}
