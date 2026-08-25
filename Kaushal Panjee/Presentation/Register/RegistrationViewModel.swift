import Foundation
import Combine

@MainActor
final class RegistrationViewModel: ObservableObject {

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

    @Published var candidateId = ""

    @Published var stateList: [StateItem] = []

    @Published var selectedState: StateItem?

    @Published var selectedStateLGDCode = ""

    @Published var selectedStateCode = ""

    @Published var aadhaarNumber = ""

    @Published var isConsentAccepted = false

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

            errorMessage =
                "Please select a state"

            return
        }

        guard !selectedStateLGDCode.isEmpty else {

            errorMessage =
                "State LGD code is missing"

            return
        }

        clearMessages()

        aadhaarNumber = ""

        isConsentAccepted = false

        step = .aadhaar
    }

    // MARK: - Aadhaar Validation

    func verifyAadhaar() {

        clearMessages()

        guard aadhaarNumber.count == 12 else {

            errorMessage =
                "Please enter a valid 12 digit Aadhaar number"

            return
        }

        guard aadhaarNumber.allSatisfy({
            $0.isNumber
        }) else {

            errorMessage =
                "Aadhaar number must contain only digits"

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

        print("========== AADHAAR DATA ==========")
        print("Candidate ID: \(candidateId)")
        print("State: \(selectedState?.stateName ?? "")")
        print("State Code: \(selectedStateCode)")
        print("LGD State Code: \(selectedStateLGDCode)")
        print("Aadhaar Number: \(aadhaarNumber)")
        print("Consent Accepted: \(isConsentAccepted)")
        print("==================================")

        // NEXT API YAHAN CALL HOGI
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
            step = .email

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
}
