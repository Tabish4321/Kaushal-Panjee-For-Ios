import SwiftUI

struct RegistrationView: View {

    @StateObject private var viewModel =
        RegistrationViewModel(
            repository: RegistrationRepository()
        )

    var body: some View {

        VStack(spacing: 0) {

            RegistrationStepIndicator(
                currentStep: currentStepNumber
            )
            .padding(.top, 12)

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
        }
        .animation(
            .easeInOut,
            value: viewModel.step
        )
    }

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
