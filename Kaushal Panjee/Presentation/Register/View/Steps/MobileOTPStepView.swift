import SwiftUI

struct MobileOTPStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    @FocusState private var otpFieldFocused: Bool

    var body: some View {

        VStack(
            spacing: 0
        ) {

            Spacer()

            // MARK: - Mobile OTP Icon

            Image(
                systemName: "lock.shield.fill"
            )
            .font(
                .system(
                    size: 48
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )

            // MARK: - Title

            Text(
                "Verify your mobile"
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
                "Enter the verification code sent to"
            )
            .font(
                .system(
                    size: 15,
                    weight: .regular
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .padding(
                .top,
                8
            )

            // MARK: - Mobile Number

            Text(
                "+91 \(viewModel.mobileNumber)"
            )
            .font(
                .system(
                    size: 16,
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
            .padding(
                .top,
                36
            )

            // MARK: - OTP Hint

            Text(
                "Enter the 4 digit OTP"
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
                    viewModel.errorMessage
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
                title: "VERIFY & CONTINUE",
                icon: "arrow.right",
                action: {

                    verifyMobileOTP()

                },
                isLoading: viewModel.isLoading,
                isDisabled: viewModel.otp.count != 4
            )
            .padding(
                .top,
                28
            )

            // MARK: - Resend OTP

            Button {

                viewModel.resendMobileOTP()

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
                    .font(
                        .system(
                            size: 14,
                            weight: .medium
                        )
                    )

                    Text(
                        "Resend OTP"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .semibold
                        )
                    )

                }
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

            // MARK: - Security Text

            HStack(
                spacing: 6
            ) {

                Image(
                    systemName: "lock.fill"
                )

                Text(
                    "Your verification is secure with us"
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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding(
            .horizontal,
            24
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
                    "VERIFY"
                ) {

                    verifyMobileOTP()

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

    // MARK: - Verify Mobile OTP

    private func verifyMobileOTP() {

        guard viewModel.otp.count == 4 else {
            return
        }

        hideKeyboard()

        viewModel.verifyMobileOTP()

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
