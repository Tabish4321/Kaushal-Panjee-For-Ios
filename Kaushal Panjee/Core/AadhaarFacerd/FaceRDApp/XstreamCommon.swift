
import Foundation
import XMLCoder
import SWXMLHash
import CommonCrypto



class XstreamCommonMethods {
    
    // Convert PID XML to PidData object
    static func pidXmlToPojo(xml: String) -> PidData? {
        guard let data = xml.data(using: .utf8) else { return nil }
        let decoder = XMLDecoder()
        do {
            let pidData = try decoder.decode(PidData.self, from: data)
            return pidData
        } catch {
            print("Error decoding PID XML:", error)
            return nil
        }
    }
    
    //    MARK: - Ekyc
    static func processPidBlockEkyc(pidXml: String, uid: String, isOtpUsed: Bool) throws -> String? {
        // Parse PID XML into PIDData object (implementation of `pidXmlToPojo` is assumed)
        guard let pidDataObject = XstreamCommonMethods.pidXmlToPojo(xml: pidXml) else {
            throw NSError(domain: "ErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse PID XML"])
        }
        
        // Create Auth object
        let auth = Auth(
            uid: uid,
            rc: Localization().RESIDENT_CONCENT,// Replace with actual resident consent.
            tid: Localization().AUTH_TID, // Replace with actual TID.
            ac: Localization().auaCode, // Replace with actual AUA code.
            sa: Localization().subAuaCode, // Replace with actual sub AUA code.
            ver: Localization().AUTH_VERSION, // Replace with actual version if needed.
            txn: "UKC:\(UUID().uuidString)",
            lk: Localization().auaLisenceKey,
            Uses: Uses(
                pi: "n",
                pa: "n",
                pfa: "n",
                bio: "y",
                bt: "FID",
                pin: "n",
                otp: isOtpUsed ? "y" : "n"
            ),
            Device:  Device(
                rdsId: pidDataObject.deviceInfo.rdsId,
                rdsVer: pidDataObject.deviceInfo.rdsVer,
                dpId: pidDataObject.deviceInfo.dpId,
                dc: pidDataObject.deviceInfo.dc,
                mi: pidDataObject.deviceInfo.mi,
                mc: pidDataObject.deviceInfo.mc
            ),
            Skey: pidDataObject.skey,
            Hmac: pidDataObject.hmac,
            Data: pidDataObject.data,
            Signature: ""
        )
        
        //         Convert Auth to XML
        let authXml = try self.convertToXML(auth)
        print("-------- Auth XML ----------\n\(authXml)")
        
        
        
        
        guard let authXML = self.createAuthXML(pidXml: pidXml, uid: uid, isOtpUsed: isOtpUsed) else {
            return nil
        }
        print("-------- Auth XML First ----------\n\(authXML)")
        
        
        
        // Digitally sign the XML
        do {
            // Initialize the signer with the certificate file and password
            let signer = try DigitalSigner(certFileName: Localization().P12_FILE_NAME, password: Localization().p12Password)
            let signedXML = try signer.signXML(authXML)
            
            let rad = authXML.data(using: .utf8)?.base64EncodedString()
            
            let ekyc = """
            <Kyc de="N" lr="N" pfr="N" ra="P" rc="Y" ver="2.5">
              <Rad>\(String.getString(rad))
            </Rad>
            </Kyc>
            """
            // Convert the KYC object to XML and return it
            return ekyc
        } catch {
            print("Error signing XML: \(error)")
            return nil
        }
    }
    
    
    // Process PID block for eKYC and generate Auth XML string
    static func processPidBlockAuth(pidXml: String, uid: String, isOtpUsed: Bool) throws -> String? {
        guard let pidDataObject = pidXmlToPojo(xml: pidXml) else { return nil }
        
        // Constructing Auth XML object
        let authXml = Auth(
            uid: uid,
            rc: Localization().RESIDENT_CONCENT,// Replace with actual resident consent.
            tid: Localization().AUTH_TID, // Replace with actual TID.
            ac: Localization().auaCode, // Replace with actual AUA code.
            sa: Localization().subAuaCode, // Replace with actual sub AUA code.
            ver: Localization().AUTH_VERSION, // Replace with actual version if needed.
            txn: "UKC:\(UUID().uuidString)",
            lk: Localization().auaLisenceKey, // Optional license key.
            Uses:  Uses(
                pi: "n",
                pa: "n",
                pfa: "n",
                bio: "y",
                bt: "FID",
                pin: "n",
                otp: isOtpUsed ? "y" : "n"
            ),
            Device:
                Device(
                    rdsId: pidDataObject.deviceInfo.rdsId,
                    rdsVer: pidDataObject.deviceInfo.rdsVer,
                    dpId: pidDataObject.deviceInfo.dpId,
                    dc: pidDataObject.deviceInfo.dc,
                    mi: pidDataObject.deviceInfo.mi,
                    mc: pidDataObject.deviceInfo.mc
                ),
            Skey: SKey(ci: pidDataObject.skey.ci, value: pidDataObject.skey.value),
            Hmac: pidDataObject.hmac,
            Data: DataField(type: pidDataObject.data.value, value: pidDataObject.data.type),
            Signature: ""
        )
        
        let encoder = XMLEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let xmlData = try encoder.encode(authXml)
            return String(data: xmlData, encoding:.utf8)
        } catch {
            print("Error encoding Auth XML:", error)
            return nil
        }
    }
    
    
    static func convertToXML<T: Encodable>(_ object: T) throws -> String {
        let encoder = XMLEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(object, withRootKey: String(describing: T.self), header: XMLHeader(version: 1.0, encoding: "UTF-8"))
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    static func signXML(_ xml: String) throws -> String {
        // Sign the XML (to be implemented)
        return "<SignedXML>\(xml)</SignedXML>"
    }
    
    static func getAuthErrorDescription(forErrorCode err: String) -> String {
        switch (err) {
        case "100":
            return "100 - Personal information demographic data did not match.";
        case "200":
            return "200 - Personal address demographic data did not match.";
        case "300":
            return "300 - Biometric data did not match.";
        case "310":
            return "310 - Duplicate fingers used.";
        case "311":
            return "311 - Duplicate Irises used.";
        case "312":
            return "312 - FMR and FIR cannot be used in the same transaction.";
        case "313":
            return "313 - Single FIR record contains more than one finger.";
        case "314":
            return "314 - Number of FMR/FIR should not exceed 10.";
        case "315":
            return "315 - Number of IIR should not exceed 2.";
        case "316":
            return "316 - Number of FID should not exceed 1.";
        case "330":
            return "330 - Biometrics locked by Aadhaar holder.";
        case "400":
            return "400 - Invalid OTP value.";
        case "402":
            return "402 - 'txn' value did not match with 'txn' value used in Request OTP API.";
        case "500":
            return "500 - Invalid encryption of session key.";
        case "501":
            return "501 - Invalid certificate identifier in 'ci' attribute of 'Skey'.";
        case "502":
            return "502 - Invalid encryption of PID.";
        case "503":
            return "503 - Invalid encryption of Hmac.";
        case "504":
            return "504 - Session key re-initiation required due to expiry or key out of sync.";
        case "505":
            return "505 - Synchronized Key usage not allowed for the AUA.";
        case "510":
            return "510 - Invalid Auth XML format.";
        case "511":
            return "511 - Invalid PID XML format.";
        case "512":
            return "512 - Invalid Aadhaar holder consent in 'rc' attribute of 'Auth'.";
        case "520":
            return "520 - Invalid 'tid' value.";
        case "521":
            return "521 - Invalid 'dc' code under Meta tag.";
        case "524":
            return "524 - Invalid 'mi' code under Meta tag.";
        case "527":
            return "527 - Invalid 'mc' code under Meta tag.";
        case "530":
            return "530 - Invalid authenticator code.";
        case "540":
            return "540 - Invalid Auth XML version.";
        case "541":
            return "541 - Invalid PID XML version.";
        case "542":
            return "542 - AUA not authorized for ASA.";
        case "543":
            return "543 - Sub-AUA not associated with 'AUA'.";
        case "550":
            return "550 - Invalid 'Uses' element attributes.";
        case "551":
            return "551 - Invalid 'tid' value.";
        case "553":
            return "553 - Registered devices currently not supported.";
        case "554":
            return "554 - Public devices are not allowed to be used.";
        case "555":
            return "555 - rdsId is invalid and not part of certification registry.";
        case "556":
            return "556 - rdsVer is invalid and not part of certification registry.";
        case "557":
            return "557 - dpId is invalid and not part of certification registry.";
        case "558":
            return "558 - Invalid dih.";
        case "559":
            return "559 - Device Certificate has expired.";
        case "560":
            return "560 - DP Master Certificate has expired.";
        case "561":
            return "561 - Request expired.";
        case "562":
            return "562 - Timestamp value is future time.";
        case "563":
            return "563 - Duplicate request.";
        case "564":
            return "564 - HMAC Validation failed.";
        case "565":
            return "565 - AUA license has expired.";
        case "566":
            return "566 - Invalid non-decryptable license key.";
        case "567":
            return "567 - Invalid input.";
        case "568":
            return "568 - Unsupported Language.";
        case "569":
            return "569 - Digital signature verification failed.";
        case "570":
            return "570 - Invalid key info in digital signature.";
        case "571":
            return "571 - PIN requires reset.";
        case "572":
            return "572 - Invalid biometric position.";
        case "573":
            return "573 - Pi usage not allowed as per license.";
        case "574":
            return "574 - Pa usage not allowed as per license.";
        case "575":
            return "575 - Pfa usage not allowed as per license.";
        case "576":
            return "576 - FMR usage not allowed as per license.";
        case "577":
            return "577 - FIR usage not allowed as per license.";
        case "578":
            return "578 - IIR usage not allowed as per license.";
        case "579":
            return "579 - OTP usage not allowed as per license.";
        case "580":
            return "580 - PIN usage not allowed as per license.";
        case "581":
            return "581 - Fuzzy matching usage not allowed as per license.";
        case "582":
            return "582 - Local language usage not allowed as per license.";
        case "586":
            return "586 - FID usage not allowed as per license.";
        case "587":
            return "587 - Name space not allowed.";
        case "588":
            return "588 - Registered device not allowed as per license.";
        case "590":
            return "590 - Public device not allowed as per license.";
        case "710":
            return "710 - Missing 'Pi' data as specified in 'Uses'.";
        case "720":
            return "720 - Missing 'Pa' data as specified in 'Uses'.";
        case "721":
            return "721 - Missing 'Pfa' data as specified in 'Uses'.";
        case "730":
            return "730 - Missing PIN data as specified in 'Uses'.";
        case "740":
            return "740 - Missing OTP data as specified in 'Uses'.";
        case "800":
            return "800 - Invalid biometric data.";
        case "810":
            return "810 - Missing biometric data as specified in 'Uses'.";
        case "811":
            return "811 - Missing biometric data in CIDR for the given Aadhaar number.";
        case "812":
            return "812 - Aadhaar holder has not done 'Best Finger Detection'.";
        case "820":
            return "820 - Missing or empty value for 'bt' attribute in 'Uses' element.";
        case "821":
            return "821 - Invalid value in the 'bt' attribute of 'Uses' element.";
        case "822":
            return "822 - Invalid value in the 'bs' attribute of 'Bio' element within 'Pid'.";
        case "901":
            return "901 - No authentication data found in the request.";
        case "902":
            return "902 - Invalid 'dob' value in the 'Pi' element.";
        case "910":
            return "910 - Invalid 'mv' value in the 'Pi' element.";
        case "911":
            return "911 - Invalid 'mv' value in the 'Pfa' element.";
        case "912":
            return "912 - Invalid 'ms' value.";
        case "913":
            return "913 - Both 'Pa' and 'Pfa' are present in the authentication request.";
        case "930":
            return "930 - Technical error internal to authentication server.";
        case "940":
            return "940 - Unauthorized ASA channel.";
        case "941":
            return "941 - Unspecified ASA channel.";
        case "950":
            return "950 - OTP store related technical error.";
        case "951":
            return "951 - Biometric lock related technical error.";
        case "980":
            return "980 - Unsupported option.";
        case "995":
            return "995 - Aadhaar suspended by competent authority.";
        case "996":
            return "996 - Aadhaar cancelled.";
        case "997":
            return "997 - Aadhaar suspended.";
        case "998":
            return "998 - Invalid Aadhaar Number.";
        case "999":
            return "999 - Unknown error.";
        default:
            return "NA - " + err;
        }
    }
    
    
    static func createAuthXML(pidXml: String, uid: String, isOtpUsed: Bool) -> String? {
        guard let pidDataObject = XstreamCommonMethods.pidXmlToPojo(xml: pidXml) else {
            return nil
        }
        
        let xml = """
    <Auth ac="\(Localization().auaCode)" lk="\(Localization().auaLisenceKey)" rc="\(Localization().RESIDENT_CONCENT)" sa="\(Localization().subAuaCode)" tid="\(Localization().AUTH_TID)" txn="UKC:\(UUID().uuidString)" uid="\(uid)" ver="\(Localization().AUTH_VERSION)">
    <Data type="\(pidDataObject.data.type)">\(pidDataObject.data.value)</Data>
    <Hmac>\(pidDataObject.hmac)</Hmac>
    <Meta dc="\(pidDataObject.deviceInfo.dc)" dpId="\(pidDataObject.deviceInfo.dpId)" mc="\(pidDataObject.deviceInfo.mc)" mi="\(pidDataObject.deviceInfo.mi)" rdsId="\(pidDataObject.deviceInfo.rdsId)" rdsVer="\(pidDataObject.deviceInfo.rdsVer)"/>
    <Skey ci="\(pidDataObject.skey.ci)">\(pidDataObject.skey.value)</Skey>
    <Uses bio="y" bt="FID" otp="n" pa="n" pfa="n" pi="n" pin="n"/>
    </Auth>
    """
        return xml
    }
}





// Base64 encode the signed XML
//            let rad = signedXML.data(using: .utf8)?.base64EncodedString() ?? ""
// Create the KYC object
//            let kyc = Kyc(
//                de: "N",
//                lr: "N",
//                pfr: "N",
//                ra: "P",
//                rc: "Y",
//                ver: Localization().AUTH_VERSION,
//                Rad: rad
//            )
//
//
//
//            let signedxml = signer.createSignedXML(signedString: authXML)
//            print("Signed XML: \(String(describing: signedxml))")


