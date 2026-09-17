import SwiftUI

struct AadhaarStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    @FocusState private var isAadhaarFieldFocused: Bool

    @State private var isConsentExpanded = false

    @State private var isAadhaarVisible = false

    @EnvironmentObject
    private var languageManager: LanguageManager

    private var shortConsentText: String {
        languageManager.localized("registration.consent_short")
    }

    private var fullConsentText: String {
        languageManager.localized("registration.consent_full")
    }

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
                    verbatim: languageManager.localized(
                        "registration.aadhaar_verification"
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

                // MARK: - Description

                Text(
                    verbatim: languageManager.localized(
                        "registration.aadhaar_description"
                    )
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
                        verbatim: languageManager.localized(
                            "registration.aadhaar_number"
                        )
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

                        // MARK: - Aadhaar Icon

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

                        // MARK: - Aadhaar Field

                        if isAadhaarVisible {

                            TextField(
                                languageManager.localized(
                                    "registration.aadhaar_placeholder"
                                ),
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

                        } else {

                            SecureField(
                                languageManager.localized(
                                    "registration.aadhaar_placeholder"
                                ),
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

                        // MARK: - Eye Button

                        Button {

                            isAadhaarVisible.toggle()

                        } label: {

                            Image(systemName: isAadhaarVisible ? "eye" : "eye.slash")
                            .font(
                                .system(
                                    size: 18,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                Color.appDarkGreen
                            )
                            .frame(
                                width: 50,
                                height: 56
                            )
                        }
                        .buttonStyle(
                            .plain
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

                    // MARK: - Checkbox

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

                    // MARK: - Consent Text

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
                                verbatim: isConsentExpanded
                                    ? languageManager.localized("registration.read_less")
                                    : languageManager.localized("registration.read_more")
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
                    title: languageManager.localized(
                        "registration.verify_aadhaar"
                    ),
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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isAadhaarFieldFocused = false
            hideKeyboard()
        }
        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button(
                    languageManager.localized(
                        "common.done"
                    )
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
