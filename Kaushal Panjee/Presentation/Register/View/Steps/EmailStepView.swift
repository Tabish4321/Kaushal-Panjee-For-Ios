import SwiftUI

struct EmailStepView: View {

    @EnvironmentObject
    private var languageManager: LanguageManager

    @ObservedObject
    var viewModel: RegistrationViewModel

    var body: some View {

        VStack(
            spacing: 0
        ) {

            // MARK: - Email Icon

            Image(
                systemName: "envelope.fill"
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
                    "registration.email_continue"
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
            .multilineTextAlignment(
                .center
            )
            .padding(
                .top,
                8
            )


            // MARK: - Email Input

            AppTextField(
                title: languageManager.localized(
                    "registration.email_address"
                ),
                placeholder: languageManager.localized(
                    "registration.email_placeholder"
                ),
                icon: "envelope",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                submitLabel: .done,
                submitButtonTitle: languageManager.localized(
                    "common.done"
                ),
                onSubmit: {

                    hideKeyboard()

                    if !viewModel.email
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty {

                        viewModel.submitEmail()
                    }
                }
            )
            .padding(
                .top,
                36
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
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(
                    .top,
                    10
                )
            }


            // MARK: - Send OTP Button

            AppButton(
                title: languageManager.localized(
                    "common.send_otp"
                ),
                icon: "arrow.right",
                action: {

                    hideKeyboard()

                    viewModel.submitEmail()
                },
                isLoading: viewModel.isLoading,
                isDisabled:
                    viewModel.email
                        .trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                        .isEmpty
            )
            .padding(
                .top,
                24
            )


            // MARK: - Skip

            Button {

                hideKeyboard()

                viewModel.skipEmail()

            } label: {

                HStack(
                    spacing: 6
                ) {

                    Text(
                        verbatim: languageManager.localized(
                            "registration.skip_for_now"
                        )
                    )

                    Image(
                        systemName: "arrow.right"
                    )
                }
                .font(
                    .system(
                        size: 15,
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
            .padding(
                .top,
                24
            )


            Text(
                verbatim: languageManager.localized(
                    "registration.email_verify_later"
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
                8
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
