
import Foundation

class ConfigUtils {

    static var configUserDefaults: UserDefaults!
    
    static let STAGING_CONFIG_DATA = "stagingConfigData"
    static let PREPROD_CONFIG_DATA = "preProdConfigData"
    static let PROD_CONFIG_DATA = "prodConfigData"
    static let DEFAULT_CONFIG_DATA = "defaultConfigData"
    static let certFileSuffix = "-cert.p12"
    
    // Initialize UserDefaults and any other setup needed
    static func initialise(context: Any) {
        configUserDefaults = UserDefaults.standard
        
        let assetsPropertyReader = AssetsPropertyReader(context: context)
        let faceAuthProperties = assetsPropertyReader.getProperties("face_auth.properties")
        
        let certContent = self.loadCertificate(certFileName: Localization().PUBLIC_KEY_CER)
        
        
        let configParams = ConfigParams(
            auaCode: faceAuthProperties["AUA_CODE"] ?? "",
            auaLicenceKey: faceAuthProperties["AUA_LICENSE_KEY"] ?? "",
            asaCode: faceAuthProperties["ASA_CODE"] ?? "",
            asaLicenceKey: faceAuthProperties["ASA_LICENSE_KEY"] ?? "",
            signingCert: certContent ?? "",
            authUrl: faceAuthProperties["KYC_STAGING_URL"] ?? "",
            eKycUrl: faceAuthProperties["KYC_STAGING_URL"] ?? "",
            subAUACode: faceAuthProperties["SUB_AUA_CODE"] ?? "",
            p12Password: faceAuthProperties["P12_PASSWORD"] ?? "",
            signingP12Path: "default"
        )
        
        saveConfigData(configParams: configParams, configType: DEFAULT_CONFIG_DATA)
    }
    
    static func saveConfigData(configParams: ConfigParams, configType: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(configParams) {
            configUserDefaults.set(encoded, forKey: configType)
        }
    }
    
    static func getConfigData(configType: String) -> ConfigParams? {
        if let storedData = configUserDefaults.data(forKey: configType) {
            let decoder = JSONDecoder()
            return try? decoder.decode(ConfigParams.self, from: storedData)
        }
        return nil
    }
    
    static func isConfigExist() -> Bool {
        if getSelectedConfigEnv() == STAGING_CONFIG_DATA {
            return true
        }
        return configUserDefaults.data(forKey: getSelectedConfigEnv()) != nil
    }
    
    static func resetConfig(context: Any, configType: String) {
        configUserDefaults.removeObject(forKey: configType)
        
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(configType + certFileSuffix)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
                print("File deleted successfully")
            } catch {
                print("Error deleting file: \(error)")
            }
        }
    }
    
    static func getSelectedConfigEnv() -> String {
        var configDataType = DEFAULT_CONFIG_DATA
        
        let environmentTag = FaceRDManager.Shared.selectedEnvironment // Example, replace with actual environment variable
        switch environmentTag {
        case "S":
            configDataType = STAGING_CONFIG_DATA
        case "PP":
            configDataType = PREPROD_CONFIG_DATA
        case "P":
            configDataType = PROD_CONFIG_DATA
        default:
            break
        }
        return configDataType
    }
    
    static func saveCertificate(context: Any, configType: String, data: Data) {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent(configType + certFileSuffix)
        
        do {
            try data.write(to: fileURL)
            print("Certificate saved successfully")
        } catch {
            print("Error saving certificate: \(error)")
        }
    }
    
    // Helper method to load certificate from assets
    private static func loadCertificate(certFileName: String) -> String? {
        if let filePath = Bundle.main.path(forResource: certFileName, ofType: nil) {
            do {
                let certContent = try String(contentsOfFile: filePath)
                return certContent
            } catch {
                print("Error loading certificate: \(error)")
            }
        }
        return nil
    }
}

// Struct to represent the configuration params (replace with actual properties)
struct ConfigParams: Codable {
    let auaCode: String
    let auaLicenceKey: String
    let asaCode: String
    let asaLicenceKey: String
    let signingCert: String
    let authUrl: String
    let eKycUrl: String
    let subAUACode: String
    let p12Password: String
    let signingP12Path: String
}

// Dummy class for loading properties (you can adapt this as needed)
class AssetsPropertyReader {
    var context: Any
    
    init(context: Any) {
        self.context = context
    }
    
    func getProperties(_ filename: String) -> [String: String] {
        // Simulate loading properties from a file (you can adapt this to read from assets)
        return [
            "AUA_CODE": Localization().auaCode,
            "AUA_LICENSE_KEY": Localization().auaLisenceKey,
            "ASA_CODE": Localization().asaCode,
            "ASA_LICENSE_KEY": Localization().asaLisenceKey,
            "PUBLIC_KEY_CER": Localization().PUBLIC_KEY_CER + ".cer",
            "KYC_STAGING_URL": Localization().KYC_STAGING_URL,
            "SUB_AUA_CODE": Localization().subAuaCode,
            "P12_PASSWORD": Localization().p12Password
        ]
    }
}
