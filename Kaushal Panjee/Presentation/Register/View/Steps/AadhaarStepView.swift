import SwiftUI

struct AadhaarStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(
                spacing: 0
            ) {

                Spacer()
                    .frame(
                        height: 20
                    )

                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {

                    // MARK: - Icon

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

                    Spacer()
                        .frame(
                            height: 8
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
                        .font(
                            .system(
                                size: 16,
                                weight: .medium
                            )
                        )
                        .padding(
                            .horizontal,
                            16
                        )
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

                        if !viewModel
                            .aadhaarValidationMessage
                            .isEmpty {

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
                                    viewModel
                                        .aadhaarValidationMessage
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

                    Spacer()
                        .frame(
                            height: 8
                        )

                    // MARK: - Consent

                    Button {

                        viewModel
                            .isConsentAccepted
                            .toggle()

                    } label: {

                        HStack(
                            alignment: .top,
                            spacing: 12
                        ) {

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

                            Text(
                                """
                                I hereby consent to authenticate myself using Aadhaar based authentication for availing services on the Unified IT Platform for DDUGKY and RSETI.
                                """
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
                        }
                    }
                    .buttonStyle(
                        .plain
                    )

                    Spacer()
                        .frame(
                            height: 8
                        )

                    // MARK: - Verify Button

                    AppButton(
                        title: "VERIFY AADHAAR",
                        icon: "checkmark.shield.fill",
                        action: {

                            hideKeyboard()

                            viewModel
                                .verifyAadhaar()
                        },
                        isLoading:
                            viewModel.isLoading,
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

                Spacer(
                    minLength: 30
                )
            }
            .padding(
                .horizontal,
                20
            )
        }
        .scrollDismissesKeyboard(
            .interactively
        )
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
