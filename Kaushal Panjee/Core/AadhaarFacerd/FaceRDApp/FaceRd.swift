

import Foundation
import SWXMLHash
internal import UIKit

class Localization {
    let signingCertificate =
    """
    -----BEGIN CERTIFICATE-----
    MIIGLjCCBRagAwIBAgIEAV5TQjANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJJ
    TjEYMBYGA1UEChMPZU11ZGhyYSBMaW1pdGVkMR0wGwYDVQQLExRDZXJ0aWZ5aW5n
    IEF1dGhvcml0eTE2MDQGA1UEAxMtZS1NdWRocmEgU3ViIENBIGZvciBDbGFzcyAz
    IE9yZ2FuaXNhdGlvbiAyMDIyMB4XDTIyMDkyNDEzMjk0OVoXDTI1MDkyMzEzMjk0
    OVowggEGMQswCQYDVQQGEwJJTjEOMAwGA1UEChMFVUlEQUkxDjAMBgNVBAsTBVVJ
    REFJMUkwRwYDVQQUE0A2Y2EyZTY4ZWE1NThlN2IzZjQ3YTFkYmI3MDAzMDc2MTcy
    OWFkZDM5ZTRkM2QzNmNkMzJiOGRlOWNmNWNlMzQ3MQ8wDQYDVQQREwY1NjAwOTIx
    EjAQBgNVBAgTCUtBUk5BVEFLQTFJMEcGA1UEBRNAYjk5YzAwMWVmNWI2NzlmYTk2
    NzBmNmU4NWY2MGIwODM2NzA0YmIyNDdjZGQ5MzNjOWRhZmQ3MzkxZmNjNWI3ZTEc
    MBoGA1UEAxMTS0lSQU4gS1VNQVIgR1VNTUFESTCCASIwDQYJKoZIhvcNAQEBBQAD
    ggEPADCCAQoCggEBAJ3W6Ku2SLnljjZPaO0Ey+C4a7FctrKhTE/IMkPwr4GB2KtX
    mDfwXGt2nYKyIsngyfS76F7gr+8a8+Uzjp3cBkUQUyT9QHpfvdfEWUAvGrVy0tVp
    rDzJc5XdzqTlEUTrZZGcpXKAb5K5Y4C3CF5sfq2fqD2rCX9C0Guha8bxmCSS/0Oo
    5M5aK0OOkp05t26XMPJuQRBjOwhgWL9elvcTkFZpymdVxt4citSvdOMuKs35M6et
    F/hEd7Bb6BOTla0Jqwnyv7koqqHnDAth0Smn5cqt7RmlJgety2IMfXE6IjIaoEEZ
    vZS2ZP4XDCpENUWvMogtbnIn3E5h/VtSNXhsoekCAwEAAaOCAigwggIkMCEGA1Ud
    EQQaMBiBFmFkYXV0aC50Y0B1aWRhaS5uZXQuaW4wHwYDVR0jBBgwFoAUsg3QU6M3
    o65VgkuZPUYoHIlWS6wwHQYDVR0OBBYEFAUqbf5BnvHGGCe1lFSeRFoZu2t5MAwG
    A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgUgMBkGA1UdJQEB/wQPMA0GCysGAQQB
    gjcKAwQBMIG7BgNVHSAEgbMwgbAwLQYGYIJkZAIDMCMwIQYIKwYBBQUHAgIwFRoT
    Q2xhc3MgMyBDZXJ0aWZpY2F0ZTAtBgZggmRkAgIwIzAhBggrBgEFBQcCAjAVGhND
    bGFzcyAyIENlcnRpZmljYXRlMFAGB2CCZGQBCAIwRTBDBggrBgEFBQcCARY3aHR0
    cDovL3d3dy5lLW11ZGhyYS5jb20vcmVwb3NpdG9yeS9jcHMvZS1NdWRocmFfQ1BT
    LnBkZjB9BggrBgEFBQcBAQRxMG8wJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmUt
    bXVkaHJhLmNvbTBHBggrBgEFBQcwAoY7aHR0cDovL3d3dy5lLW11ZGhyYS5jb20v
    cmVwb3NpdG9yeS9jYWNlcnRzL2VtY2wzb3JnMjAyMi5jcnQwSQYDVR0fBEIwQDA+
    oDygOoY4aHR0cDovL3d3dy5lLW11ZGhyYS5jb20vcmVwb3NpdG9yeS9jcmxzL2Vt
    Y2wzb3JnMjAyMi5jcmwwDQYJKoZIhvcNAQELBQADggEBALRdPJI4eISa/DH6KkSw
    JDg0pewnHp/JfNh5U+1406e18+3XfCgeKnmYFKw/LjGlvN+5/l4R7McoBWELCysk
    o4ZgImCKjzcWdowaqsW1yCjWmnvAmF9/L31LQoo/mQM0djYyq3hFMEvT7cRf+GI1
    nBM10Suu2YClY7wLR1avCDpskZttzTPgQWV7eEFcdDM4RQVGwbEwOsyecg9q3JiJ
    2Yh9wC1gSBHsWFpy1rqDWXcOsG7J0te++y2GpZRMp+sbtcOkksLAhsNkELR8eqGy
    Ct/Vjqs4gL5+a85R2mNWsfAER8y1NgTkYfosHFY5OkC62zEJP0CuWI4S4BCtcWtE
    ojA=
    -----END CERTIFICATE-----
    """
    
    
    let auaCode = "public"
    let asaCode = "1026NREGA"
    let subAuaCode = "1026NREGA"
    let auaLisenceKey = "NREGAtWCBWFKCDkzc7RN"
    let asaLisenceKey = "1026NREGA"
    let authUrl = "https://developer.uidai.gov.in/uidkyc/kyc/2.5"
    let ekycUrl = "https://developer.uidai.gov.in/uidkyc/kyc/2.5"
    let auaSigning = "default"
    let p12Password = "public"
    let WADH_KEY = "sgydIC09zzy6f8Lb3xaAqzKquKe9lFcNR9uTvYxFp+A="
    let language = "en"
    let purpose = "auth"
    let AUTH_VERSION = "2.5"
    

    let KYC_STAGING_URL = "http://developer.uidai.gov.in/authserver/2.5/public"
    let AUTH_TID = "registered"
    let RESIDENT_CONCENT = "Y"
    
    let PUBLIC_KEY_CER = "uidai_auth_pre_prod"
    let P12_FILE_NAME = "NewPublicAUAforStagingServices"
}
// MARK: - FaceRD Delegate

protocol FaceRDManagerDelegate: AnyObject {

    func didReceiveResponse(
        success: Bool,
        message: String?,
        response: String
    )
}


// MARK: - FaceRD Manager

final class FaceRDManager {

    // MARK: Singleton

    static let shared = FaceRDManager()

    // OLD PROJECT COMPATIBILITY
    // Agar kahin old code FaceRDManager.Shared use karta hai
    // to woh bhi kaam karega.
    static let Shared = shared

    private init() {}


    // MARK: Delegate

    weak var delegate: FaceRDManagerDelegate?


    // MARK: Environment

    var selectedEnvironment: String = "P"


    // MARK: Status

    var errorCode: String?

    var errorMessage: String?

    var successfulTransaction: Bool = false


    // MARK: FaceRD Scheme

    static let faceRDScheme = "FaceRDLib"


    // MARK: Callback Scheme

    static let callbackScheme = "facerdKPCallBack"


    // MARK: - Create PID XML

    func createPidXml(
        txnID: String
    ) -> String
    {

        let environment =
            selectedEnvironment

        let wadh =
        Localization().WADH_KEY

        let pidOptions = """

        <?xml version="1.0" encoding="UTF-8"?>

        <PidOptions
            ver="1.0"
            env="\(environment)"
        >

            <Opts
                fCount=""
                fType=""
                iCount=""
                iType=""
                pCount=""
                pType=""
                format=""
                pidVer="2.0"
                timeout=""
                otp=""
                wadh="\(wadh)"
                posh=""
            />

            <CustOpts>

                <Param
                    name="txnId"
                    value="\(txnID)"
                />

                <Param
                    name="purpose"
                    value="auth"
                />

                <Param
                    name="language"
                    value="en"
                />
        
                        <Param
                            name="callback"
                            value="facerdKPCallBack"
                        />

            </CustOpts>

        </PidOptions>

        """

        print("================================")
        print("PID OPTIONS")
        print("================================")
        print(pidOptions)

        return pidOptions
    }


    // MARK: - Create PID Options

    // MARK: - Create PID Options

    func createPidOptions(
        wadh: String,
        environment: String = "P"
    ) -> String {

        let transactionId = getTransactionID()

        let pidOptions = """
        <?xml version="1.0" encoding="UTF-8"?>
        <PidOptions ver="1.0" env="\(environment)">
            <Opts fCount="" fType="" iCount="" iType="" pCount="" pType="" format="" pidVer="2.0" timeout="" otp="" wadh="\(wadh)" posh="" />
            <CustOpts>
                <Param name="txnId" value="\(transactionId)"/>
                <Param name="purpose" value="auth"/>
                <Param name="language" value="en"/>
                <Param name="callback" value="\(Self.callbackScheme)"/>
            </CustOpts>
        </PidOptions>
        """

        print("================================")
        print("PID OPTIONS")
        print("================================")
        print(pidOptions)

        return pidOptions
    }

    // MARK: - Start FaceRD

    func startFaceAuthentication(
        pidOptions: String
    ) {

        print("================================")
        print("STARTING FACERD")
        print("================================")


        guard let encodedRequest =
                pidOptions.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )
        else {

            delegate?.didReceiveResponse(
                success: false,
                message: "Unable to encode FaceRD request",
                response: ""
            )

            return
        }


        let urlString =
            "\(Self.faceRDScheme)://in.gov.uidai.rdservice.face.CAPTURE?request=\(encodedRequest)"


        print("FaceRD URL:")
        print(urlString)


        guard let url =
                URL(string: urlString)
        else {

            delegate?.didReceiveResponse(
                success: false,
                message: "Invalid FaceRD URL",
                response: ""
            )

            return
        }


        // Check FaceRD App

        guard UIApplication.shared.canOpenURL(url)
        else {

            print("================================")
            print("FACERD APP NOT INSTALLED")
            print("================================")

            delegate?.didReceiveResponse(
                success: false,
                message: "Please install FaceRD App",
                response: ""
            )

            return
        }


        // Open FaceRD

        UIApplication.shared.open(
            url,
            options: [:]
        ) { success in

            print(
                "FaceRD open result: \(success)"
            )
        }
    }


    // MARK: - Old Project Compatibility
    // Agar kahin old code responseFaceRd() call karta hai

    func responseFaceRd(
        randomText: String,
        completionHandler: @escaping (URL?) -> Void
    ) {

        print("================================")
        print("RESPONSE FACERD")
        print("================================")

        let pidOptions = createPidOptions(
            wadh: Localization().WADH_KEY,
            environment: "P"
        )

        guard let encodedRequest =
                pidOptions.addingPercentEncoding(
                    withAllowedCharacters: .urlQueryAllowed
                )
        else {
            print("Unable to encode FaceRD request")
            completionHandler(nil)
            return
        }

        let urlString =
            "\(Self.faceRDScheme)://in.gov.uidai.rdservice.face.CAPTURE?request=\(encodedRequest)"

        print("FaceRD URL:")
        print(urlString)

        guard let url = URL(string: urlString) else {
            print("Invalid FaceRD URL")
            completionHandler(nil)
            return
        }

        guard UIApplication.shared.canOpenURL(url) else {
            print("FaceRD App not installed")
            completionHandler(nil)
            return
        }

        UIApplication.shared.open(
            url,
            options: [:]
        ) { success in

            print("FaceRD open result: \(success)")

            if success {
                completionHandler(url)
            } else {
                completionHandler(nil)
            }
        }
    }

    // MARK: - Handle FaceRD Callback

    func handleCallback(
        url: URL
    ) {

        print("================================")
        print("FACERD CALLBACK RECEIVED")
        print("================================")

        print(
            "Callback URL:"
        )

        print(
            url.absoluteString
        )


        let parameters =
            url.queryParameters


        print("FaceRD Parameters:")
        print(parameters)


        // MARK: Error Code

        if let currentErrorCode =
            parameters["request2"] {

            errorCode =
                currentErrorCode

            print(
                "FaceRD Error Code: \(currentErrorCode)"
            )
        }


        // MARK: Error Message

        if let currentErrorMessage =
            parameters["request3"] {

            errorMessage =
                currentErrorMessage

            print(
                "FaceRD Error Message: \(currentErrorMessage)"
            )
        }


        // MARK: Error

        if let error =
            parameters["error"],
           !error.isEmpty {

            print(
                "FaceRD Error: \(error)"
            )

            delegate?.didReceiveResponse(
                success: false,
                message: error,
                response: ""
            )

            return
        }


        // MARK: PID XML

        let pidData =
            parameters["request"]
            ?? parameters["response"]
            ?? parameters["PidData"]
            ?? ""


        guard !pidData.isEmpty
        else {

            print(
                "FaceRD PID data not found"
            )

            delegate?.didReceiveResponse(
                success: false,
                message: "FaceRD response data not found",
                response: ""
            )

            return
        }


        print("================================")
        print("PID DATA RECEIVED")
        print("================================")

        print(pidData)


        // MARK: Validate PID XML

        do {

            let parsedResponse =
                try CaptureResponse.fromXML(
                    inputXML: pidData
                )


            if parsedResponse.isSuccess {

                successfulTransaction =
                    true

                print(
                    "FaceRD capture successful"
                )

                delegate?.didReceiveResponse(
                    success: true,
                    message: "Success",
                    response: pidData
                )

            } else {

                successfulTransaction =
                    false

                let message =
                    parsedResponse.errInfo.isEmpty
                    ? "Face authentication failed"
                    : parsedResponse.errInfo

                print(
                    "FaceRD Capture Error: \(message)"
                )

                delegate?.didReceiveResponse(
                    success: false,
                    message: message,
                    response: pidData
                )
            }

        } catch {

            print(
                "Unable to parse FaceRD PID XML:"
            )

            print(error)


            // Agar XMLDecoder fail kare to bhi
            // PID data delegate ko return kar do.

            delegate?.didReceiveResponse(
                success: true,
                message: "FaceRD response received",
                response: pidData
            )
        }
    }


    // MARK: - Old Project Callback

    func handleURL(
        _ url: URL
    ) {

        handleCallback(
            url: url
        )
    }


    // MARK: - Random String

    func getTransactionID() -> String {
        
        let prefix = "KaushalPanjee"
        let suffix = "AEAD"
        
        // 12 digit random number
        let randomNumber = Int64.random(
            in: 100_000_000_000...999_999_999_999
        )
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let dateTime = dateFormatter.string(from: date)
        
        let transactionID = "\(prefix)\(randomNumber)\(dateTime)\(suffix)"
        
        return transactionID
    }
}


// MARK: - URL Query Parameters

extension URL {

    var queryParameters: [String: String] {

        var parameters:
            [String: String] = [:]


        guard let components =
                URLComponents(
                    url: self,
                    resolvingAgainstBaseURL: false
                )
        else {

            return parameters
        }


        guard let queryItems =
                components.queryItems
        else {

            return parameters
        }


        for item in queryItems {

            parameters[item.name] =
                item.value ?? ""
        }


        return parameters
    }
}
