struct SendOTPRequest: Codable {

    let imeiNo: String
    let mobileNumber: String
    let appVersion: String

    enum CodingKeys: String, CodingKey {

        case imeiNo
        case mobileNumber = "mobileNo"
        case appVersion
    }
}
