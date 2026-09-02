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
            
            errorMessage =
            "Please enter your email address"
            
            return
        }
        
        guard isValidEmail(
            trimmedEmail
        ) else {
            
            errorMessage =
            "Please enter a valid email address"
            
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
            
            errorMessage =
            "Please enter mobile number"
            
            return
        }
        
        guard mobile.count == 10 else {
            
            errorMessage =
            "Mobile number must be 10 digits"
            
            return
        }
        
        guard mobile.allSatisfy({
            $0.isNumber
        }) else {
            
            errorMessage =
            "Mobile number must contain only digits"
            
            return
        }
        
        guard let firstDigit = mobile.first else {
            
            errorMessage =
            "Please enter a valid mobile number"
            
            return
        }
        
        guard ["6", "7", "8", "9"].contains(
            String(firstDigit)
        ) else {
            
            errorMessage =
            "Please enter a valid Indian mobile number"
            
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
            
            errorMessage =
            "Please enter the 4 digit OTP"
            
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
            
            errorMessage =
            "Please enter the 4 digit OTP"
            
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
            
            errorMessage =
            "Please update the application"
            
        case 207, 210:
            
            errorMessage =
            response.responseDesc
            
        default:
            
            errorMessage =
            response.responseDesc.isEmpty
            ? "Something went wrong"
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
                
                errorMessage =
                "Candidate ID not found"
                
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
            
            errorMessage =
            "Candidate ID is missing"
            
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
                
                errorMessage =
                response.responseDesc ??
                "Unable to load state list"
                
                return
            }
            
            let states =
            response.stateList ?? []
            
            guard !states.isEmpty else {
                
                errorMessage =
                "State list not available"
                
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
            errorMessage = "Please select a state"
            return
        }
        
        guard !selectedStateLGDCode.isEmpty else {
            errorMessage = "State LGD code is missing"
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
            
            errorMessage =
            "Please enter a valid Aadhaar number"
            
            return
        }
        
        guard isConsentAccepted else {
            
            errorMessage =
            "Please accept the consent"
            
            return
        }
        
        guard !selectedStateLGDCode.isEmpty else {
            
            errorMessage =
            "Please select a state"
            
            return
        }
        
        guard !candidateId.isEmpty else {
            
            errorMessage =
            "Candidate ID is missing"
            
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
            
            errorMessage =
            "Please update the application"
            
            
        default:
            
            errorMessage =
            response.responseDesc.isEmpty
            ? "Something went wrong"
            : response.responseDesc
            
            invokeFaceRD()
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
            
            errorMessage =
            "Email address is missing"
            
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
            
            errorMessage =
            "Mobile number is missing"
            
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
        ? "Valid Aadhaar number"
        : "Invalid Aadhaar number"
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
                errorMessage = "Unable to process FaceRD response"
                print("❌ PID XML parsing failed")
                return
            }
            
            print("✅ PID XML parsed successfully")
            print("FaceRD Error Code: \(pidData.resp.errCode)")
            print("FaceRD Error Info: \(pidData.resp.errInfo)")
            
            // 2. Check FaceRD response
            if pidData.resp.errCode != "0" {
                errorMessage = pidData.resp.errInfo.isEmpty
                ? "Face authentication failed"
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
                print(ekycValue)
                
                
                
                Task {
                    if let ekycValue = ekycValue {
                        Task {
                            await getDataFromEkyc(
                                ekyc: ekycValue
                            )
                        }
                    } else {
                        print("❌ eKYC value is nil")
                        errorMessage = "Unable to generate eKYC data"
                    }
                }
                
                successMessage = "Face authentication successful"
                
            } catch {
                print("❌ eKYC processing failed: \(error)")
                errorMessage = "Unable to process eKYC"
            }
            
        } else {
            
            errorMessage =
            message ?? "Face authentication failed"
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

                errorMessage = "Invalid Aadhaar response"

                return
            }

            // MARK: - Get "d"

            guard let d = json["d"] as? String else {

                print("❌ 'd' not found in EKYC response")

                errorMessage = "Unable to fetch Aadhaar details"

                return
            }

            // MARK: - Parse EKYC XML

            guard let ekycData =
                    EkycDataHandler.shared.parseXML(
                        xmlString: d
                    ) else {

                print("❌ EKYC XML parsing failed")

                errorMessage = "Unable to parse Aadhaar details"

                return
            }

            // MARK: - UID Data

            guard let uidData = ekycData.uidData else {

                print("❌ UID Data not found")

                errorMessage = "Aadhaar details not found"

                return
            }

            // MARK: - Check EKYC Success

            guard ekycData.isSuccess else {

                print("================================")
                print("❌ EKYC FAILED")
                print("================================")

                print("Return: \(ekycData.ret ?? "")")
                print("Error: \(ekycData.err ?? "")")
                print("Code: \(ekycData.code ?? "")")

                errorMessage = "Aadhaar authentication failed"

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
            print("✅ EKYC XML PARSED")
            print("✅ AADHAAR DATA EXTRACTED")
            print("================================")

            // IMPORTANT
            // Old error ko clear karo
            errorMessage = ""

            successMessage = "Aadhaar verification successful"

            // IMPORTANT
            // Popup yahi se show hoga
            print("🎉 SHOWING EKYC SUCCESS POPUP")

            showEkycSuccessDialog = true

        } catch {

            print("================================")
            print("❌ EKYC API ERROR")
            print("================================")

            print(error.localizedDescription)

            errorMessage = "Unable to fetch Aadhaar details"
        }
    }}
