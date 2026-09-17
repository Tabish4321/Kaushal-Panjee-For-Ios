import SwiftUI

struct AppPasswordField: View {

    // MARK: - Properties

    let title: String

    let placeholder: String

    let icon: String

    @Binding var text: String

    @State private var isPasswordVisible = false


    // MARK: - Body

    var body: some View {

        HStack(spacing: 10) {

            // =====================================================
            // MARK: Icon
            // =====================================================

            ZStack {

                RoundedRectangle(
                    cornerRadius: 9
                )
                .fill(
                    Color.appVeryLightGreen
                )

                Image(
                    systemName: icon
                )
                .font(
                    .system(
                        size: 19,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
            }
            .frame(
                width: 44,
                height: 44
            )


            // =====================================================
            // MARK: Text Area
            // =====================================================

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
                    .lineLimit(1)


                // =================================================
                // Password / Normal Text
                // =================================================

                if isPasswordVisible {

                    TextField(
                        placeholder,
                        text: $text
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .font(
                        .system(
                            size: 13,
                            weight: .regular
                        )
                    )

                } else {

                    SecureField(
                        placeholder,
                        text: $text
                    )
                    .font(
                        .system(
                            size: 13,
                            weight: .regular
                        )
                    )
                }
            }


            Spacer(
                minLength: 0
            )


            // =====================================================
            // MARK: Show / Hide Password
            // =====================================================

            Button {

                isPasswordVisible.toggle()

            } label: {

                Image(
                    systemName:
                        isPasswordVisible
                        ? "eye"
                        : "eye.slash"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
                .frame(
                    width: 32,
                    height: 32
                )
                .contentShape(
                    Rectangle()
                )
            }
            .buttonStyle(.plain)
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
    }
}
