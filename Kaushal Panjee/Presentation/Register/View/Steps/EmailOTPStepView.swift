import SwiftUI

struct EmailOTPStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel
    

    @FocusState private var otpFieldFocused: Bool

    @EnvironmentObject
    private var languageManager: LanguageManager

    var body: some View {
        VStack(
            spacing: 0
        ) {

            // MARK: - Email OTP Icon
            Image(
                systemName: "envelope.badge.fill"
            )
            .font(
                .system(
                    size: 48
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
            .padding(
                .top,
                30
            )

            // MARK: - Title
            Text(
                verbatim: languageManager.localized(
                    "registration.verify_email"
                )
            )
            .font(
                .system(
                    size: 26,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
            .padding(
                .top,
                20
            )

            // MARK: - Subtitle
            Text(
                verbatim: languageManager.localized(
                    "registration.otp_sent_to"
                )
            )
            .font(
                .system(
                    size: 15
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .padding(
                .top,
                8
            )

            // MARK: - Email
            Text(
                verbatim: viewModel.email
            )
            .font(
                .system(
                    size: 15,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
            .padding(
                .top,
                4
            )

            // MARK: - OTP Input
            OTPInputView(
                otp: $viewModel.otp,
                isFocused: $otpFieldFocused
            )
            .padding(
                .top,
                36
            )

            // MARK: - OTP Hint
            Text(
                verbatim: languageManager.localized(
                    "registration.otp_4_digit"
                )
            )
            .font(
                .system(
                    size: 12
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .padding(
                .top,
                12
            )

            // MARK: - Error
            if !viewModel.errorMessage.isEmpty {
                Text(
                    verbatim: viewModel.errorMessage
                )
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.red
                )
                .multilineTextAlignment(
                    .center
                )
                .padding(
                    .top,
                    12
                )
            }

            // MARK: - Verify Button
            AppButton(
                title: languageManager.localized(
                    "registration.verify_email"
                ),
                icon: "arrow.right",
                action: {
                    verifyEmailOTP()
                },
                isLoading: viewModel.isLoading,
                isDisabled:
                    viewModel.otp.count != 4
            )
            .padding(
                .top,
                28
            )

            // MARK: - Resend OTP
            Button {
                viewModel.resendEmailOTP()

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.5
                ) {
                    otpFieldFocused = true
                }
            } label: {
                HStack(
                    spacing: 8
                ) {
                    Image(
                        systemName: "arrow.clockwise"
                    )

                    Text(
                        verbatim: languageManager.localized(
                            "common.resend_otp"
                        )
                    )
                }
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
            }
            .buttonStyle(
                .plain
            )
            .disabled(
                viewModel.isLoading
            )
            .padding(
                .top,
                22
            )

            // MARK: - Security
            HStack(
                spacing: 6
            ) {
                Image(
                    systemName: "lock.fill"
                )

                Text(
                    verbatim: languageManager.localized(
                        "registration.verification_secure"
                    )
                )
            }
            .font(
                .system(
                    size: 12
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .padding(
                .top,
                20
            )

            Spacer(
                minLength: 20
            )
        }
        .padding(
            .horizontal,
            24
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .contentShape(
            Rectangle()
        )
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.4
            ) {
                otpFieldFocused = true
            }
        }
        .toolbar {
            ToolbarItemGroup(
                placement: .keyboard
            ) {
                Spacer()

                Button(
                    languageManager.localized(
                        "registration.verify_email"
                    )
                ) {
                    verifyEmailOTP()
                }
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
                .disabled(
                    viewModel.otp.count != 4 ||
                    viewModel.isLoading
                )
            }
        }
    }

    // MARK: - Verify Email OTP
    private func verifyEmailOTP() {

        guard viewModel.otp.count == 4 else {
            return
        }

        hideKeyboard()

        viewModel.verifyEmailOTP()
    }

    // MARK: - Hide Keyboard
    private func hideKeyboard() {

        otpFieldFocused = false

        UIApplication.shared.sendAction(
            #selector(
                UIResponder.resignFirstResponder
            ),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
