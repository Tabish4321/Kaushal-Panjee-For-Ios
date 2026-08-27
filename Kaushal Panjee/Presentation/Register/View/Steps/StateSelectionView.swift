import SwiftUI

struct StateSelectionView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        ZStack(
            alignment: .bottom
        ) {

            ScrollViewReader { proxy in

                ScrollView(
                    showsIndicators: false
                ) {

                    VStack(
                        spacing: 0
                    ) {

                        Color.clear
                            .frame(
                                height: 1
                            )
                            .id(
                                "TOP"
                            )

                        // MARK: - Header

                        VStack(
                            spacing: 0
                        ) {

                            Image(
                                systemName: "map.fill"
                            )
                            .font(
                                .system(
                                    size: 48
                                )
                            )
                            .foregroundStyle(
                                Color.appDarkGreen
                            )
                            .padding(
                                .top,
                                10
                            )

                            Text(
                                "Select your state"
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
                            .padding(
                                .top,
                                20
                            )

                            Text(
                                "Please select the state where you want to register."
                            )
                            .font(
                                .system(
                                    size: 15
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
                                8
                            )

                            // MARK: - Selected State

                            if let selectedState = viewModel.selectedState {

                                HStack(
                                    spacing: 10
                                ) {

                                    Image(
                                        systemName: "location.fill"
                                    )
                                    .font(
                                        .system(
                                            size: 16
                                        )
                                    )

                                    Text(
                                        selectedState.stateName
                                    )
                                    .font(
                                        .system(
                                            size: 15,
                                            weight: .semibold
                                        )
                                    )

                                    Spacer()

                                    Image(
                                        systemName: "checkmark.circle.fill"
                                    )
                                    .font(
                                        .system(
                                            size: 20
                                        )
                                    )
                                }
                                .foregroundStyle(
                                    Color.appDarkGreen
                                )
                                .padding(
                                    .horizontal,
                                    16
                                )
                                .frame(
                                    height: 54
                                )
                                .background(
                                    Color.appVeryLightGreen
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
                                        Color.appGreen.opacity(
                                            0.5
                                        ),
                                        lineWidth: 1
                                    )
                                }
                                .padding(
                                    .top,
                                    22
                                )
                            }
                        }
                        .frame(
                            maxWidth: .infinity
                        )

                        // MARK: - State List

                        LazyVStack(
                            spacing: 12
                        ) {

                            ForEach(
                                viewModel.stateList,
                                id: \.lgdStateCode
                            ) { state in

                                Button {

                                    viewModel.selectState(
                                        state
                                    )

                                    withAnimation(
                                        .easeInOut(
                                            duration: 0.35
                                        )
                                    ) {

                                        proxy.scrollTo(
                                            "TOP",
                                            anchor: .top
                                        )
                                    }

                                } label: {

                                    HStack(
                                        spacing: 14
                                    ) {

                                        Image(
                                            systemName:
                                                "location.fill"
                                        )
                                        .font(
                                            .system(
                                                size: 18
                                            )
                                        )
                                        .foregroundStyle(
                                            isSelected(
                                                state
                                            )
                                            ? Color.appGreen
                                            : Color.appTextSecondary
                                        )

                                        Text(
                                            state.stateName
                                        )
                                        .font(
                                            .system(
                                                size: 16,
                                                weight: .medium
                                            )
                                        )
                                        .foregroundStyle(
                                            Color.appDarkGreen
                                        )

                                        Spacer()

                                        Image(
                                            systemName:

                                                isSelected(
                                                    state
                                                )
                                                ? "checkmark.circle.fill"
                                                : "circle"
                                        )
                                        .font(
                                            .system(
                                                size: 22
                                            )
                                        )
                                        .foregroundStyle(
                                            isSelected(
                                                state
                                            )
                                            ? Color.appGreen
                                            : Color.appBorder
                                        )
                                    }
                                    .padding(
                                        .horizontal,
                                        16
                                    )
                                    .frame(
                                        height: 58
                                    )
                                    .background(
                                        isSelected(
                                            state
                                        )
                                        ? Color.appGreen.opacity(
                                            0.08
                                        )
                                        : Color.appCard
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
                                            isSelected(
                                                state
                                            )
                                            ? Color.appGreen
                                            : Color.appBorder,
                                            lineWidth: 1
                                        )
                                    }
                                }
                                .buttonStyle(
                                    .plain
                                )
                            }
                        }
                        .padding(
                            .top,
                            28
                        )

                        // MARK: - Error

                        if !viewModel.errorMessage.isEmpty {

                            Text(
                                viewModel.errorMessage
                            )
                            .font(
                                .system(
                                    size: 13
                                )
                            )
                            .foregroundStyle(
                                Color.red
                            )
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(
                                .top,
                                16
                            )
                        }

                        // Space for Floating Button

                        Color.clear
                            .frame(
                                height:
                                    viewModel.selectedState == nil
                                    ? 30
                                    : 120
                            )
                    }
                    .padding(
                        .horizontal,
                        24
                    )
                }
            }

            // MARK: - Floating Continue Button

            if viewModel.selectedState != nil {

                VStack(
                    spacing: 0
                ) {

                    LinearGradient(
                        colors: [
                            Color.appBackground.opacity(
                                0
                            ),
                            Color.appBackground
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(
                        height: 25
                    )

                    AppButton(
                        title: "CONTINUE",
                        icon: "arrow.right",
                        action: {

                            viewModel.continueFromState()
                        },
                        isDisabled: false
                    )
                    .padding(
                        .horizontal,
                        24
                    )
                    .padding(
                        .top,
                        8
                    )
                    .padding(
                        .bottom,
                        12
                    )
                    .background(
                        Color.appBackground
                    )
                }
            }
        }
        .animation(
            .easeInOut(
                duration: 0.25
            ),
            value:
                viewModel.selectedStateLGDCode
        )
    }

    // MARK: - Check Selected State

    private func isSelected(
        _ state: StateItem
    ) -> Bool {

        viewModel.selectedStateLGDCode
            == state.lgdStateCode
    }
}
