import SwiftUI

struct SplashView: View {

    @State private var showApp = false
    @State private var isLoggedIn = false

    var body: some View {

        ZStack {

            // IMPORTANT:
            // Same background stays behind every screen.
            Color.appBackground
                .ignoresSafeArea()


            // =====================================================
            // APP
            // =====================================================

            if showApp {

                if isLoggedIn {

                    HomeView()

                } else {

                    LoginView()
                }
            }


            // =====================================================
            // SPLASH
            // =====================================================

            if !showApp {

                splashContent
            }
        }
        .task {

            await checkAppState()
        }
    }


    // =============================================================
    // MARK: - Splash Content
    // =============================================================

    private var splashContent: some View {

        ZStack {

            Color.appBackground
                .ignoresSafeArea()



            VStack(
                spacing: 0
            ) {

                Spacer()


                HStack(
                    spacing: 12
                ) {

                    Image("ic_ddgky")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 120,
                            height: 75
                        )


                    Rectangle()
                        .fill(
                            Color.appBorder
                        )
                        .frame(
                            width: 1,
                            height: 55
                        )


                    Image("ic_rseti")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 120,
                            height: 75
                        )
                }


                Text(
                    NSLocalizedString(
                        "app.name",
                        comment: ""
                    )
                )
                .font(
                    .system(
                        size: 30,
                        weight: .bold
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
                .padding(
                    .top,
                    18
                )


                Text(
                    NSLocalizedString(
                        "app.department",
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
                .padding(
                    .top,
                    4
                )


                ProgressView()
                    .tint(
                        Color.appDarkGreen
                    )
                    .padding(
                        .top,
                        40
                    )


                Spacer()
            }


            VStack {

                Spacer()

                Image("rural_footer")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        maxWidth: .infinity
                    )
                    .frame(
                        height: 120
                    )
                    .clipped()
                    .opacity(0.75)
            }
            .ignoresSafeArea(
                edges: .bottom
            )
        }
    }


    // =============================================================
    // MARK: - App State
    // =============================================================

    private func checkAppState() async {

        // Splash duration

        try? await Task.sleep(
            nanoseconds:
                1_500_000_000
        )


        // Read login status

        let loggedIn =
            AppPreferences.shared.isLoggedIn()


        // Update state

        isLoggedIn = loggedIn

        showApp = true
    }
}
