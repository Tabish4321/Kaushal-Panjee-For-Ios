import SwiftUI

struct RegistrationView: View {

    @EnvironmentObject private var languageManager: LanguageManager
    
    
    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - Registration Success Callback

    let onRegistrationSuccess: (_ userId: String, _ appCode: String) -> Void
    
    // MARK: - ViewModel

    @StateObject private var viewModel =
        RegistrationViewModel(
            repository: RegistrationRepository()
        )

    // MARK: - Init

    init(
        onRegistrationSuccess: @escaping (_ userId: String, _ appCode: String) -> Void = { _, _ in }
    ) {
        self.onRegistrationSuccess = onRegistrationSuccess
    }

    // MARK: - Body

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

                VStack(spacing: 0) {

                    // MARK: - Header

                    AppHeaderView(
                        title: languageManager.localized("registration.title"),
                        showBackButton: true,
                        onBack: {
                            handleBack()
                        }
                    )

                    // MARK: - Step Indicator

                    RegistrationStepIndicator(
                        currentStep: currentStepNumber
                    )
                    .padding(.top, -5)

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
                    .padding(.top, 18)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )

                    // MARK: - Common Footer

                    AppFooterView()
                        .padding(.horizontal, 20)
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
            .ignoresSafeArea(
                .keyboard,
                edges: .bottom
            )
        }
        .background(
            Color.appBackground
        )
        .ignoresSafeArea(
            .keyboard,
            edges: .bottom
        )

        // MARK: - Step Animation

        .animation(
            .easeInOut(duration: 0.25),
            value: viewModel.step
        )

        .navigationBarBackButtonHidden(true)

        // MARK: - eKYC Success Popup

        .overlay {

            if viewModel.showEkycSuccessDialog {

                EkycSuccessDialog(
                    photoBase64: viewModel.aadhaarPhoto,
                    name: viewModel.aadhaarName,
                    fatherName: viewModel.aadhaarFatherName,
                    dob: viewModel.aadhaarDOB
                ) {

                    // Close popup

                    withAnimation(
                        .easeInOut(duration: 0.2)
                    ) {
                        viewModel.showEkycSuccessDialog = false
                    }

                    // Registration successful

                    // Registration successful
                    onRegistrationSuccess(
                        viewModel.createdUserId,
                        viewModel.createdAppCode
                    )
                }
                .transition(
                    .opacity
                        .combined(
                            with: .scale(
                                scale: 0.95
                            )
                        )
                )
                .zIndex(999)
            }
        }

        // MARK: - Popup Animation

        .animation(
            .easeInOut(duration: 0.2),
            value: viewModel.showEkycSuccessDialog
        )
    }

    // MARK: - Back Navigation

    private func handleBack() {

        switch viewModel.step {

        case .email:

            dismiss()

        default:

            withAnimation(
                .easeInOut(duration: 0.25)
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
