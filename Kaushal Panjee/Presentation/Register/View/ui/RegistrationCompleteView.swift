import SwiftUI

struct RegistrationCompleteView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        VStack(spacing: 24) {

            Spacer(minLength: 20)

            Image(
                systemName: "checkmark.circle.fill"
            )
            .font(
                .system(
                    size: 80,
                    weight: .regular
                )
            )
            .foregroundStyle(
                Color.appGreen
            )

            VStack(spacing: 10) {

                Text("Registration Complete")
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )

                Text(
                    "Your registration has been completed successfully."
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
                    .horizontal,
                    20
                )
            }

            if let selectedState = viewModel.selectedState {

                VStack(
                    alignment: .leading,
                    spacing: 8
                ) {

                    Text("Selected State")
                        .font(
                            .system(
                                size: 13,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color.appTextSecondary
                        )

                    HStack {

                        Image(
                            systemName: "location.fill"
                        )
                        .foregroundStyle(
                            Color.appGreen
                        )

                        Text(
                            selectedState.stateName
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            Color.appDarkGreen
                        )

                        Spacer()
                    }
                }
                .padding(18)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .background(
                    Color.appCard
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
                .overlay {

                    RoundedRectangle(
                        cornerRadius: 16
                    )
                    .stroke(
                        Color.appBorder,
                        lineWidth: 1
                    )
                }
            }

            Spacer()

            AppButton(
                title: "Continue",
                icon: "arrow.right",
                action: {

                    // Next navigation yahan handle hogi

                }
            )
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 550
        )
        .padding(
            .vertical,
            20
        )
    }
}
