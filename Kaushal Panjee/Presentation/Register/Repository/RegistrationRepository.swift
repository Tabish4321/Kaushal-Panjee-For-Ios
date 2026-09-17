import Foundation
import Alamofire

final class RegistrationRepository {

    // MARK: - Properties

    private let apiClient: APIClient

    // MARK: - Init

    init(
        apiClient: APIClient = APIClient.shared
    ) {

        self.apiClient = apiClient
    }

    // MARK: - Send Email OTP

    func sendEmailOTP(
        email: String
    ) async throws -> SendMobileOTPResponse {

        let request = SendOtpEmailRequest(
            imeiNo: AppUtil.getDeviceId(),
            email: email,
            appVersion: AppUtil.appVersion()
        )

        return try await apiClient.request(
            endpoint: APIConstants.sendEmailOTP,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }

    // MARK: - Send Mobile OTP

    func sendMobileOTP(
        mobileNumber: String
    ) async throws -> SendMobileOTPResponse {

        let request = SendOTPRequest(
            imeiNo: AppUtil.getDeviceId(),
            mobileNumber: mobileNumber,
            appVersion: AppUtil.appVersion()
        )

        return try await apiClient.request(
            endpoint: APIConstants.sendMobileOTP,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }

    // MARK: - Validate OTP

    func validateOTP(
        email: String,
        mobileNumber: String,
        otp: String
    ) async throws -> OtpValidateResponse {

        let request = ValidateOtpRequest(
            appVersion: AppUtil.appVersion(),
            email: email,
            mobileNo: mobileNumber,
            imeiNo: AppUtil.getDeviceId(),
            otp: otp
        )

        return try await apiClient.request(
            endpoint: APIConstants.validateOTP,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }

    // MARK: - Get OTP Verified State List

    func getOTPVerifiedStateList(
        candidateId: String
    ) async throws -> StateDataResponse {

        let request = StateListRequest(
            appVersion: AppUtil.appVersion()        )

        let customHeaders: HTTPHeaders = [
            "CandidateId": candidateId
        ]

        return try await apiClient.request(
            endpoint: APIConstants.stateOtpList,
            method: .post,
            parameters: request,
            requiresAuth: false,
            additionalHeaders: customHeaders
        )
    }
    
    

    // MARK: - Check Aadhaar

    func checkAadhaar(
        aadhaarNumber: String
    ) async throws ->
    AadhaarCheckResponse {
        

        let encryptedAadhaar =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarNumber,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        guard !encryptedAadhaar.isEmpty else {

            throw NSError(
                domain: "AadhaarEncryption",
                code: -1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        NSLocalizedString(
                            "registration.aadhaar_encryption_failed",
                            comment: ""
                        )
                ]
            )
        }

        print("Encrypted Aadhaar:")
        print(encryptedAadhaar)

        let request =
            AadhaarCheckRequest(
                appVersion: AppUtil.appVersion(),
                userInput: encryptedAadhaar
            )

        return try await apiClient.request(
            endpoint: APIConstants.checkUserExistance,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
    
    
    
    
    // MARK: - Face Authentication eKYC
    func postEkyc(
        parameters: [String: String]
    ) async throws -> Data {

        let ekycURL = "https://nregarep2.nic.in/uid_gramg/stateservices/Uid_Face_Auth_DDUGKY.svc/PostOnAUA_Face_auth"

        return try await apiClient.requestExternalEkyc(
            url: ekycURL,
            parameters: parameters
        )
    }
    
    
    // MARK: - Insert Aadhaar Transaction

    func insertAadhaarTxn(
        request: InsertAadhaarTxnReq
    ) async throws -> InsertAadhaarTxnRes {

        return try await apiClient.request(
            endpoint: APIConstants.insertAadhaarTxn,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
    

    
    // MARK: - Create User

    func createUser(
        request: UserCreationReq
    ) async throws -> CreateUserRes {

        return try await apiClient.request(
            endpoint: APIConstants.API_CREATE_USER,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
    
}
