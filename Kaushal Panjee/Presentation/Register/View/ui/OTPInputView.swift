import SwiftUI

struct OTPInputView: View {

    @Binding var otp: String
    var isFocused: FocusState<Bool>.Binding

    private let otpLength = 4

    var body: some View {

        ZStack {

            // MARK: - OTP Boxes

            HStack(
                spacing: 12
            ) {

                ForEach(
                    0..<otpLength,
                    id: \.self
                ) { index in

                    OTPBox(
                        character: character(
                            at: index
                        ),
                        isActive:
                            isFocused.wrappedValue &&
                            index == min(
                                otp.count,
                                otpLength - 1
                            )
                    )
                }
            }

            // MARK: - Hidden TextField

            TextField(
                "",
                text: $otp
            )
            .keyboardType(
                .numberPad
            )
            .textContentType(
                .oneTimeCode
            )
            .focused(
                isFocused
            )
            .opacity(
                0.01
            )
            .onChange(
                of: otp
            ) { _, newValue in

                let numbers = newValue.filter {
                    $0.isNumber
                }

                let limitedOTP = String(
                    numbers.prefix(
                        otpLength
                    )
                )

                if limitedOTP != otp {

                    otp = limitedOTP
                }
            }
        }
        .frame(
            maxWidth: .infinity
        )
        .contentShape(
            Rectangle()
        )
        .onTapGesture {

            isFocused.wrappedValue = true
        }
    }

    // MARK: - Get OTP Character

    private func character(
        at index: Int
    ) -> String {

        guard index < otp.count else {

            return ""
        }

        let stringIndex = otp.index(
            otp.startIndex,
            offsetBy: index
        )

        return String(
            otp[stringIndex]
        )
    }
}


// MARK: - OTP Box

private struct OTPBox: View {

    let character: String
    let isActive: Bool

    var body: some View {

        Text(
            character
        )
        .font(
            .system(
                size: 26,
                weight: .medium
            )
        )
        .foregroundStyle(
            Color.appDarkGreen
        )
        .frame(
            maxWidth: .infinity
        )
        .frame(
            height: 62
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
                isActive
                    ? Color.appDarkGreen
                    : Color.appBorder,
                lineWidth:
                    isActive
                        ? 1.5
                        : 1
            )
        }
    }
}
