import Foundation

struct ValidateOtpRequest: Encodable {

    let appVersion: String
    let email: String
    let mobileNo: String
    let imeiNo: String
    let otp: String
}
