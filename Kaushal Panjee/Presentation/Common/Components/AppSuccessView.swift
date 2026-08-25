import SwiftUI

struct AppSuccessView: View {

    let message: String

    var body: some View {

        HStack(
            spacing: 10
        ) {

            Image(
                systemName:
                    "checkmark.circle.fill"
            )
            .foregroundStyle(
                Color.appPrimary
            )

            Text(message)
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appPrimary
                )

            Spacer()
        }
        .padding(
            12
        )
        .background(
            Color.appVeryLightGreen
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 12
            )
        )
    }
}
