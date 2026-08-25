import SwiftUI

struct RegistrationHeroIcon: View {

    let icon: String

    var body: some View {

        ZStack {

            Circle()
                .fill(
                    Color.appVeryLightGreen
                )
                .frame(
                    width: 132,
                    height: 132
                )

            Circle()
                .fill(
                    Color.appSurface
                        .opacity(0.90)
                )
                .frame(
                    width: 96,
                    height: 96
                )

            Image(
                systemName: icon
            )
            .font(
                .system(
                    size: 42,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
        }
        .shadow(
            color: Color.appDarkGreen.opacity(0.10),
            radius: 16,
            x: 0,
            y: 8
        )
    }
}
