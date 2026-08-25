import Foundation

struct LoginRequest: Codable {

    let loginId: String
    let password: String
    let imeiNo: String
    let appVersion: String
    let deviceName: String
    let fcmToken: String
}
