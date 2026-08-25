import SwiftUI

struct RegistrationEmailContent: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        RegistrationCard {

            VStack(
                spacing: 0
            ) {

                // =============================================
                // MARK: Step Indicator
                // =============================================

                RegistrationStepIndicator(
                    currentStep: 1
                )
                .padding(
                    .top,
                    24
                )


                // =============================================
                // MARK: Hero
                // =============================================

                RegistrationHeroView(
                    icon: "envelope.fill",
                    title: "registration.email.title",
                    subtitle: "registration.email.subtitle"
                )
                .padding(
                    .top,
                    28
                )


                // =============================================
                // MARK: Email Field
                // =============================================

                AppTextField(
                    title: "registration.email.label",
                    placeholder: "registration.email.placeholder",
                    icon: "envelope",
                    text: $viewModel.email
                )
                .padding(
                    .top,
                    30
                )


                // =============================================
                // MARK: Error
                // =============================================

                if !viewModel.errorMessage.isEmpty {

                    AppErrorView(
                        message: viewModel.errorMessage
                    )
                    .padding(
                        .top,
                        12
                    )
                }


                // =============================================
                // MARK: Success
                // =============================================

                if !viewModel.successMessage.isEmpty {

                    AppSuccessView(
                        message: viewModel.successMessage
                    )
                    .padding(
                        .top,
                        12
                    )
                    .padding(
                        .top,
                        12
                    )
                }


                // =============================================
                // MARK: Continue
                // =============================================

                AppButton(
                    title: "registration.continue",
                    icon: "arrow.right",
                    action: {

                        viewModel.submitEmail()
                    },
                    isLoading: viewModel.isLoading
                )
                .padding(
                    .top,
                    24
                )


                // =============================================
                // MARK: Skip
                // =============================================

                Button {

                    viewModel.skipEmail()

                } label: {

                    HStack(
                        spacing: 6
                    ) {

                        Text(
                            NSLocalizedString(
                                "registration.email.skip",
                                comment: ""
                            )
                        )
                        .font(
                            .system(
                                size: 14,
                                weight: .medium
                            )
                        )

                        Image(
                            systemName:
                                "arrow.right"
                        )
                        .font(
                            .system(
                                size: 12,
                                weight: .semibold
                            )
                        )
                    }
                    .foregroundStyle(
                        Color.appDarkGreen
                    )
                }
                .buttonStyle(
                    .plain
                )
                .padding(
                    .top,
                    20
                )


                // =============================================
                // MARK: Info
                // =============================================

                HStack(
                    spacing: 6
                ) {

                    Image(
                        systemName:
                            "info.circle"
                    )
                    .font(
                        .system(
                            size: 12
                        )
                    )

                    Text(
                        NSLocalizedString(
                            "registration.email.skip.description",
                            comment: ""
                        )
                    )
                    .font(
                        .system(
                            size: 11,
                            weight: .regular
                        )
                    )
                }
                .foregroundStyle(
                    Color.appTextSecondary
                )
                .padding(
                    .top,
                    10
                )
                .padding(
                    .bottom,
                    24
                )
            }
            .padding(
                .horizontal,
                20
            )
        }
    }
}
