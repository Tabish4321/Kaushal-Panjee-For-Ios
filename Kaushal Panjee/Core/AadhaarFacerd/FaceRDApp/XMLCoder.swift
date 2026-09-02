//
//  XMLCoder.swift
//  Aadhaar Service
//
//  Created by Rohan Kumar on 06/08/26.
//

//import Foundation
import XMLCoder
import Foundation

// Modify your KycRes struct
struct KycRes: Codable {
    var rar: String?
    var uidData: UidData?
    var ret: String? // Mark ret as optional (this is fine if you expect it to be missing)
    var code: String?
    var txn: String? // Make txn optional
    var ts: String?
    var ttl: String?
    var err: String?
    var signature: String?
    
    // If `txn` is missing in the XML, it won't cause a decoding failure anymore
    enum CodingKeys: String, CodingKey {
        case rar
        case uidData = "UidData"
        case ret
        case code
        case txn
        case ts
        case ttl
        case err
        case signature = "Signature" // Assuming Signature has different case
    }
    // Computed property to check success
    var isSuccess: Bool {
        return String.getString(ret).lowercased() == "y"
    }
}

// Example UidData struct for reference
struct UidData: Codable {
    var tkn: String?
    var uid: String?
    var pht: String?
    var poi: Poi?
    var poa: Poa?
    var lData: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case pht = "Pht"
        case poi = "Poi"
        case poa = "Poa"
        case lData = "LData"
    }
}

struct Poi: Codable {
    var name: String?
    var gender: String?
    var dob: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case gender
        case dob
    }
}

struct Poa: Codable {
    var co: String?
    var country: String?
    var dist: String?
    var house: String?
    var lm: String?
    var loc: String?
    var pc: String?
    var po: String?
    var state: String?
    var street: String?
    var subdist: String?
    var vtc: String?
    
    enum CodingKeys: String, CodingKey {
        case co
        case country
        case dist
        case house
        case lm
        case loc
        case pc
        case po
        case state
        case street
        case subdist
        case vtc
    }
}




class EkycDataHandler{
    static let shared = EkycDataHandler()
    func parseXML(xmlString: String) -> KycRes?{
        // Convert XML string to data
        guard let xmlData = xmlString.data(using: .utf8) else { return nil}
        
        do {
            // Use XMLDecoder to decode the XML string to a CaptureRdResponse object
            let decoder = XMLDecoder()
            let response = try decoder.decode(KycRes.self, from: xmlData)
            
            // Access parsed data
            print("Ret : \(String(describing: response.ret))")
            if let uidData = response.uidData {
                print("Photo: \(String(describing: uidData.pht))")
                print("Name: \(String(describing: uidData.poa?.co))")
                print("POA Country: \(String(describing: uidData.poa?.country))")
            } else {
                print("No UID Data found")
            }
            return response
        } catch {
            print("Failed to decode XML: \(error)")
            return nil
        }
    }
}
