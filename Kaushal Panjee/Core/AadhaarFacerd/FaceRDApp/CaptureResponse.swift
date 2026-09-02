//
//  CaptureResponse.swift
//  Awaas Plus
//
//  Created by Unicloud Labs Pvt Ltd on 09/01/25.
//

import XMLCoder
import Foundation
import SWXMLHash
internal import UIKit

let prod = "http://10.247.252.93:8080/NicASAServer/ASAMain"
let UIDAI_URL_P = "https://nregarep2.nic.in/uid_gramg/stateservices/Uid_Face_Auth_DDUGKY.svc/PostOnAUA_Face_auth"

// Define the necessary structures
struct CaptureResponse: Codable {
    var resp: Resp
    var deviceInfo: DeviceInfo?
    var skey: SKey?
    var hmac: String?
    var data: DataField?
    var custOpts: CustOpts?

    // Convert to XML
    func toXML() throws -> String {
        let xmlEncoder = XMLEncoder()
        xmlEncoder.outputFormatting = .prettyPrinted
        let xmlData = try xmlEncoder.encode(self, withRootKey: "CaptureResponse", header: XMLHeader(version: 1.0, encoding: "UTF-8"))
        return String(data: xmlData, encoding: .utf8) ?? ""
    }

    // Static method to create CaptureResponse from CaptureRdResponse
    static func fromCaptureRdResponse(rdResponse: PidData, txnStatus: String) -> CaptureResponse {
        var captureResponse = CaptureResponse(
            resp: rdResponse.resp,
            deviceInfo: rdResponse.deviceInfo,
            skey: rdResponse.skey,
            hmac: rdResponse.hmac,
            data: rdResponse.data,
            custOpts: rdResponse.custOpts
        )

        if captureResponse.custOpts == nil {
            captureResponse.custOpts = CustOpts(params: [])
        }


        // Add transaction status if not empty
        if !txnStatus.isEmpty {
            let txnStatusParam = Param(name: "txnStatus", value: txnStatus)
            captureResponse.custOpts?.params.append(txnStatusParam)
        }

        return captureResponse
    }

    // Static method to create CaptureResponse for error scenario
    static func forError(resp: Resp, txnId: String) -> CaptureResponse {
        var captureResponse = CaptureResponse(resp: resp)
        captureResponse.custOpts = CustOpts(params: [Param(name: "txnId", value: txnId)])
        return captureResponse
    }

    // Static method to parse from XML string
    static func fromXML(inputXML: String) throws -> CaptureResponse {
        let xmlDecoder = XMLDecoder()
        let captureResponse = try xmlDecoder.decode(CaptureResponse.self, from: inputXML.data(using: .utf8)!)
        return captureResponse
    }

    // Check success status
    var isSuccess: Bool {
        return Int(resp.errCode) == 0
    }

    // Get error information
    var errInfo: String {
        return resp.errInfo
    }

    // Get error code
    var errCode: Int {
        return Int(resp.errCode) ?? -1
    }

    // Get txnId from custOpts
    var txnID: String {
        guard let custOpts = custOpts else { return "" }
        for param in custOpts.params {
            if param.name == "txnId" {
                return param.value
            }
        }
        return ""
    }


    // MARK: - Decode Function

    static func parseXML(xmlString: String) -> PidData?{
        // Convert XML string to data
        guard let xmlData = xmlString.data(using: .utf8) else { return nil}
        
        do {
            // Use XMLDecoder to decode the XML string to a CaptureRdResponse object
            let decoder = XMLDecoder()
            let response = try decoder.decode(PidData.self, from: xmlData)
            
            // Access parsed data
            print("Transaction ID: \(String(describing: response.custOpts.params.first?.value))")
            print("Response Error Code: \(response.resp.errCode)")
            
            // Example: Accessing the device information
            print("Device Info: \(response.deviceInfo)")
            return response
            
        } catch {
            print("Failed to decode XML: \(error)")
            return nil
        }
    }
}




