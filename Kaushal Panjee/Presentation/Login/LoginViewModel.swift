import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    // ============================================================
    // MARK: - Published Properties
    // ============================================================

    @Published var loginId = ""
    @Published var password = ""

    @Published var isLoading = false
    @Published var errorMessage = ""

    @Published var loginSuccess = false

    @Published var showUpdateDialog = false


    // ============================================================
    // MARK: - Repository
    // ============================================================

    private let repository: LoginRepository


    // ============================================================
    // MARK: - Init
    // ============================================================

    init(
        repository: LoginRepository
    ) {

        self.repository = repository
    }


    // ============================================================
    // MARK: - Login
    // ============================================================

    func login() {
        
        loginSuccess = false


        errorMessage = ""

        let trimmedLoginId =
            loginId.trimmingCharacters(
                in: .whitespacesAndNewlines
            )


        // --------------------------------------------------------
        // Validate Login ID
        // --------------------------------------------------------

        guard !trimmedLoginId.isEmpty else {

            errorMessage =
                NSLocalizedString(
                    "login.enter_id",
                    comment: ""
                )

            return
        }


        // --------------------------------------------------------
        // Validate Password
        // --------------------------------------------------------

        guard !password.isEmpty else {

            errorMessage =
                NSLocalizedString(
                    "login.enter_password",
                    comment: ""
                )

            return
        }


        Task {

            await performLogin()
        }
    }


    // ============================================================
    // MARK: - Perform Login
    // ============================================================

    private func performLogin() async {

        isLoading = true
        errorMessage = ""

        defer {

            isLoading = false
        }


        do {

            // ====================================================
            // STEP 1
            // Generate Token
            // ====================================================

            let tokenRequest = TokenRequest(

                appVersion:
                    AppUtil.appVersion(),

                imeiNo:
                    AppUtil.getDeviceId(),

                loginId:
                    loginId
            )

            let tokenResponse =
                try await repository.generateToken(
                    request: tokenRequest
                )


            // ====================================================
            // STEP 2
            // Check Token Response
            // ====================================================

            guard tokenResponse.responseCode == 200 else {

                errorMessage =
                    buildTokenResponseMessage(
                        tokenResponse
                    )

                return
            }


            // ====================================================
            // STEP 3
            // Get passString
            // ====================================================

            guard let passString = tokenResponse.passString,
                  !passString.isEmpty else {

                errorMessage =
                    NSLocalizedString(
                        "login.token_missing",
                        comment: ""
                    )

                return
            }


            // ====================================================
            // STEP 4
            // SHA-512 Password
            // ====================================================

            let shaPass =
                CryptoUtil.sha512(
                    password
                )


            // ====================================================
            // STEP 5
            // Final Password
            // ====================================================

            let finalPassword =
                CryptoUtil.sha512(
                    passString + shaPass
                )
            // ====================================================
            // STEP 4
            // Login Request
            // ====================================================

            let loginRequest = LoginRequest(

                loginId:
                    loginId,

                password:
                    finalPassword,

                imeiNo:
                    AppUtil.getDeviceId(),

                appVersion:
                    AppUtil.appVersion(),

                deviceName:
                    AppUtil.deviceName(),

                fcmToken:
                    ""
            )


            // ====================================================
            // STEP 5
            // Login API
            // ====================================================

            let loginResponse =
                try await repository.login(
                    request: loginRequest
                )


            // ====================================================
            // STEP 6
            // Response Handling
            // ====================================================

            handleLoginResponse(
                loginResponse
            )

        } catch {

            // ====================================================
            // API / Network Error
            // ====================================================

            errorMessage =
                error.localizedDescription
        }
    }


    // ============================================================
    // MARK: - Handle Login Response
    // ============================================================

    private func handleLoginResponse(
        _ response: LoginResponse
    ) {

        switch response.responseCode {

        // ========================================================
        // 200 - SUCCESS
        // ========================================================

        case 200:

            handleSuccess(
                response
            )


        // ========================================================
        // 203
        // ========================================================

        case 203:

            errorMessage =
                buildResponseMessage(
                    response
                )

            regenerateToken()


        // ========================================================
        // 301 - UPDATE REQUIRED
        // ========================================================

        case 301:

            errorMessage =
                buildResponseMessage(
                    response
                )

            showUpdateDialog = true


        // ========================================================
        // OTHER RESPONSE
        // ========================================================

        default:

            errorMessage =
                buildResponseMessage(
                    response
                )

            regenerateToken()
        }
    }


    // ============================================================
    // MARK: - Success
    // ============================================================
    private func handleSuccess(
        _ response: LoginResponse
    ) {

        guard let accessToken = response.accessToken,

         !accessToken.isEmpty else {

            errorMessage =
                NSLocalizedString(
                    "login.token_missing",
                    comment: ""
                )

            return
        }

        // Save token in Keychain

        KeychainManager.shared.save(
            key: KeychainKeys.accessToken,
            value: "Bearer " + accessToken
        )

        // Save Login ID

        AppPreferences.shared.saveUserId(
            loginId
        )

        // Save Login Status

        AppPreferences.shared.saveLoginStatus(
            true
        )

        // Navigate to Home

        loginSuccess = true
    }

    // ============================================================
    // MARK: - Regenerate Token
    // ============================================================

    private func regenerateToken() {

        Task {

            do {

                let tokenRequest =
                    TokenRequest(

                        appVersion:
                            AppUtil.appVersion(),

                        imeiNo:
                            AppUtil.getDeviceId(),

                        loginId:
                            loginId
                    )


                _ = try await repository.generateToken(
                    request: tokenRequest
                )

            } catch {

                // Token regeneration failed.
                // Keep original login error visible.
            }
        }
    }


    // ============================================================
    // MARK: - Response Message
    // ============================================================

    private func buildResponseMessage(
        _ response: LoginResponse
    ) -> String {

        let message =
            response.responseMsg.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let description =
            response.responseDesc.trimmingCharacters(
                in: .whitespacesAndNewlines
            )


        if !message.isEmpty,
           message != "OK" {

            return message
        }


        if !description.isEmpty,
           description != "OK" {

            return description
        }


        return NSLocalizedString(
            "login.invalid_credentials",
            comment: ""
        )
    }
    
    
    
    
    private func buildTokenResponseMessage(
        _ response: TokenResponse
    ) -> String {

        let message =
            response.responseMsg.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        let description =
            response.responseDesc.trimmingCharacters(
                in: .whitespacesAndNewlines
            )


        if !message.isEmpty,
           message != "OK" {

            return message
        }


        if !description.isEmpty,
           description != "OK" {

            return description
        }


        return NSLocalizedString(
            "login.invalid_credentials",
            comment: ""
        )
    }
}
