import SwiftUI

struct LoginView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel: LoginViewModel

    // MARK: - Navigation

    @State private var navigateToRegistration = false


    // MARK: - Init

    init() {

        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                repository: LoginRepository()
            )
        )
    }


    // MARK: - Body

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: Background

                Color.appBackground
                    .ignoresSafeArea()


                // MARK: Rural Footer

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


                // MARK: Main Content

                VStack(
                    spacing: 0
                ) {

                    Spacer()
                        .frame(
                            height:
                                geometry.safeAreaInsets.top + 55
                        )


                    // MARK: Language

                    HStack {

                        Spacer()

                        LoginLanguageButton()
                            .padding(
                                .trailing,
                                20
                            )
                    }


                    // MARK: Header

                    LoginHeaderView()
                        .padding(
                            .top,
                            10
                        )


                    // MARK: Login Card

                    LoginCardView(
                        viewModel: viewModel,
                        onRegisterClick: {

                            navigateToRegistration = true
                        }
                    )
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .top,
                        50
                    )


                    Spacer(
                        minLength: 0
                    )


                    // MARK: Security

                    AppSecurityBanner(
                        title: "login.secure.title",
                        subtitle: "login.secure.subtitle",
                        icon: "checkmark.shield.fill"
                    )
                    .padding(
                        .bottom,
                        4
                    )


                    // MARK: Version

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
        }
        .ignoresSafeArea(
            edges: .top
        )
        .background(
            Color.appBackground
        )

        // MARK: Login → Home

        .navigationDestination(
            isPresented:
                $viewModel.loginSuccess
        ) {

            HomeView()
        }

        // MARK: Login → Registration

        .navigationDestination(
            isPresented: $navigateToRegistration
        ) {

            RegistrationView()
        }
    }
}
