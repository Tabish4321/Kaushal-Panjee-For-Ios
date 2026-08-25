import SwiftUI

struct AppButton: View {

    let title: LocalizedStringKey

    let icon: String?

    let action: () -> Void

    var isLoading: Bool = false

    var isDisabled: Bool = false

    var body: some View {

        Button {

            guard !isLoading else { return }

            action()

        } label: {

            ZStack {

                // Normal Button Content
                if !isLoading {

                    HStack(spacing: 12) {

                        if let icon {

                            AppIcon(
                                icon,
                                size: 22,
                                color: .white
                            )
                        }

                        AppText(
                            title,
                            size: 17,
                            weight: .semibold,
                            color: .white
                        )

                        Spacer()

                        AppIcon(
                            "chevron.right",
                            size: 16,
                            color: .white
                        )
                    }

                } else {

                    // Loader inside button
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(
                                tint: .white
                            )
                        )
                }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [
                        Color.appDarkGreen,
                        Color.appGreen
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 16
                )
            )
            .shadow(
                color: Color.appDarkGreen.opacity(0.20),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1)
    }
}
