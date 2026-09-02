import SwiftUI

struct EmailStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

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
                "Verify your email"
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
                "Enter your email address to continue"
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
                title: "Email Address",
                placeholder: "Enter your email address",
                icon: "envelope",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                submitLabel: .done,
                submitButtonTitle: "Done",
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
                title: "SEND OTP",
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
                        "Skip for now"
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
                "You can verify your email later."
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
