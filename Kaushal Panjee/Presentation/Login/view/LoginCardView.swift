import SwiftUI

struct LoginCardView: View {

    @ObservedObject var viewModel: LoginViewModel

    let onRegisterClick: () -> Void

    var body: some View {

        ZStack(
            alignment: .top
        ) {

            AppCard {

                VStack(
                    spacing: 0
                ) {

                    Color.clear
                        .frame(
                            height: 36
                        )

                    // MARK: Title

                    Text(
                        NSLocalizedString(
                            "login.title",
                            comment: ""
                        )
                    )
                    .font(
                        .system(
                            size: 21,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        Color.appTextPrimary
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                    // MARK: Subtitle

                    Text(
                        NSLocalizedString(
                            "login.subtitle",
                            comment: ""
                        )
                    )
                    .font(
                        .system(
                            size: 11,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        Color.appTextSecondary
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .padding(
                        .top,
                        3
                    )

                    // MARK: Login ID

                    AppTextField(
                        title: "login.id",
                        placeholder: "login.id.placeholder",
                        icon: "person",
                        text: $viewModel.loginId
                    )
                    .padding(
                        .top,
                        14
                    )

                    // MARK: Password

                    AppPasswordField(
                        title: "login.password",
                        placeholder: "login.password.placeholder",
                        icon: "lock",
                        text: $viewModel.password
                    )
                    .padding(
                        .top,
                        8
                    )

                    // MARK: Forgot Password

                    HStack {

                        Spacer()

                        Button {

                            // TODO: Forgot Password

                        } label: {

                            Text(
                                NSLocalizedString(
                                    "login.forgot_password",
                                    comment: ""
                                )
                            )
                            .font(
                                .system(
                                    size: 11,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                Color.appDarkGreen
                            )
                            .underline()
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(
                        .top,
                        6
                    )

                    // MARK: Error

                    if !viewModel.errorMessage.isEmpty {

                        AppErrorView(
                            message: viewModel.errorMessage
                        )
                        .padding(
                            .top,
                            8
                        )
                    }

                    // MARK: Login Button

                    AppButton(
                        title: "login.button",
                        icon:
                            "rectangle.portrait.and.arrow.right",
                        action: {

                            viewModel.login()

                        },
                        isLoading:
                            viewModel.isLoading
                    )
                    .padding(
                        .top,
                        10
                    )

                    // MARK: OR

                    HStack(
                        spacing: 9
                    ) {

                        Rectangle()
                            .fill(
                                Color.appDivider
                            )
                            .frame(
                                height: 1
                            )

                        Text(
                            NSLocalizedString(
                                "common.or",
                                comment: ""
                            )
                        )
                        .font(
                            .system(
                                size: 10,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(
                            Color.appTextSecondary
                        )

                        Rectangle()
                            .fill(
                                Color.appDivider
                            )
                            .frame(
                                height: 1
                            )
                    }
                    .padding(
                        .top,
                        9
                    )

                    // MARK: Register / About

                    HStack(
                        spacing: 8
                    ) {

                        AppOutlinedButton(
                            title: "login.register",
                            icon: "person.badge.plus"
                        ) {

                            onRegisterClick()
                        }

                        AppOutlinedButton(
                            title: "login.about_unnati",
                            icon: "info.circle"
                        ) {

                            // TODO: About Unnati
                        }
                    }
                    .padding(
                        .top,
                        8
                    )
                    .padding(
                        .bottom,
                        14
                    )
                }
            }

            // MARK: Lock Badge

            LoginLockBadge()
                .offset(
                    y: -34
                )
        }
    }
}
