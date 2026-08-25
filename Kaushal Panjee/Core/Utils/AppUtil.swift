import Foundation
import UIKit

enum AppUtil {

    // MARK: - App Version

    static func appVersion() -> String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String ?? "1.0"
    }

    // MARK: - Build Number

    static func buildNumber() -> String {
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String ?? "1"
    }

    // MARK: - Device Name

    static func deviceName() -> String {
        UIDevice.current.name
    }

    // MARK: - Device ID

    static func getDeviceId() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    

    
}
