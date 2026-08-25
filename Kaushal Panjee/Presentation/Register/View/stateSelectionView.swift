import SwiftUI

struct StateSelectionView: View {

    @ObservedObject var viewModel: RegistrationViewModel

    var body: some View {

        VStack(spacing: 16) {

            Text("Select State")
                .font(
                    .system(
                        size: 24,
                        weight: .bold
                    )
                )

            // Selected State
            if let selectedState = viewModel.selectedState {

                HStack {

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {

                        Text("Selected State")
                            .font(.caption)

                        Text(selectedState.stateName)
                            .font(.headline)
                    }

                    Spacer()

                    Image(
                        systemName: "checkmark.circle.fill"
                    )
                }
                .padding()
            }

            // State List
            ScrollView {

                LazyVStack(spacing: 10) {

                    ForEach(viewModel.stateList) { state in

                        Button {

                            viewModel.selectState(state)

                        } label: {

                            HStack {

                                Text(state.stateName)

                                Spacer()

                                Image(
                                    systemName:
                                        viewModel.selectedState?.id == state.id
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                )
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            AppButton(
                title: "Next",
                icon: "arrow.right",
                action: {

                    viewModel.continueFromState()

                },
                isDisabled:
                    viewModel.selectedState == nil
            )
        }
        .padding()
    }
}
