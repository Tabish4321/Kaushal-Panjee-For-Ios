import SwiftUI

struct RegistrationView: View {

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel: RegistrationViewModel

    init() {
        let repository = RegistrationRepository()

        _viewModel = StateObject(
            wrappedValue: RegistrationViewModel(
                repository: repository
            )
        )
    }

    // MARK: - Current Step

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
    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                Color.appBackground
                    .ignoresSafeArea()

                // MARK: - Rural Footer

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

                    // MARK: Header

                    HStack {

                        Button {

                            if viewModel.step == .email {
                                dismiss()
                            } else {
                                viewModel.goBack()
                            }

                        } label: {

                            Image(
                                systemName: "chevron.left"
                            )
                            .font(
                                .system(
                                    size: 18,
                                    weight: .semibold
                                )
                            )
                            .foregroundStyle(
                                Color.appDarkGreen
                            )
                            .frame(
                                width: 44,
                                height: 44
                            )
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Text(
                            NSLocalizedString(
                                "registration.title",
                                comment: ""
                            )
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            Color.appTextPrimary
                        )

                        Spacer()

                        Color.clear
                            .frame(
                                width: 44,
                                height: 44
                            )
                    }
                    .padding(
                        .horizontal,
                        12
                    )
                    .padding(
                        .top,
                        max(
                            geometry.safeAreaInsets.top - 50,
                            0
                        )
                    )

                    // MARK: Registration Card

                    RegistrationCard {

                        VStack(spacing: 0) {

                            RegistrationStepIndicator(
                                currentStep: currentStepNumber
                            )
                            .padding(
                                .top,
                                22
                            )

                            VStack {

                                switch viewModel.step {

                                case .email:

                                    emailContent

                                case .emailOTP:

                                    emailOTPContent

                                case .mobile:

                                    mobileContent

                                case .mobileOTP:

                                    mobileOTPContent

                                case .selectState:

                                    StateSelectionView(
                                        viewModel: viewModel
                                    )

                                case .aadhaar:

                                    AadhaarView(
                                        viewModel: viewModel
                                    )

                                case .registrationComplete:

                                    registrationCompleteContent
                                }
                            }
                            .frame(
                                maxWidth: .infinity,
                                
                                alignment: .top
                            )                        }
                    }
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .top,
                        12
                    )
                    .padding(
                        .bottom,
                        110
                    )

                    Spacer(
                        minLength: 0
                    )

                    // MARK: Security Banner

                    AppSecurityBanner(
                        title: "login.secure.title",
                        subtitle: "login.secure.subtitle",
                        icon: "checkmark.shield.fill"
                    )
                    .padding(
                        .bottom,
                        4
                    )

                    // MARK: App Version

                    Text(
                        String(
                            format: NSLocalizedString(
                                "common.version",
                                comment: ""
                            ),
                            AppUtil.appVersion()
                        )
                    )
                    .font(
                        .system(
                            size: 10,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
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
            .contentShape(
                Rectangle()
            )
            .onTapGesture {
                hideKeyboard()
            }
        }
        .ignoresSafeArea(
            .keyboard,
            edges: .bottom
        )
        .navigationBarBackButtonHidden()
    }

    // =========================================================
    // MARK: - Email Screen
    // =========================================================

    private var emailContent: some View {

        VStack(spacing: 0) {

            registrationIcon(
                icon: "envelope.fill"
            )
            .padding(
                .top,
                28
            )

            Text(
                NSLocalizedString(
                    "registration.email.title",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                NSLocalizedString(
                    "registration.email.subtitle",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
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
            .padding(
                .top,
                6
            )

            // MARK: Email Field

            AppTextField(
                title: "registration.email.label",
                placeholder: "registration.email.placeholder",
                icon: "envelope",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                submitLabel: .done,
                submitButtonTitle: "Submit",
                onSubmit: {
                    hideKeyboard()
                    viewModel.submitEmail()
                }
            )
            .padding(
                .top,
                28
            )

            messageView

            AppButton(
                title: "registration.continue",
                icon: "arrow.right",
                action: {
                    hideKeyboard()
                    viewModel.submitEmail()
                },
                isLoading: viewModel.isLoading
            )
            .padding(
                .top,
                24
            )

            Button {
                hideKeyboard()
                viewModel.skipEmail()

            } label: {

                HStack(spacing: 6) {

                    Text(
                        NSLocalizedString(
                            "registration.email.skip",
                            comment: ""
                        )
                    )

                    Image(
                        systemName: "arrow.right"
                    )
                }
                .font(
                    .system(
                        size: 14,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
            }
            .buttonStyle(.plain)
            .padding(
                .top,
                18
            )

            HStack(
                alignment: .top,
                spacing: 6
            ) {

                Image(
                    systemName: "info.circle"
                )

                Text(
                    NSLocalizedString(
                        "registration.email.skip.description",
                        comment: ""
                    )
                )
            }
            .font(
                .system(
                    size: 11,
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
                .top,
                12
            )
            .padding(
                .bottom,
                26
            )
        }
        .padding(
            .horizontal,
            20
        )
    }

    // =========================================================
    // MARK: - Email OTP Screen
    // =========================================================

    private var emailOTPContent: some View {

        VStack(spacing: 0) {

            registrationIcon(
                icon: "envelope.badge.fill"
            )
            .padding(
                .top,
                28
            )

            Text(
                NSLocalizedString(
                    "registration.email.otp.title",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                NSLocalizedString(
                    "registration.email.otp.subtitle",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
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
                .top,
                6
            )

            Text(
                viewModel.email
            )
            .font(
                .system(
                    size: 15,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appPrimary
            )
            .padding(
                .top,
                5
            )
            .lineLimit(1)
            .minimumScaleFactor(0.7)

            Text(
                NSLocalizedString(
                    "registration.otp.enter",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                30
            )

            AppOTPField(
                otp: $viewModel.otp,
                length: 4
            )
            .padding(
                .top,
                12
            )

            messageView

            AppButton(
                title: "registration.otp.verify",
                icon: "checkmark.shield.fill",
                action: {
                    hideKeyboard()
                    viewModel.verifyEmailOTP()
                },
                isLoading: viewModel.isLoading
            )
            .padding(
                .top,
                24
            )

            resendEmailView
                .padding(
                    .top,
                    20
                )
                .padding(
                    .bottom,
                    26
                )
        }
        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button("Verify") {
                    hideKeyboard()
                    viewModel.verifyEmailOTP()
                }
            }
        }
        .padding(
            .horizontal,
            20
        )
    }

    // =========================================================
    // MARK: - Mobile Screen
    // =========================================================

    private var mobileContent: some View {

        VStack(spacing: 0) {

            registrationIcon(
                icon: "phone.fill"
            )
            .padding(
                .top,
                28
            )

            Text(
                NSLocalizedString(
                    "registration.mobile.title",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                NSLocalizedString(
                    "registration.mobile.subtitle",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
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
            .padding(
                .top,
                6
            )

            mobileNumberField
                .padding(
                    .top,
                    28
                )

            messageView

            AppButton(
                title: "registration.mobile.send_otp",
                icon: "arrow.right",
                action: {
                    hideKeyboard()
                    viewModel.submitMobile()
                },
                isLoading: viewModel.isLoading
            )
            .padding(
                .top,
                24
            )
            .padding(
                .bottom,
                26
            )
        }
        .padding(
            .horizontal,
            20
        )
    }

    // =========================================================
    // MARK: - Mobile OTP Screen
    // =========================================================

    private var mobileOTPContent: some View {

        VStack(spacing: 0) {

            registrationIcon(
                icon: "lock.shield.fill"
            )
            .padding(
                .top,
                28
            )

            Text(
                NSLocalizedString(
                    "registration.mobile.otp.title",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                NSLocalizedString(
                    "registration.mobile.otp.subtitle",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
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
                .top,
                6
            )

            Text(
                "+91 \(viewModel.mobileNumber)"
            )
            .font(
                .system(
                    size: 15,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appPrimary
            )
            .padding(
                .top,
                5
            )

            Text(
                NSLocalizedString(
                    "registration.otp.enter",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                30
            )

            AppOTPField(
                otp: $viewModel.otp,
                length: 4
            )
            .padding(
                .top,
                12
            )

            messageView

            AppButton(
                title: "registration.otp.verify",
                icon: "checkmark.shield.fill",
                action: {
                    hideKeyboard()
                    viewModel.verifyMobileOTP()
                },
                isLoading: viewModel.isLoading
            )
            .padding(
                .top,
                24
            )

            resendMobileView
                .padding(
                    .top,
                    20
                )
                .padding(
                    .bottom,
                    26
                )
        }
        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button("Verify") {
                    hideKeyboard()
                    viewModel.verifyMobileOTP()
                }
            }
        }
        .padding(
            .horizontal,
            20
        )
    }

    // =========================================================
    // MARK: - Registration Complete
    // =========================================================

    private var registrationCompleteContent: some View {

        VStack(spacing: 0) {

            ZStack {

                Circle()
                    .fill(
                        Color.appVeryLightGreen
                    )
                    .frame(
                        width: 92,
                        height: 92
                    )

                Image(
                    systemName: "checkmark.circle.fill"
                )
                .font(
                    .system(
                        size: 52
                    )
                )
                .foregroundStyle(
                    Color.appPrimary
                )
            }
            .padding(
                .top,
                36
            )

            Text(
                NSLocalizedString(
                    "registration.complete.title",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 24,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .padding(
                .top,
                20
            )

            Text(
                NSLocalizedString(
                    "registration.complete.subtitle",
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
            .padding(
                .horizontal,
                20
            )
            .padding(
                .top,
                8
            )
            .padding(
                .bottom,
                36
            )
        }
        .padding(
            .horizontal,
            20
        )
    }

    // =========================================================
    // MARK: - Registration Icon
    // =========================================================

    private func registrationIcon(
        icon: String
    ) -> some View {

        ZStack {

            Circle()
                .fill(
                    Color.appVeryLightGreen
                )
                .frame(
                    width: 92,
                    height: 92
                )

            Image(
                systemName: icon
            )
            .font(
                .system(
                    size: 38,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appPrimary
            )
        }
    }

    // =========================================================
    // MARK: - Mobile Field
    // =========================================================

    private var mobileNumberField: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text(
                NSLocalizedString(
                    "registration.mobile.label",
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 14,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )

            HStack(spacing: 10) {

                Image(
                    systemName: "phone"
                )
                .foregroundStyle(
                    Color.appPrimary
                )

                Text("+91")
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        Color.appTextPrimary
                    )

                Rectangle()
                    .fill(
                        Color.appDivider
                    )
                    .frame(
                        width: 1,
                        height: 24
                    )

                TextField(
                    NSLocalizedString(
                        "registration.mobile.placeholder",
                        comment: ""
                    ),
                    text: $viewModel.mobileNumber
                )
                .keyboardType(
                    .numberPad
                )
                .textContentType(
                    .telephoneNumber
                )
                .font(
                    .system(
                        size: 16
                    )
                )
                .onChange(
                    of: viewModel.mobileNumber
                ) { _, newValue in

                    let filtered =
                        newValue.filter {
                            $0.isNumber
                        }

                    viewModel.mobileNumber =
                        String(
                            filtered.prefix(10)
                        )
                }
            }
            .padding(
                .horizontal,
                16
            )
            .frame(
                height: 56
            )
            .background(
                Color.appInputBackground
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
        .toolbar {

            ToolbarItemGroup(
                placement: .keyboard
            ) {

                Spacer()

                Button("Submit") {
                    hideKeyboard()
                    viewModel.submitMobile()
                }
            }
        }
    }

    // =========================================================
    // MARK: - Common Message
    // =========================================================

    @ViewBuilder
   private var messageView: some View {

        if !viewModel.errorMessage.isEmpty {

            AppErrorView(
                message: viewModel.errorMessage
            )
            .padding(
                .top,
                14
            )
        }

        if !viewModel.successMessage.isEmpty {

            AppSuccessView(
                message: viewModel.successMessage
            )
            .padding(
                .top,
                14
            )
        }
    }

    // =========================================================
    // MARK: - Resend Email
    // =========================================================

    private var resendEmailView: some View {

        HStack(spacing: 5) {

            Text(
                NSLocalizedString(
                    "registration.otp.not_received",
                    comment: ""
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )

            Button {
                viewModel.resendEmailOTP()

            } label: {

                Text(
                    NSLocalizedString(
                        "registration.otp.resend",
                        comment: ""
                    )
                )
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    Color.appPrimary
                )
            }
            .buttonStyle(
                .plain
            )
        }
        .font(
            .system(
                size: 13
            )
        )
    }

    // =========================================================
    // MARK: - Resend Mobile
    // =========================================================

    private var resendMobileView: some View {

        HStack(spacing: 5) {

            Text(
                NSLocalizedString(
                    "registration.otp.not_received",
                    comment: ""
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )

            Button {
                viewModel.resendMobileOTP()

            } label: {

                Text(
                    NSLocalizedString(
                        "registration.otp.resend",
                        comment: ""
                    )
                )
                .fontWeight(
                    .semibold
                )
                .foregroundStyle(
                    Color.appPrimary
                )
            }
            .buttonStyle(
                .plain
            )
        }
        .font(
            .system(
                size: 13
            )
        )
    }

    // =========================================================
    // MARK: - Hide Keyboard
    // =========================================================

    private func hideKeyboard() {

        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
