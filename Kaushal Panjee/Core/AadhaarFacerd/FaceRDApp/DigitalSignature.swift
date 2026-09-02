
import Foundation
import Security
import CommonCrypto

class DigitalSigner {
    
    
    private var privateKey: SecKey?
    private var certificateAlias:String?
    private var password:String?
    
    init(certFileName: String, password: String) throws {
        self.password = password
        self.certificateAlias = certFileName
        try loadKey()
    }
    
    var cert: Data? = nil
    var passwordData: [Character]? = nil
    // Load the private key from the P12 certificate
    private func loadKey() throws {
        // Load the P12 file data
        guard let certData = try? Data(contentsOf: getCertificateURL()) else {
            throw NSError(domain: "DigitalSignerError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to load certificate file"])
        }
        
        // Prepare options for importing the P12
        let options: [String: Any] = [kSecImportExportPassphrase as String: password as Any]
        var items: CFArray?
        
        // Import the P12 file
        let status = SecPKCS12Import(certData as CFData, options as CFDictionary, &items)
        guard status == errSecSuccess, let itemsArray = items as? [[String: Any]], let item = itemsArray.first else {
            throw NSError(domain: "DigitalSignerError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Unable to import P12 file"])
        }
        
        // Directly extract the identity (no need for a conditional cast)
        guard let identity = item[kSecImportItemIdentity as String] else {
            throw NSError(domain: "DigitalSignerError", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Identity not found in P12 file"])
        }
        
        // Extract the private key from the identity
        var key: SecKey?
        let privateKeyStatus = SecIdentityCopyPrivateKey(identity as! SecIdentity, &key) // Cast to `SecIdentity`
        guard privateKeyStatus == errSecSuccess, let unwrappedKey = key else {
            throw NSError(domain: "DigitalSignerError", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Private key not found in P12 file"])
        }
        
        self.privateKey = unwrappedKey
    }
    
    
    // Get the file URL for the certificate
    private func getCertificateURL() -> URL {
        // Adjust this path based on your file location (e.g., app bundle or file system path)
        return Bundle.main.url(forResource: certificateAlias, withExtension: "p12")!
    }
    
    // Sign XML string
    func signXML(_ xmlString: String) throws -> String {
        guard let privateKey = self.privateKey else {
            throw NSError(domain: "DigitalSignerError", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Private key not loaded"])
        }
        
        // Convert XML string to Data
        guard let xmlData = xmlString.data(using: .utf8) else {
            throw NSError(domain: "DigitalSignerError", code: 1005, userInfo: [NSLocalizedDescriptionKey: "Unable to convert XML string to data"])
        }
        
        
        
        let filename = ConfigUtils.getSelectedConfigEnv() + ConfigUtils.certFileSuffix
        let filePath = self.getDocumentsDirectory().appendingPathComponent(filename).path
        do {
            self.cert = try Data(contentsOf: URL(fileURLWithPath: filePath))
                guard let p12Password = ConfigUtils.getConfigData(configType: ConfigUtils.getSelectedConfigEnv())?.p12Password else {
                    fatalError("Password not found.")
                }
            self.passwordData = Array(p12Password)
        } catch {
            print(error)
        }
        
        
       
        if self.cert == nil{
            // Create the digital signature (SHA1 + RSA)
            let signature = try signData(xmlData, privateKey: privateKey)
            
            // Convert the signature to base64 string for inclusion in the signed XML
            let base64Signature =  signature.base64EncodedString()
            return self.createSignedXML(signedString: xmlString) ?? ""
            return self.generateSignedXML(from: xmlString, withSignature: base64Signature)
        }else{
            print("No xml Found")
            return ""
        }
    }
    
    // Sign the data using the private key
    private func signData(_ data: Data, privateKey: SecKey) throws -> Data {
        var _: Unmanaged<CFError>?
        
        let algorithm = SecKeyAlgorithm.rsaSignatureMessagePKCS1v15SHA256
        if SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) {
            var error: Unmanaged<CFError>?
            guard let signedData = SecKeyCreateSignature(privateKey, algorithm, data as CFData, &error) else {
                throw NSError(domain: "SigningError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to sign data: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")"])
            }
            return signedData as Data
        } else {
            throw NSError(domain: "AlgorithmError", code: 1, userInfo: [NSLocalizedDescriptionKey: "RSA signing algorithm not supported by the key."])
        }
    }
    // Helper method to get the document directory URL (to replace `context.openFileInput` in Java)
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    // Base64 decode a string
    func base64Decode(_ base64String: String) -> Data? {
        return Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)
    }
    
    // Convert signed XML string to actual signed XML (could integrate further XML signing logic)
    private func generateSignedXML(from xmlString: String, withSignature signature: String) -> String {
        // Example: Incorporate signature into XML structure (this is just a placeholder approach)
        var signedXML = xmlString
        signedXML = signedXML.replacingOccurrences(of: "<Signature></Signature>", with: "<Signature>\(signature)</Signature>")
        return signedXML
    }
    
    private func calculateDigestValue(data: Data) -> String {
        let hash = data.sha1()
        return hash.base64EncodedString()
    }
    
    // Function to calculate the SignatureValue (RSA signature of the Digest)
    private func calculateSignatureValue(privateKey: SecKey, digestData: Data, algorithm: SecKeyAlgorithm) -> String? {
        var error: Unmanaged<CFError>?
        
        // Sign the digest with the private key
        guard let signedData = SecKeyCreateSignature(privateKey, algorithm, digestData as CFData, &error) else {
            print("Error signing data: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")")
            return nil
        }
        
        // Base64 encode the signature to get SignatureValue
        return (signedData as Data).base64EncodedString()
    }
    
    
    
    
    
    public func createSignedXML(signedString: String) -> String? {
        // Sample data to sign
        var signedXML = signedString
        let dataToSign = signedString.data(using: .utf8)!
        
        
        // Calculate DigestValue (SHA-1 hash)
        let digestValue = calculateDigestValue(data: dataToSign)
        
        // Calculate the DigestData (hash of the data)
        let digestData = dataToSign.sha1() // Using SHA-1 for the DigestValue
        
        guard let privateKey = self.privateKey else {
//            throw NSError(domain: "DigitalSignerError", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Private key not loaded"])
            return nil
        }
        
        
        // Calculate SignatureValue (signed DigestData)
        guard let signatureValue = calculateSignatureValue(privateKey: privateKey, digestData: digestData, algorithm: .rsaSignatureMessagePKCS1v15SHA1) else {
            print("Failed to calculate signature value.")
            return nil
        }
        
        if let (subjectName, cert) = loadCertificate() {
            print("X509SubjectName:", subjectName)
            print("X509Certificate:", cert)
            
            
            let signature1 = """
   <Signature
       xmlns="http://www.w3.org/2000/09/xmldsig#">
       <SignedInfo>
           <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-
       20010315"/>
           <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
           <Reference URI="">
               <Transforms>
                   <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
               </Transforms>
               <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
               <DigestValue> \(digestValue) </DigestValue>
           </Reference>
       </SignedInfo>
       <SignatureValue> \(signatureValue) </SignatureValue>aadhaar_face_rd_api_ver_1_0_ios.md
        
       <KeyInfo>
           <X509Data>
               <X509SubjectName>
                 \(subjectName)
               </X509SubjectName>
               <X509Certificate>
                 \(cert)
              </X509Certificate>
           </X509Data>
       </KeyInfo>
   </Signature>
"""
            
            
            signedXML =  signedXML.replacingOccurrences(of: "<Signature></Signature>", with: signature1)
            print("Signed XML: - \(signedXML)")
            return signedXML
        }else{
            return nil
        }
    }
    
   

    func loadCertificate() -> (String, String)? {
        guard let certPath = Bundle.main.path(forResource: Localization().P12_FILE_NAME, ofType: "p12"),
              let certData = NSData(contentsOfFile: certPath) else {
            return nil
        }

        let options: [String: Any] = [kSecImportExportPassphrase as String: Localization().p12Password]
        var items: CFArray?

        let status = SecPKCS12Import(certData, options as CFDictionary, &items)
        guard status == errSecSuccess, let itemsArray = items as? [[String: Any]],
              let firstItem = itemsArray.first,
              let identity = firstItem[kSecImportItemIdentity as String] else {
            return nil
        }

        
        
        var certificate: SecCertificate?
        SecIdentityCopyCertificate(identity as! SecIdentity, &certificate)

        guard let cert = certificate else { return nil }

        var trust: SecTrust?
        SecTrustCreateWithCertificates(cert, SecPolicyCreateBasicX509(), &trust)

        guard let trustRef = trust else { return nil }
        
        let certificateRef = SecTrustGetCertificateAtIndex(trustRef, 0)
        guard let certDataRef = SecCertificateCopyData(certificateRef!) as Data? else {
            return nil
        }

        let base64Cert = certDataRef.base64EncodedString()
        let subjectName = SecCertificateCopySubjectSummary(cert) as String? ?? "Unknown"

        return (subjectName, base64Cert)
    }
}



// Extension for SHA-1 hashing
extension Data {
    func sha1() -> Data {
        var hash = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        _ = hash.withUnsafeMutableBytes { hashBytes in
            self.withUnsafeBytes { messageBytes in
                CC_SHA1(messageBytes.baseAddress, CC_LONG(self.count), hashBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return hash
    }
}






//import Foundation
//import Security
//
//class DigitalSigner {
//
//    private var privateKey: SecKey?
//    private var publicKey: SecKey?
//    private var certificateAlias: String?
//    private var password: String?
//
//    init(p12FileName: String, p12Password: String, cerFileName: String) throws {
//        self.certificateAlias = p12FileName
//        self.password = p12Password
//        try loadPrivateKey(filrname: p12FileName)
//        try loadPublicKey(fromCerFile: cerFileName)
//    }
//
//    // Load the private key from the P12 certificate
//    private func loadPrivateKey(filrname:String) throws {
//        guard let certData = try? Data(contentsOf: getCertificateURL(filename: filrname, withExtension: "p12")) else {
//            throw NSError(domain: "DigitalSignerError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Unable to load P12 file"])
//        }
//
//        let options: [String: Any] = [kSecImportExportPassphrase as String: password as Any]
//        var items: CFArray?
//
//        let status = SecPKCS12Import(certData as CFData, options as CFDictionary, &items)
//        guard status == errSecSuccess, let itemsArray = items as? [[String: Any]], let item = itemsArray.first else {
//            throw NSError(domain: "DigitalSignerError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Unable to import P12 file"])
//        }
//
//        guard let identity = item[kSecImportItemIdentity as String] else {
//            throw NSError(domain: "DigitalSignerError", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Identity not found in P12 file"])
//        }
//
//        var key: SecKey?
//        let privateKeyStatus = SecIdentityCopyPrivateKey(identity as! SecIdentity, &key)
//        guard privateKeyStatus == errSecSuccess, let unwrappedKey = key else {
//            throw NSError(domain: "DigitalSignerError", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Private key not found in P12 file"])
//        }
//
//        self.privateKey = unwrappedKey
//    }
//
//    // Load the public key from the .cer file
//    private func loadPublicKey(fromCerFile cerFileName: String) throws {
//        // Get certificate file URL
//        let certURL = getCertificateURL(filename: cerFileName, withExtension: "cer")
//        print("Certificate File URL: \(certURL)")
//
//        // Load certificate data
//        guard let certData = try? Data(contentsOf: certURL) else {
//            throw NSError(domain: "DigitalSignerError", code: 1005, userInfo: [NSLocalizedDescriptionKey: "Unable to load .cer file"])
//        }
//
//        print("Certificate Data: \(certData)")
//
//        // Create SecCertificate
//        guard let certificate = SecCertificateCreateWithData(nil, certData as CFData) else {
//            throw NSError(domain: "DigitalSignerError", code: 1006, userInfo: [NSLocalizedDescriptionKey: "Unable to create certificate. Ensure the file is in DER format."])
//        }
//
//        // Extract public key
//        guard let publicKey = SecCertificateCopyKey(certificate) else {
//            throw NSError(domain: "DigitalSignerError", code: 1007, userInfo: [NSLocalizedDescriptionKey: "Unable to extract public key from .cer file"])
//        }
//
//        self.publicKey = publicKey
//        print("Public Key Loaded Successfully")
//    }
//
//
//    // Get the file URL for the certificate
//    private func getCertificateURL(filename:String,withExtension fileExtension: String) -> URL {
//        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
//            fatalError("Certificate file not found in bundle")
//        }
//        return url
//    }
//
//    // Sign XML string
//    func signXML(_ xmlString: String) throws -> String {
//        guard let privateKey = privateKey else {
//            throw NSError(domain: "DigitalSignerError", code: 1008, userInfo: [NSLocalizedDescriptionKey: "Private key not loaded"])
//        }
//
//        guard let xmlData = xmlString.data(using: .utf8) else {
//            throw NSError(domain: "DigitalSignerError", code: 1009, userInfo: [NSLocalizedDescriptionKey: "Unable to convert XML string to data"])
//        }
//
//        // Create the digital signature (SHA256 + RSA)
//        let signature = try signData(xmlData, privateKey: privateKey)
//
//        // Convert the signature to base64 string for inclusion in the signed XML
//        let base64Signature = signature.base64EncodedString()
//        return self.generateSignedXML(from: xmlString, withSignature: base64Signature)
//    }
//
//    // Sign the data using the private key
//    private func signData(_ data: Data, privateKey: SecKey) throws -> Data {
//        let algorithm = SecKeyAlgorithm.rsaSignatureMessagePKCS1v15SHA256
//        guard SecKeyIsAlgorithmSupported(privateKey, .sign, algorithm) else {
//            throw NSError(domain: "AlgorithmError", code: 1010, userInfo: [NSLocalizedDescriptionKey: "RSA signing algorithm not supported by the private key"])
//        }
//
//        var error: Unmanaged<CFError>?
//        guard let signedData = SecKeyCreateSignature(privateKey, algorithm, data as CFData, &error) else {
//            throw NSError(domain: "SigningError", code: 1011, userInfo: [NSLocalizedDescriptionKey: "Failed to sign data: \(error?.takeRetainedValue().localizedDescription ?? "Unknown error")"])
//        }
//        return signedData as Data
//    }
//
//    // Generate the signed XML string
//    private func generateSignedXML(from xmlString: String, withSignature signature: String) -> String {
//        var signedXML = xmlString
//        signedXML = signedXML.replacingOccurrences(of: "<Signature></Signature>", with: "<Signature>\(signature)</Signature>")
//        return signedXML
//    }
//}


//// Create the XML with DigestValue and SignatureValue
//let signature = """
//                               <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
//                               <SignedInfo>
//                                   <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>
//                                   <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>
//                                   <Reference URI="">
//                                       <Transforms>
//                                           <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>
//                                       </Transforms>
//                                       <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>
//                                       <DigestValue>\(digestValue)</DigestValue>
//                                   </Reference>
//                               </SignedInfo>
//                               <SignatureValue>\(signatureValue)</SignatureValue>
//                               </Signature>
//                               """
