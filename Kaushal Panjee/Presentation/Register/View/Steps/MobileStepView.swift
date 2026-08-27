import SwiftUI

struct MobileStepView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    @FocusState private var isMobileFieldFocused: Bool

    var body: some View {

        VStack(spacing: 0) {

            Spacer()
                .frame(height: 10)

            // MARK: - Phone Icon

            Image(
                systemName: "phone.fill"
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
                "Enter your mobile number to continue"
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


            // MARK: - Mobile Input

            HStack(
                spacing: 0
            ) {

                Text(
                    "+91"
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
                    .horizontal,
                    16
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
                    "Enter 10 digit mobile number",
                    text: $viewModel.mobileNumber
                )
                .keyboardType(
                    .numberPad
                )
                .textContentType(
                    .telephoneNumber
                )
                .focused(
                    $isMobileFieldFocused
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
                .onChange(
                    of: viewModel.mobileNumber
                ) { _, newValue in

                    let numbers = newValue.filter {
                        $0.isNumber
                    }

                    let limitedNumber = String(
                        numbers.prefix(10)
                    )

                    if limitedNumber != viewModel.mobileNumber {

                        viewModel.mobileNumber =
                            limitedNumber
                    }
                }
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
                    Color.appBorder,
                    lineWidth: 1
                )
            }
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
                    submitMobile()
                },
                isLoading: viewModel.isLoading,
                isDisabled:
                    viewModel.mobileNumber.count != 10
            )
            .padding(
                .top,
                24
            )


            // MARK: - Security Text

            HStack(
                spacing: 6
            ) {

                Image(
                    systemName: "lock.fill"
                )

                Text(
                    "Your mobile number is secure with us"
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
                18
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

        // MARK: - Tap Outside

        .contentShape(
            Rectangle()
        )
        .onTapGesture {
            hideKeyboard()
        }


        // MARK: - Keyboard Toolbar

        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button(
                    "SUBMIT"
                ) {
                    submitMobile()
                }
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
                .disabled(
                    viewModel.mobileNumber.count != 10 ||
                    viewModel.isLoading
                )
            }
        }
    }


    // MARK: - Submit Mobile

    private func submitMobile() {

        guard
            viewModel.mobileNumber.count == 10
        else {
            return
        }

        hideKeyboard()

        viewModel.submitMobile()
    }


    // MARK: - Hide Keyboard

    private func hideKeyboard() {

        isMobileFieldFocused = false

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
