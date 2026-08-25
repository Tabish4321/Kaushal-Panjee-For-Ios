import SwiftUI

struct AadhaarView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        ScrollView(
            showsIndicators: false
        ) {

            VStack(
                alignment: .leading,
                spacing: 20
            ) {

                Text("Aadhaar Verification")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                TextField(
                    "Aadhaar Number",
                    text: $viewModel.aadhaarNumber
                )
                .keyboardType(.numberPad)
                .padding()
                .overlay {

                    RoundedRectangle(
                        cornerRadius: 12
                    )
                    .stroke(
                        Color.gray.opacity(0.3)
                    )
                }

                // Baaki Aadhaar consent content yahin
            }
            .frame(
                maxWidth: .infinity,
                alignment: .topLeading
            )
            .padding(.vertical, 5)
        }
    }
}
