import SwiftUI

struct AppTextField: View {

    let title: String

    let placeholder: String

    let icon: String

    @Binding var text: String

    var keyboardType: UIKeyboardType = .default

    var submitLabel: SubmitLabel = .done

    var submitButtonTitle: String = "Done"

    var onSubmit: (() -> Void)? = nil


    var body: some View {

        HStack(spacing: 10) {

            AppIcon(
                icon,
                size: 19,
                color: .appDarkGreen
            )
            .frame(
                width: 44,
                height: 44
            )
            .background(
                Color.appVeryLightGreen
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 9
                )
            )


            VStack(
                alignment: .leading,
                spacing: 1
            ) {

                Text(verbatim: title)
                    .font(
                        .system(
                            size: 10,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appTextSecondary
                    )


                TextField(
                    placeholder,
                    text: $text
                )
                .keyboardType(
                    keyboardType
                )
                .submitLabel(
                    submitLabel
                )
                .onSubmit {

                    onSubmit?()
                }
                .textInputAutocapitalization(
                    .never
                )
                .autocorrectionDisabled()
                .font(
                    .system(
                        size: 13,
                        weight: .regular
                    )
                )
            }


            Spacer(
                minLength: 0
            )
        }
        .padding(
            .horizontal,
            11
        )
        .frame(
            height: 60
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


        // MARK: - Keyboard Toolbar

        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button(
                    submitButtonTitle
                ) {

                    hideKeyboard()

                    onSubmit?()
                }
                .fontWeight(
                    .semibold
                )
            }
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
