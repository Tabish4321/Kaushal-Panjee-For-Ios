import SwiftUI

struct RegistrationCompleteView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        VStack(
            spacing: 0
        ) {

            Spacer()
                .frame(
                    height: 20
                )

            VStack(
                alignment: .center,
                spacing: 20
            ) {

                // MARK: - Success Icon

                Image(
                    systemName: "checkmark.circle.fill"
                )
                .font(
                    .system(
                        size: 70
                    )
                )
                .foregroundStyle(
                    Color.appGreen
                )
                .padding(
                    .top,
                    10
                )

                // MARK: - Title

                Text(
                    NSLocalizedString(
                        "registration.complete_title",
                        comment: ""
                    )
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

                // MARK: - Description

                Text(
                    NSLocalizedString(
                        "registration.complete_description",
                        comment: ""
                    )
                )
                .font(
                    .system(
                        size: 14
                    )
                )
                .foregroundStyle(
                    Color.appTextSecondary
                )
                .multilineTextAlignment(
                    .center
                )

                Spacer()
                    .frame(
                        height: 8
                    )

                // MARK: - Selected State

                if let selectedState = viewModel.selectedState {

                    VStack(
                        alignment: .leading,
                        spacing: 10
                    ) {

                        Text(
                            NSLocalizedString(
                                "registration.selected_state",
                                comment: ""
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

                        HStack(
                            spacing: 12
                        ) {

                            Image(
                                systemName: "location.fill"
                            )
                            .font(
                                .system(
                                    size: 18
                                )
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

                            Image(
                                systemName: "checkmark.circle.fill"
                            )
                            .foregroundStyle(
                                Color.appGreen
                            )
                        }
                    }
                    .padding(
                        16
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
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

                Spacer()
                    .frame(
                        height: 12
                    )

                // MARK: - Continue Button

                AppButton(
                    title: "common.continue",
                    icon: "arrow.right",
                    action: {
                        // Registration complete ke baad
                        // next navigation yahan handle hogi
                    }
                )
                .padding(
                    .bottom,
                    10
                )
            }
            .padding(
                20
            )
            .frame(
                maxWidth: .infinity
            )
            .background(
                Color.appCard
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 20
                )
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
            }

            Spacer(
                minLength: 30
            )
        }
        .padding(
            .horizontal,
            20
        )
        .frame(
            maxWidth: .infinity,
            minHeight: 500,
            alignment: .top
        )
    }
}
