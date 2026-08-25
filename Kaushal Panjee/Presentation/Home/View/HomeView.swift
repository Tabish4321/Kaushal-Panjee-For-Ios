import SwiftUI

struct HomeView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ZStack {

            // =====================================================
            // MARK: Background
            // =====================================================

            Color.appBackground
                .ignoresSafeArea()


            // =====================================================
            // MARK: Main Content
            // =====================================================

            VStack(
                spacing: 0
            ) {

                // =================================================
                // MARK: Header
                // =================================================

                HStack(
                    spacing: 12
                ) {

                    Image("ic_ddgky")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 55,
                            height: 42
                        )


                    VStack(
                        alignment: .leading,
                        spacing: 2
                    ) {

                        Text(
                            NSLocalizedString(
                                "app.name",
                                comment: ""
                            )
                        )
                        .font(
                            .system(
                                size: 18,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(
                            Color.appDarkGreen
                        )


                        Text(
                            NSLocalizedString(
                                "app.department",
                                comment: ""
                            )
                        )
                        .font(
                            .system(
                                size: 9,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(
                            Color.appTextSecondary
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    }


                    Spacer()


                    // =================================================
                    // MARK: Logout Button
                    // =================================================

                    Button {

                        logout()

                    } label: {

                        Image(
                            systemName:
                                "rectangle.portrait.and.arrow.right"
                        )
                        .font(
                            .system(
                                size: 20,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(
                            Color.appDarkGreen
                        )
                        .frame(
                            width: 42,
                            height: 42
                        )
                        .background(
                            Color.appVeryLightGreen
                        )
                        .clipShape(
                            Circle()
                        )
                    }
                    .buttonStyle(.plain)
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
                    10
                )
                .background(
                    Color.appSurface
                )


                // =================================================
                // MARK: Content
                // =================================================

                ScrollView(
                    showsIndicators: false
                ) {

                    VStack(
                        spacing: 16
                    ) {

                        // =================================================
                        // MARK: Welcome Card
                        // =================================================

                        AppCard {

                            HStack(
                                spacing: 14
                            ) {

                                ZStack {

                                    Circle()
                                        .fill(
                                            Color.appVeryLightGreen
                                        )

                                    Image(
                                        systemName:
                                            "person.fill"
                                    )
                                    .font(
                                        .system(
                                            size: 25,
                                            weight: .medium
                                        )
                                    )
                                    .foregroundStyle(
                                        Color.appDarkGreen
                                    )
                                }
                                .frame(
                                    width: 58,
                                    height: 58
                                )


                                VStack(
                                    alignment: .leading,
                                    spacing: 4
                                ) {

                                    Text(
                                        "Welcome"
                                    )
                                    .font(
                                        .system(
                                            size: 12
                                        )
                                    )
                                    .foregroundStyle(
                                        Color.appTextSecondary
                                    )


                                    Text(
                                        AppPreferences.shared
                                            .getUserId()
                                        ?? "User"
                                    )
                                    .font(
                                        .system(
                                            size: 18,
                                            weight: .bold
                                        )
                                    )
                                    .foregroundStyle(
                                        Color.appTextPrimary
                                    )
                                }


                                Spacer()
                            }
                        }


                        // =================================================
                        // MARK: Menu Cards
                        // =================================================

                        LazyVGrid(
                            columns: [
                                GridItem(
                                    .flexible(),
                                    spacing: 12
                                ),

                                GridItem(
                                    .flexible(),
                                    spacing: 12
                                )
                            ],
                            spacing: 14
                        ) {

                            homeMenuCard(
                                title: "Dashboard",
                                icon: "square.grid.2x2.fill"
                            )

                            homeMenuCard(
                                title: "Candidates",
                                icon: "person.3.fill"
                            )

                            homeMenuCard(
                                title: "Attendance",
                                icon: "calendar.badge.checkmark"
                            )

                            homeMenuCard(
                                title: "Training",
                                icon: "book.fill"
                            )
                        }
                    }
                    .padding(
                        .horizontal,
                        20
                    )
                    .padding(
                        .top,
                        18
                    )
                    .padding(
                        .bottom,
                        30
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }


    // =============================================================
    // MARK: - Menu Card
    // =============================================================

    private func homeMenuCard(
        title: String,
        icon: String
    ) -> some View {

        Button {

            // TODO:
            // Open respective module

        } label: {

            VStack(
                spacing: 12
            ) {

                ZStack {

                    RoundedRectangle(
                        cornerRadius: 14
                    )
                    .fill(
                        Color.appVeryLightGreen
                    )

                    Image(
                        systemName: icon
                    )
                    .font(
                        .system(
                            size: 24,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )
                }
                .frame(
                    width: 52,
                    height: 52
                )


                Text(title)
                    .font(
                        .system(
                            size: 13,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appTextPrimary
                    )
                    .lineLimit(1)
            }
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 125
            )
            .background(
                Color.appSurface
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 18
                )
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
            }
        }
        .buttonStyle(.plain)
    }


    // =============================================================
    // MARK: - Logout
    // =============================================================

    private func logout() {

        // Delete access token

        KeychainManager.shared.delete(
            key: KeychainKeys.accessToken
        )


        // Clear UserDefaults

        AppPreferences.shared.clearLoginData()


        // Go back to Login

        dismiss()
    }
}


// =============================================================
// MARK: - Preview
// =============================================================

#Preview {

    NavigationStack {

        HomeView()
    }
}
