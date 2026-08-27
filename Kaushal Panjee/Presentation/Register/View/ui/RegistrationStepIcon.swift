import SwiftUI

struct RegistrationStepIndicator: View {

    let currentStep: Int

    private let totalSteps = 6

    var body: some View {

        VStack(
            spacing: 8
        ) {

            HStack(
                spacing: 0
            ) {

                ForEach(
                    1...totalSteps,
                    id: \.self
                ) { step in

                    stepItem(
                        step: step
                    )

                    if step < totalSteps {

                        Rectangle()
                            .fill(
                                step < currentStep
                                ? Color.appPrimary
                                : Color.appBorder
                            )
                            .frame(
                                height: 1
                            )
                            .padding(
                                .horizontal,
                                4
                            )
                    }
                }
            }
            .padding(
                .horizontal,
                24
            )

            Text(
                String(
                    format: NSLocalizedString(
                        "registration.step.of",
                        comment: ""
                    ),
                    currentStep,
                    totalSteps
                )
            )
            .font(
                .system(
                    size: 13,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
        }
    }

    // MARK: - Step Item

    @ViewBuilder
    private func stepItem(
        step: Int
    ) -> some View {

        ZStack {

            Circle()
                .fill(
                    step == currentStep
                    ? Color.appPrimary
                    : Color.appSurface
                )
                .overlay {

                    Circle()
                        .stroke(
                            step == currentStep
                            ? Color.appPrimary
                            : Color.appBorder,
                            lineWidth: 1
                        )
                }
                .frame(
                    width: 34,
                    height: 34
                )

            Text("\(step)")
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    step == currentStep
                    ? Color.white
                    : Color.appTextSecondary
                )
        }
    }
}
