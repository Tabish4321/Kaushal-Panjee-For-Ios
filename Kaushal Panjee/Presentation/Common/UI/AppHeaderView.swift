import SwiftUI

struct AppHeaderView: View {

    var title: String

    var showBackButton: Bool = true

    var onBack: (() -> Void)? = nil

    var body: some View {

        HStack {

            // MARK: - Back Button

            if showBackButton {

                Button {

                    onBack?()

                } label: {

                    Image(
                        systemName: "chevron.left"
                    )
                    .font(
                        .system(
                            size: 17,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )
                    .frame(
                        width: 44,
                        height: 44
                    )
                    .background(
                        Color.appCard
                    )
                    .clipShape(
                        Circle()
                    )
                    .overlay {

                        Circle()
                            .stroke(
                                Color.appBorder,
                                lineWidth: 1
                            )
                    }
                }
                .buttonStyle(
                    .plain
                )

            } else {

                Color.clear
                    .frame(
                        width: 44,
                        height: 44
                    )
            }


            Spacer()


            // MARK: - Title

            Text(
                title
            )
            .font(
                .system(
                    size: 20,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )


            Spacer()


            // MARK: - Right Placeholder

            Color.clear
                .frame(
                    width: 44,
                    height: 44
                )
        }
        .padding(
            .horizontal,
            20
        )
        .padding(
            .top,
            10
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
