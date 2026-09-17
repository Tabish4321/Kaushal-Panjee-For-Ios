import Foundation
import Combine

@MainActor
final class RegistrationViewModel: ObservableObject , FaceRDManagerDelegate  {
    
    
    @Published var aadhaarName = ""
    @Published var aadhaarPhoto = ""
    @Published var aadhaarGender = ""
    @Published var aadhaarDOB = ""
    @Published var aadhaarFatherName = ""
    @Published var aadhaarState = ""
    @Published var aadhaarDistrict = ""
    @Published var aadhaarBlock = ""
    @Published var aadhaarVillage = ""
    @Published var aadhaarStreet = ""
    @Published var aadhaarPO = ""
    @Published var aadhaarPinCode = ""
    @Published var createdUserId = ""
    @Published var createdAppCode = ""
    
    @Published var showEkycSuccessDialog = false
    
    // MARK: - Registration Steps
    
    enum RegistrationStep {
        
        case email
        case emailOTP
        case mobile
        case mobileOTP
        case selectState
        case aadhaar
        case registrationComplete
    }
    
    // MARK: - Input
    
    @Published var email = ""
    @Published var mobileNumber = ""
    @Published var otp = ""
    
    // MARK: - Aadhaar
    
    @Published var aadhaarNumber = ""
    
    @Published var isAadhaarValid = false
    
    @Published var aadhaarValidationMessage = ""
    
    @Published var isConsentAccepted = false
    
    
    @Published var candidateId = ""
    
    @Published var stateList: [StateItem] = []
    
    @Published var selectedState: StateItem?
    
    @Published var selectedStateLGDCode = ""
    
    @Published var selectedStateCode = ""
    
    // MARK: - Verification
    
    @Published var isEmailVerified = false
    
    @Published var isMobileVerified = false
    
    // MARK: - UI State
    
    @Published var step: RegistrationStep = .email
    
    @Published var isLoading = false
    
    @Published var isLoadingStateList = false
    
    @Published var errorMessage = ""
    
    @Published var successMessage = ""
    
    // MARK: - Repository
    
    private let repository: RegistrationRepository
    
    // MARK: - Init
    
    init(
        repository: RegistrationRepository
    ) {
        self.repository = repository
        
        FaceRDManager.shared.delegate = self
    }
    // MARK: - Submit Email
    
    func submitEmail() {
        
        clearMessages()
        
        let trimmedEmail =
        email.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !trimmedEmail.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.enter_email",
                comment: ""
            )
            return
        }
        
        guard isValidEmail(
            trimmedEmail
        ) else {
            
            errorMessage = NSLocalizedString(
                "registration.valid_email",
                comment: ""
            )
            
            return
        }
        
        email = trimmedEmail
        
        Task {
            await sendEmailOTP(
                email: trimmedEmail
            )
        }
    }
    
    // MARK: - Skip Email
    
    func skipEmail() {
        
        clearMessages()
        
        email = ""
        
        otp = ""
        
        isEmailVerified = false
        
        step = .mobile
        
        
        
    }
    
    // MARK: - Submit Mobile
    
    func submitMobile() {
        
        clearMessages()
        
        let mobile =
        mobileNumber.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        guard !mobile.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.enter_mobile",
                comment: ""
            )
            return
        }
        
        guard mobile.count == 10 else {
            
            errorMessage = NSLocalizedString(
                "registration.mobile_10_digits",
                comment: ""
            )
            return
        }
        
        guard mobile.allSatisfy({
            $0.isNumber
        }) else {
            
            errorMessage = NSLocalizedString(
                "registration.mobile_only_digits",
                comment: ""
            )
            return
        }
        
        guard let firstDigit = mobile.first else {
            
            errorMessage = NSLocalizedString(
                "registration.valid_mobile",
                comment: ""
            )
            return
        }
        
        guard ["6", "7", "8", "9"].contains(
            String(firstDigit)
        ) else {
            errorMessage = NSLocalizedString(
                "registration.valid_indian_mobile",
                comment: ""
            )
            return
        }
        
        mobileNumber = mobile
        
        Task {
            await sendMobileOTP(
                mobileNumber: mobile
            )
        }
    }
    
    // MARK: - Verify Email OTP
    
    func verifyEmailOTP() {
        
        clearMessages()
        
        guard isValidOTP() else {
            
            errorMessage = NSLocalizedString(
                "registration.enter_otp",
                comment: ""
            )
            
            return
        }
        
        Task {
            await validateOTP()
        }
    }
    
    // MARK: - Verify Mobile OTP
    
    func verifyMobileOTP() {
        
        clearMessages()
        
        guard isValidOTP() else {
            
            errorMessage = NSLocalizedString(
                "registration.enter_otp",
                comment: ""
            )
            
            return
        }
        
        Task {
            await validateOTP()
        }
    }
    
    // MARK: - Send Email OTP API
    
    private func sendEmailOTP(
        email: String
    ) async {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response =
            try await repository.sendEmailOTP(
                email: email
            )
            
            handleSendOTPResponse(
                response,
                nextStep: .emailOTP
            )
            
        } catch {
            
            errorMessage =
            error.localizedDescription
        }
    }
    
    // MARK: - Send Mobile OTP API
    
    private func sendMobileOTP(
        mobileNumber: String
    ) async {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response =
            try await repository.sendMobileOTP(
                mobileNumber: mobileNumber
            )
            
            handleSendOTPResponse(
                response,
                nextStep: .mobileOTP
            )
            
        } catch {
            
            errorMessage =
            error.localizedDescription
        }
    }
    
    // MARK: - Handle Send OTP Response
    
    private func handleSendOTPResponse(
        _ response: SendMobileOTPResponse,
        nextStep: RegistrationStep
    ) {
        
        switch response.responseCode {
            
        case 200:
            
            otp = ""
            
            successMessage =
            response.responseDesc
            
            step = nextStep
            
        case 301:
            
            errorMessage = NSLocalizedString(
                "registration.update_application",
                comment: ""
            )
            
        case 207, 210:
            
            errorMessage =
            response.responseDesc
            
        default:
            
            errorMessage = response.responseDesc.isEmpty
                ? NSLocalizedString(
                    "registration.something_went_wrong",
                    comment: ""
                )
                : response.responseDesc
        }
    }
    
    // MARK: - Validate OTP API
    
    private func validateOTP() async {
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response: OtpValidateResponse
            
            switch step {
                
            case .emailOTP:
                
                response =
                try await repository.validateOTP(
                    email: email,
                    mobileNumber: "",
                    otp: otp
                )
                
            case .mobileOTP:
                
                response =
                try await repository.validateOTP(
                    email: "",
                    mobileNumber: mobileNumber,
                    otp: otp
                )
                
            default:
                return
            }
            
            handleValidateOTPResponse(
                response
            )
            
        } catch {
            
            errorMessage =
            error.localizedDescription
        }
    }
    
    // MARK: - Handle Validate OTP Response
    
    private func handleValidateOTPResponse(
        _ response: OtpValidateResponse
    ) {
        
        guard response.responseCode == 200 else {
            
            errorMessage =
            response.responseDesc
            
            return
        }
        
        
        
        switch step {
            
        case .emailOTP:
            
            isEmailVerified = true
            
            otp = ""
            
            step = .mobile
            
        case .mobileOTP:
            
            guard let candidateId =
                    response.candidateId,
                  !candidateId.isEmpty
            else {
                
                errorMessage = NSLocalizedString(
                    "registration.candidate_id_not_found",
                    comment: ""
                )
                
                return
            }
            
            // Save Candidate ID
            
            self.candidateId = candidateId
            
            isMobileVerified = true
            
            otp = ""
            
            // State API Call
            
            Task {
                await getStateList()
            }
            
        default:
            break
        }
    }
    
    // MARK: - Get State List
    
    func getStateList() async {
        
        guard !candidateId.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.candidate_id_missing",
                comment: ""
            )
            
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            
            let response =
            try await repository.getOTPVerifiedStateList(
                candidateId: candidateId
            )
            
            guard response.responseCode == 200 else {
                
                errorMessage = response.responseDesc ??
                    NSLocalizedString(
                        "registration.state_list_load_failed",
                        comment: ""
                    )
                
                return
            }
            
            let states =
            response.stateList ?? []
            
            guard !states.isEmpty else {
                
                errorMessage = NSLocalizedString(
                    "registration.state_list_not_available",
                    comment: ""
                )
                
                return
            }
            
            stateList = states
            
            selectedState = nil
            
            selectedStateLGDCode = ""
            
            selectedStateCode = ""
            
            step = .selectState
            
        } catch {
            
            errorMessage =
            error.localizedDescription
        }
    }
    
    // MARK: - Select State
    
    func selectState(
        _ state: StateItem
    ) {
        
        selectedState = state
        
        selectedStateLGDCode =
        state.lgdStateCode
        
        selectedStateCode =
        state.stateCode
    }
    
    // MARK: - Continue From State
    
    func continueFromState() {
        guard selectedState != nil else {
            errorMessage = NSLocalizedString(
                "registration.select_state",
                comment: ""
            )
            return
        }
        
        guard !selectedStateLGDCode.isEmpty else {
            errorMessage = NSLocalizedString(
                "registration.state_lgd_missing",
                comment: ""
            )
            return
        }
        
        clearMessages()
        
        aadhaarNumber = ""
        isAadhaarValid = false
        aadhaarValidationMessage = ""
        isConsentAccepted = false
        
        step = .aadhaar
    }
    
    
    // MARK: - Verify Aadhaar
    
    func verifyAadhaar() {
        
        clearMessages()
        
        guard isAadhaarValid else {
            
            errorMessage = NSLocalizedString(
                "registration.valid_aadhaar",
                comment: ""
            )
            
            return
        }
        
        guard isConsentAccepted else {
            
            errorMessage = NSLocalizedString(
                "registration.accept_consent",
                comment: ""
            )
            
            return
        }
        
        guard !selectedStateLGDCode.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.select_state",
                comment: ""
            )
            
            return
        }
        
        guard !candidateId.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.candidate_id_missing",
                comment: ""
            )
            
            return
        }
        
        Task {
            
            await checkAadhaar()
        }
    }
    
    
    // MARK: - Check Aadhaar API
    
    private func checkAadhaar() async {
        
        isLoading = true
        
        defer {
            
            isLoading = false
        }
        
        do {
            
            
            
            
            let response =
            try await repository.checkAadhaar(
                aadhaarNumber: aadhaarNumber
            )
            
            handleAadhaarCheckResponse(
                response
            )
            
        } catch {
            
            errorMessage =
            error.localizedDescription
        }
    }
    
    // MARK: - Handle Aadhaar Check Response
    
    private func handleAadhaarCheckResponse(
        _ response: AadhaarCheckResponse
    )
    {
        
        switch response.responseCode {
            
        case 200:
            
            successMessage =
            response.responseDesc
            
            print("================================")
            print("AADHAAR CHECK SUCCESS")
            print("Opening FaceRD...")
            print("================================")
            
            invokeFaceRD()
            
            
        case 301:
            
            errorMessage = NSLocalizedString(
                "registration.update_application",
                comment: ""
                )
            
            
        default:
            

            
            
            errorMessage = response.responseDesc.isEmpty
            ? NSLocalizedString(
                    "registration.something_went_wrong",
                    comment: ""
                ): response.responseDesc
            
          
        }
    }
    
    // MARK: - Invoke FaceRD
    
    private func invokeFaceRD() {
        
        print("================================")
        print("INVOKING FACERD")
        print("================================")
        
        
        
        
        let pidOptions =
        FaceRDManager.shared.createPidOptions(
            wadh: Localization().WADH_KEY,
            environment: "P"
        )
        
        
        FaceRDManager.shared.startFaceAuthentication(
            pidOptions: pidOptions
        )
    }
    
    
    // MARK: - Resend Email OTP
    
    func resendEmailOTP() {
        
        clearMessages()
        
        guard !email.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.email_missing",
                comment: ""
            )
            
            return
        }
        
        Task {
            
            await sendEmailOTP(
                email: email
            )
        }
    }
    
    // MARK: - Resend Mobile OTP
    
    func resendMobileOTP() {
        
        clearMessages()
        
        guard !mobileNumber.isEmpty else {
            
            errorMessage = NSLocalizedString(
                "registration.mobile_missing",
                comment: ""
            )
            
            return
        }
        
        Task {
            
            await sendMobileOTP(
                mobileNumber: mobileNumber
            )
        }
    }
    
    // MARK: - Back Navigation
    
    func goBack() {
        
        clearMessages()
        
        otp = ""
        
        switch step {
            
        case .email:
            break
            
        case .emailOTP:
            step = .email
            
        case .mobile:
            step = .emailOTP
            
        case .mobileOTP:
            step = .mobile
            
        case .selectState:
            step = .mobileOTP
            
        case .aadhaar:
            step = .selectState
            
        case .registrationComplete:
            step = .aadhaar
        }
    }
    // MARK: - OTP Validation
    
    private func isValidOTP() -> Bool {
        
        otp.count == 4 &&
        otp.allSatisfy {
            $0.isNumber
        }
    }
    
    // MARK: - Email Validation
    
    private func isValidEmail(
        _ email: String
    ) -> Bool {
        
        let pattern =
        "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        
        return NSPredicate(
            format: "SELF MATCHES %@",
            pattern
        )
        .evaluate(
            with: email
        )
    }
    
    // MARK: - Clear Messages
    
    private func clearMessages() {
        
        errorMessage = ""
        
        successMessage = ""
    }
    
    func validateAadhaar() {
        
        let cleanedAadhaar = aadhaarNumber.filter {
            $0.isNumber
        }
        
        aadhaarNumber = String(
            cleanedAadhaar.prefix(12)
        )
        
        guard aadhaarNumber.count == 12 else {
            
            isAadhaarValid = false
            
            aadhaarValidationMessage = ""
            
            return
        }
        
        let isValid = AadhaarValidator.shared.isValid(
            aadhaarNumber
        )
        
        isAadhaarValid = isValid
        
        aadhaarValidationMessage = isValid
            ? NSLocalizedString(
                "registration.valid_aadhaar",
                comment: ""
            )
            : NSLocalizedString(
                "registration.invalid_aadhaar",
                comment: ""
            )
    }
    
    
    // MARK: - FaceRDManagerDelegate
    
    func didReceiveResponse(
        success: Bool,
        message: String?,
        response: String
    ) {
        print("================================")
        print("FACERD RESPONSE RECEIVED")
        print("Success: \(success)")
        print("Message: \(message ?? "")")
        print("================================")
        
        if success {
            
            print("================================")
            print("PID DATA RECEIVED")
            print("================================")
            print(response)
            
            // 1. Parse FaceRD PID XML
            guard let pidData = CaptureResponse.parseXML(xmlString: response) else {
                errorMessage = NSLocalizedString(
                    "registration.facerd_processing_failed",
                    comment: ""
                )
                print("❌ PID XML parsing failed")
                return
            }
            
            print("✅ PID XML parsed successfully")
            print("FaceRD Error Code: \(pidData.resp.errCode)")
            print("FaceRD Error Info: \(pidData.resp.errInfo)")
            
            // 2. Check FaceRD response
            if pidData.resp.errCode != "0" {
                errorMessage = pidData.resp.errInfo.isEmpty
                ? NSLocalizedString(
                    "registration.face_auth_failed",
                    comment: ""
                )
                : pidData.resp.errInfo
                return
            }
            
            print("================================")
            print("PROCESSING EKYC")
            print("================================")
            
            // 3. Create eKYC request
            do {
                let ekycValue = try XstreamCommonMethods.processPidBlockEkyc(
                    pidXml: response,
                    uid: String.getString(aadhaarNumber),
                    isOtpUsed: true
                )
                
                print("================================")
                print("EKYC VALUE CREATED")
                print("================================")
                
                
                
                Task {
                    if let ekycValue = ekycValue {
                        Task {
                            await getDataFromEkyc(
                                ekyc: ekycValue
                            )
                        }
                    } else {
                        print("❌ eKYC value is nil")
                        errorMessage = NSLocalizedString(
                            "registration.ekyc_data_generation_failed",
                            comment: ""
                        )                    }
                }
                
                successMessage = "Face authentication successful"
                
            } catch {
                print("❌ eKYC processing failed: \(error)")
                errorMessage = NSLocalizedString(
                    "registration.facerd_processing_failed",
                    comment: ""
                )
            }
            
        } else {
            
            errorMessage = NSLocalizedString(
                "registration.face_auth_failed",
                comment: ""
            )
        }
    }
    
    
    // MARK: - EKYC API
    
    
    
    private func getDataFromEkyc(ekyc: String) async {
        
        print("================================")
        print("CALLING EKYC API")
        print("================================")
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        let parameter: [String: String] = [
            "input": ekyc,
            "url": prod
        ]
        
        do {
            
            // MARK: - Call eKYC API
            
            let response = try await repository.postEkyc(
                parameters: parameter
            )
            
            print("================================")
            print("EKYC API RESPONSE")
            print("================================")
            
            if let responseString = String(
                data: response,
                encoding: .utf8
            ) {
                print(responseString)
            }
            
            // MARK: - Parse JSON
            
            guard let json = try JSONSerialization.jsonObject(
                with: response,
                options: []
            ) as? [String: Any] else {
                
                print("❌ Invalid EKYC JSON response")
                
                errorMessage = NSLocalizedString(
                    "registration.invalid_aadhaar_response",
                    comment: ""
                )
                
                return
            }
            
            
            print("================================")
            print("EKYC JSON KEYS")
            print("================================")

            for key in json.keys {
                print("KEY: \(key)")
            }

            print("================================")
            print("FULL JSON DICTIONARY")
            print("================================")
            print(json)
            print("================================")

            guard let d = json["PostOnAUA_Face_authResult"] as? String else {
                print("❌ 'PostOnAUA_Face_authResult' not found in EKYC response")
                print("Available keys: \(json.keys)")
                errorMessage = NSLocalizedString(
                    "registration.aadhaar_details_failed",
                    comment: ""
                )
                return
            }

            print("✅ KycRes XML found")
            print("KycRes length: \(d.count)")
            // MARK: - Parse EKYC XML
            
            guard let ekycData = EkycDataHandler.shared.parseXML(xmlString: d) else {
                errorMessage = NSLocalizedString(
                    "registration.aadhaar_parse_failed",
                    comment: ""
                )
                return
            }

            // MARK: - Insert Aadhaar Transaction
            insertAadhaarTransaction(
                txnAadhaar: ekycData.txn ?? "",
                txnApp: FaceRDManager.shared.transactionId,
                ret: ekycData.ret ?? "",
                aadhaarCode: ekycData.code ?? ""
            )

            // MARK: - Check eKYC Result
            guard let uidData = ekycData.uidData else {
                errorMessage = NSLocalizedString(
                    "registration.aadhaar_auth_failed",
                    comment: ""
                )
                return
            }

            guard ekycData.isSuccess else {
                errorMessage = NSLocalizedString(
                    "registration.aadhaar_auth_failed",
                    comment: ""
                )
                return
            }
            
            // MARK: - Aadhaar Data
            
            aadhaarName = uidData.poi?.name ?? "N/A"
            aadhaarPhoto = uidData.pht ?? ""
            aadhaarGender = uidData.poi?.gender ?? "N/A"
            aadhaarDOB = uidData.poi?.dob ?? "N/A"
            aadhaarFatherName = uidData.poa?.co ?? "N/A"
            
            aadhaarState = uidData.poa?.state ?? "N/A"
            aadhaarDistrict = uidData.poa?.dist ?? "N/A"
            aadhaarBlock = uidData.poa?.subdist ?? "N/A"
            aadhaarVillage = uidData.poa?.vtc ?? "N/A"
            aadhaarStreet = uidData.poa?.loc ?? "N/A"
            aadhaarPO = uidData.poa?.po ?? "N/A"
            aadhaarPinCode = uidData.poa?.pc ?? "N/A"
            
            // MARK: - Print Aadhaar Data
            
            print("================================")
            print("AADHAAR EKYC DATA")
            print("================================")
            
            print("Name: \(aadhaarName)")
            print("Gender: \(aadhaarGender)")
            print("DOB: \(aadhaarDOB)")
            print("Father/Care Of: \(aadhaarFatherName)")
            print("State: \(aadhaarState)")
            print("District: \(aadhaarDistrict)")
            print("Block: \(aadhaarBlock)")
            print("Village: \(aadhaarVillage)")
            print("Street: \(aadhaarStreet)")
            print("PO: \(aadhaarPO)")
            print("PIN Code: \(aadhaarPinCode)")
            print("Photo Available: \(!aadhaarPhoto.isEmpty)")
            
            print("================================")
            print(" EKYC XML PARSED")
            print(" AADHAAR DATA EXTRACTED")
            print("================================")
            
            // MARK: - Create User
            print("================================")
            print("EKYC SUCCESS")
            print("CALLING CREATE USER API")
            print("================================")

            createUser()
            
        } catch {
            
            print("================================")
            print("❌ EKYC API ERROR")
            print("================================")
            
            print(error.localizedDescription)
            
            errorMessage = NSLocalizedString(
                "registration.aadhaar_details_failed",
                comment: ""
            )
        }
    }
    
    
    // MARK: - Insert Aadhaar Transaction

    func insertAadhaarTransaction(
        txnAadhaar: String,
        txnApp: String,
        ret: String,
        aadhaarCode: String
    )
    {
        
        let request = InsertAadhaarTxnReq(
            txnAadhaar: txnAadhaar,
            txnApp: txnApp,
            ret: ret,
            aadhaarCode: aadhaarCode
        )
        
        Task {
            do {
                let response = try await repository.insertAadhaarTxn(
                    request: request
                )
                
                print("========== INSERT AADHAAR TXN ==========")
                print("Response Code: \(response.responseCode)")
                print("Response Desc: \(response.responseDesc)")
                print("Response Msg: \(response.responseMsg)")
                print("=========================================")
                
            } catch {
                print("❌ Insert Aadhaar Transaction Error: \(error)")
            }
        }
    }
    
    
    
    
    // MARK: - Create User

    private func createUser() {

        print("================================")
        print("CREATE USER API")
        print("================================")

        // Encrypt all fields except:
        // appVersion
        // userConsent

        let encryptedAadhaar =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarNumber,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedName =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarName,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedGender =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarGender,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedDob =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarDOB,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedState =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarState,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedStateCode =
            AESUtil.encryptIntoBase64String(
                inputText: selectedStateCode,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedDistrict =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarDistrict,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedBlock =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarBlock,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedPO =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarPO,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedVillage =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarVillage,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedPinCode =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarPinCode,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedPhone =
            AESUtil.encryptIntoBase64String(
                inputText: mobileNumber,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedEmail =
            AESUtil.encryptIntoBase64String(
                inputText: email,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedCareOf =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarFatherName,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedStreet =
            AESUtil.encryptIntoBase64String(
                inputText: aadhaarStreet,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )

        let encryptedLgdCode =
            AESUtil.encryptIntoBase64String(
                inputText: selectedStateLGDCode,
                secretKey: AESUtil.cryptId,
                ivKey: AESUtil.cryptIV
            )
        let request = UserCreationReq(
            aadharNo: encryptedAadhaar,
            candidateName: encryptedName,
            gender: encryptedGender,
            dateOfBirth: encryptedDob,
            stateName: encryptedState,
            stateCode: encryptedStateCode,
            districtName: encryptedDistrict,
            blockName: encryptedBlock,
            postOffice: encryptedPO,
            village: encryptedVillage,
            pinCode: encryptedPinCode,
            mobileNo: encryptedPhone,
            email: encryptedEmail,
            careOf: encryptedCareOf,
            street: encryptedStreet,
            appVersion: AppUtil.appVersion(),
            aadharImage: aadhaarPhoto,
            imeiNo: AppUtil.getDeviceId(),
            stateLgdCode: encryptedLgdCode,
            userConsent: isConsentAccepted,
            fcmToken: ""
        )


        Task {
            do {
                isLoading = true
                defer {
                    isLoading = false
                }

                let response = try await repository.createUser(
                    request: request
                )

                print("================================")
                print("CREATE USER RESPONSE")
                print("Response Code: \(response.responseCode)")
                print("Response Desc: \(response.responseDesc)")
                print("Response Msg: \(response.responseMsg)")
                print("================================")

                guard response.responseCode == 200 else {

                    errorMessage = response.responseDesc.isEmpty
                        ? NSLocalizedString(
                            "registration.user_creation_failed",
                            comment: ""
                        )
                        : response.responseDesc

                    return
                }

                guard let user = response.wrappedList.first else {
                    errorMessage = NSLocalizedString(
                        "registration.user_details_not_found",
                        comment: ""
                    )
                    return
                }


                createdUserId = user.userId
                createdAppCode = user.appCode

                showEkycSuccessDialog = true

            } catch {

                print("❌ CREATE USER ERROR")
                print(error.localizedDescription)

                errorMessage = NSLocalizedString(
                    "registration.user_creation_failed_retry",
                    comment: ""
                )
            }
        }
    }}
