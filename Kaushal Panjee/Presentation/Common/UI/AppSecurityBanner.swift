import SwiftUI

struct AppSecurityBanner: View {

    // MARK: - Properties

    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    let icon: String


    // MARK: - Body

    var body: some View {

        HStack(spacing: 9) {

            // =====================================================
            // MARK: Security Icon
            // =====================================================

            ZStack {

                Circle()
                    .fill(
                        Color.appVeryLightGreen
                    )

                Image(
                    systemName: icon
                )
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )
            }
            .frame(
                width: 38,
                height: 38
            )


            // =====================================================
            // MARK: Text
            // =====================================================

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(title)
                    .font(
                        .system(
                            size: 11,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(subtitle)
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
                    .minimumScaleFactor(0.65)
            }


            Spacer(
                minLength: 0
            )


            // =====================================================
            // MARK: Arrow
            // =====================================================

            Image(
                systemName: "chevron.right"
            )
            .font(
                .system(
                    size: 10,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
        }
        .padding(
            .horizontal,
            13
        )
        .frame(
            width: 280,
            height: 52
        )
        .background(
            Color.appCard.opacity(0.95)
        )
        .clipShape(
            Capsule()
        )
        .overlay {

            Capsule()
                .stroke(
                    Color.appBorder.opacity(0.6),
                    lineWidth: 1
                )
        }
        .shadow(
            color:
                Color.black.opacity(0.06),
            radius: 9,
            x: 0,
            y: 3
        )
    }
}
