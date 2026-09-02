import SwiftUI

struct AadhaarStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    @FocusState private var isAadhaarFieldFocused: Bool

    @State private var isConsentExpanded = false

    private let shortConsentText =
        "I hereby state that I have no objection in authenticating myself with the Aadhaar-based authentication system and consent to providing my Aadhaar number..."

    private let fullConsentText =
        """
        I hereby state that I have no objection in authenticating myself with the Aadhaar-based authentication system and consent to providing my Aadhaar number, biometric and/or One Time Pin (OTP) data for Aadhaar-based authentication for the purposes of availing the Unified IT Platform for DDUGKY and RSETI from the National Informatics Centre.

        I understand that the biometrics and/or OTP I provide for authentication shall be used only for authenticating my identity through the Aadhaar authentication system for that specific transaction and for no other purposes.

        I understand that the National Informatics Centre shall ensure the security and confidentiality of my personal identity data provided for the purpose of Aadhaar-based authentication.
        """

    var body: some View {

        VStack(
            spacing: 0
        ) {

            Spacer(
                minLength: 10
            )

            VStack(
                alignment: .leading,
                spacing: 18
            ) {

                // MARK: - Top Icon

                Image(
                    systemName: "checkmark.shield.fill"
                )
                .font(
                    .system(
                        size: 34
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )


                // MARK: - Title

                Text(
                    "Aadhaar Verification"
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


                // MARK: - Description

                Text(
                    "Enter your 12 digit Aadhaar number to verify your identity."
                )
                .font(
                    .system(
                        size: 14
                    )
                )
                .foregroundStyle(
                    Color.appTextSecondary
                )


                // MARK: - Aadhaar Input

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text(
                        "Aadhaar Number"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )


                    HStack(
                        spacing: 0
                    ) {

                        // MARK: Aadhaar Icon

                        Image(
                            systemName: "person.text.rectangle"
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color.appDarkGreen
                        )
                        .frame(
                            width: 56,
                            height: 56
                        )


                        Rectangle()
                            .fill(
                                Color.appBorder
                            )
                            .frame(
                                width: 1,
                                height: 28
                            )


                        TextField(
                            "Enter 12 digit Aadhaar number",
                            text: aadhaarBinding
                        )
                        .keyboardType(
                            .numberPad
                        )
                        .textContentType(
                            .oneTimeCode
                        )
                        .focused(
                            $isAadhaarFieldFocused
                        )
                        .font(
                            .system(
                                size: 16,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color.appTextPrimary
                        )
                        .padding(
                            .horizontal,
                            16
                        )
                    }
                    .frame(
                        height: 56
                    )
                    .background(
                        Color.appCard
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14
                        )
                    )
                    .overlay {

                        RoundedRectangle(
                            cornerRadius: 14
                        )
                        .stroke(
                            aadhaarBorderColor,
                            lineWidth: 1
                        )
                    }


                    // MARK: - Validation Message

                    if !viewModel.aadhaarValidationMessage.isEmpty {

                        HStack(
                            spacing: 6
                        ) {

                            Image(
                                systemName:
                                    viewModel.isAadhaarValid
                                    ? "checkmark.circle.fill"
                                    : "xmark.circle.fill"
                            )

                            Text(
                                viewModel.aadhaarValidationMessage
                            )

                            Spacer()
                        }
                        .font(
                            .system(
                                size: 13,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            viewModel.isAadhaarValid
                            ? Color.green
                            : Color.red
                        )
                    }
                }


                // MARK: - Consent

                HStack(
                    alignment: .top,
                    spacing: 12
                ) {

                    // MARK: Checkbox

                    Button {

                        viewModel.isConsentAccepted.toggle()

                    } label: {

                        Image(
                            systemName:
                                viewModel.isConsentAccepted
                                ? "checkmark.square.fill"
                                : "square"
                        )
                        .font(
                            .system(
                                size: 24
                            )
                        )
                        .foregroundStyle(
                            viewModel.isConsentAccepted
                            ? Color.appGreen
                            : Color.appTextSecondary
                        )
                    }
                    .buttonStyle(
                        .plain
                    )


                    // MARK: Consent Text

                    VStack(
                        alignment: .leading,
                        spacing: 6
                    ) {

                        Text(
                            isConsentExpanded
                            ? fullConsentText
                            : shortConsentText
                        )
                        .font(
                            .system(
                                size: 13
                            )
                        )
                        .foregroundStyle(
                            Color.appTextSecondary
                        )
                        .multilineTextAlignment(
                            .leading
                        )
                        .lineSpacing(
                            3
                        )


                        Button {

                            withAnimation(
                                .easeInOut(
                                    duration: 0.25
                                )
                            ) {

                                isConsentExpanded.toggle()
                            }

                        } label: {

                            Text(
                                isConsentExpanded
                                ? "Read Less"
                                : "Read More"
                            )
                            .font(
                                .system(
                                    size: 13,
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
                    }
                }


                // MARK: - Verify Button

                AppButton(
                    title: "VERIFY AADHAAR",
                    icon: "checkmark.shield.fill",
                    action: {

                        hideKeyboard()

                        viewModel.verifyAadhaar()
                    },
                    isLoading: viewModel.isLoading,
                    isDisabled:
                        !viewModel.isAadhaarValid ||
                        !viewModel.isConsentAccepted
                )


                // MARK: - Error

                if !viewModel.errorMessage.isEmpty {

                    Text(
                        viewModel.errorMessage
                    )
                    .font(
                        .system(
                            size: 13
                        )
                    )
                    .foregroundStyle(
                        Color.red
                    )
                }
            }
            .padding(
                20
            )
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(
                Color.appCard
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 20
                )
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
            }
            .padding(
                .horizontal,
                20
            )

            Spacer(
                minLength: 10
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .contentShape(
            Rectangle()
        )
        .onTapGesture {

            hideKeyboard()
        }
        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button(
                    "DONE"
                ) {

                    hideKeyboard()
                }
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
            }
        }
    }


    // MARK: - Aadhaar Binding

    private var aadhaarBinding: Binding<String> {

        Binding(

            get: {

                viewModel.aadhaarNumber
            },

            set: { newValue in

                let numbers =
                    newValue.filter {

                        $0.isNumber
                    }

                viewModel.aadhaarNumber =
                    String(
                        numbers.prefix(12)
                    )

                viewModel.validateAadhaar()
            }
        )
    }


    // MARK: - Aadhaar Border Color

    private var aadhaarBorderColor: Color {

        if viewModel.aadhaarNumber.isEmpty {

            return Color.appBorder
        }

        if viewModel.aadhaarNumber.count < 12 {

            return Color.appBorder
        }

        return viewModel.isAadhaarValid
            ? Color.green
            : Color.red
    }


    // MARK: - Hide Keyboard

    private func hideKeyboard() {

        isAadhaarFieldFocused = false

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
