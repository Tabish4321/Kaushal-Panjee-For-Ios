import SwiftUI

struct RegistrationView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject private var viewModel =
        RegistrationViewModel(
            repository: RegistrationRepository()
        )

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: - Background

                Color.appBackground
                    .ignoresSafeArea()


                // MARK: - Rural Footer Image

                VStack {

                    Spacer()

                    Image("rural_footer")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.16
                        )
                        .clipped()
                        .opacity(0.75)
                }
                .ignoresSafeArea()


                // MARK: - Main Content

                VStack(
                    spacing: 0
                ) {

                    // MARK: - Header

                    AppHeaderView(
                        title: "Registration",
                        showBackButton: true,
                        onBack: {
                            handleBack()
                        }
                    )


                    // MARK: - Step Indicator

                    RegistrationStepIndicator(
                        currentStep: currentStepNumber
                    )
                    .padding(
                        .top,
                        geometry.safeAreaInsets.top + 12
                    )


                    // MARK: - Step Content

                    Group {

                        switch viewModel.step {

                        case .email:

                            EmailStepView(
                                viewModel: viewModel
                            )

                        case .emailOTP:

                            EmailOTPStepView(
                                viewModel: viewModel
                            )

                        case .mobile:

                            MobileStepView(
                                viewModel: viewModel
                            )

                        case .mobileOTP:

                            MobileOTPStepView(
                                viewModel: viewModel
                            )

                        case .selectState:

                            StateSelectionView(
                                viewModel: viewModel
                            )

                        case .aadhaar:

                            AadhaarStepView(
                                viewModel: viewModel
                            )

                        case .registrationComplete:

                            RegistrationCompleteView(
                                viewModel: viewModel
                            )
                        }
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )


                    // MARK: - Common Footer

                    AppFooterView()
                        .padding(
                            .horizontal,
                            20
                        )
                        .padding(
                            .bottom,
                            max(
                                geometry.safeAreaInsets.bottom,
                                5
                            )
                        )
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }

            // IMPORTANT:
            // Keyboard open hone par pura ZStack resize nahi hoga

            .ignoresSafeArea(
                .keyboard,
                edges: .bottom
            )
        }
        .background(
            Color.appBackground
        )
        .animation(
            .easeInOut(
                duration: 0.25
            ),
            value: viewModel.step
        )
        .navigationBarBackButtonHidden(
            true
        )
    }


    // MARK: - Back Navigation

    private func handleBack() {

        switch viewModel.step {

        // First Step → Login

        case .email:

            dismiss()


        // Other Steps → Previous Step

        default:

            withAnimation(
                .easeInOut(
                    duration: 0.25
                )
            ) {

                viewModel.goBack()
            }
        }
    }


    // MARK: - Current Step Number

    private var currentStepNumber: Int {

        switch viewModel.step {

        case .email:

            return 1

        case .emailOTP:

            return 2

        case .mobile:

            return 3

        case .mobileOTP:

            return 4

        case .selectState:

            return 5

        case .aadhaar:

            return 6

        case .registrationComplete:

            return 6
        }
    }
}
