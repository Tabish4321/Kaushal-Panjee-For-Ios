import SwiftUI

struct RegistrationStepIndicator: View {

    let currentStep: Int

    private let totalSteps = 6

    var body: some View {

        HStack(
            spacing: 0
        ) {

            ForEach(
                1...totalSteps,
                id: \.self
            ) { step in

                stepCircle(
                    step
                )

                if step < totalSteps {

                    Rectangle()
                        .fill(
                            Color.appBorder
                        )
                        .frame(
                            height: 1
                        )
                        .frame(
                            maxWidth: .infinity
                        )
                        .padding(
                            .horizontal,
                            6
                        )
                }
            }
        }
        .padding(
            .horizontal,
            42
        )
    }

    // MARK: - Step Circle

    @ViewBuilder
    private func stepCircle(
        _ step: Int
    ) -> some View {

        ZStack {

            Circle()
                .fill(
                    step == currentStep
                        ? Color.appDarkGreen
                        : Color.appCard
                )
                .frame(
                    width: 38,
                    height: 38
                )
                .overlay {

                    Circle()
                        .stroke(
                            step == currentStep
                                ? Color.appDarkGreen
                                : Color.appBorder,
                            lineWidth: 1
                        )
                }

            Text(
                "\(step)"
            )
            .font(
                .system(
                    size: 16,
                    weight: step == currentStep
                        ? .bold
                        : .regular
                )
            )
            .foregroundStyle(
                step == currentStep
                    ? Color.white
                    : Color.appTextSecondary
            )
        }
        .frame(
            width: 38,
            height: 38
        )
    }
}
