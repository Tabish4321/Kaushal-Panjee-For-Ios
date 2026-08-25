import SwiftUI

struct AppOTPField: View {

    @Binding var otp: String

    @FocusState private var isFocused: Bool

    let length: Int

    init(
        otp: Binding<String>,
        length: Int = 4
    ) {
        self._otp = otp
        self.length = length
    }

    var body: some View {

        ZStack {

            TextField(
                "",
                text: $otp
            )
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($isFocused)
            .opacity(0.01)
            .onChange(
                of: otp
            ) { _, newValue in

                let filtered =
                    newValue.filter {
                        $0.isNumber
                    }

                otp =
                    String(
                        filtered.prefix(length)
                    )
            }

            HStack(
                spacing: 12
            ) {

                ForEach(
                    0..<length,
                    id: \.self
                ) { index in

                    otpBox(
                        index: index
                    )
                }
            }
        }
        .contentShape(
            Rectangle()
        )
        .onTapGesture {

            isFocused = true
        }
    }


    // ========================================================
    // MARK: - OTP Box
    // ========================================================

    @ViewBuilder
    private func otpBox(
        index: Int
    ) -> some View {

        let characters =
            Array(otp)

        let value =
            index < characters.count
            ? String(characters[index])
            : ""

        let isActive =
            isFocused &&
            index == characters.count

        ZStack {

            RoundedRectangle(
                cornerRadius: 14
            )
            .fill(
                Color.appInputBackground
            )

            RoundedRectangle(
                cornerRadius: 14
            )
            .stroke(
                isActive
                ? Color.appPrimary
                : Color.appBorder,
                lineWidth:
                    isActive
                    ? 2
                    : 1
            )

            Text(
                value
            )
            .font(
                .system(
                    size: 24,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
        }
        .frame(
            height: 58
        )
        .frame(
            maxWidth: .infinity
        )
    }
}
