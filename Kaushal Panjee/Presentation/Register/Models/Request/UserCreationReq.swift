import Foundation

struct UserCreationReq: Encodable {

    let aadharNo: String
    let candidateName: String
    let gender: String
    let dateOfBirth: String
    let stateName: String
    let stateCode: String
    let districtName: String
    let blockName: String
    let postOffice: String
    let village: String
    let pinCode: String
    let mobileNo: String?
    let email: String?
    let careOf: String
    let street: String
    let appVersion: String
    let aadharImage: String
    let imeiNo: String
    let stateLgdCode: String
    let userConsent: Bool
    let fcmToken: String
}
