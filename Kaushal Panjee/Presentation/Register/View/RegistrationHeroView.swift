import SwiftUI

struct RegistrationHeroView: View {

    let icon: String
    let title: String
    let subtitle: String

    var highlightedText: String? = nil

    var body: some View {

        VStack(
            spacing: 14
        ) {

            // ====================================================
            // MARK: Icon Background
            // ====================================================

            ZStack {

                Circle()
                    .fill(
                        Color.appVeryLightGreen
                    )
                    .frame(
                        width: 120,
                        height: 120
                    )

                Circle()
                    .stroke(
                        Color.appPrimary.opacity(0.08),
                        lineWidth: 1
                    )
                    .frame(
                        width: 120,
                        height: 120
                    )

                Image(
                    systemName: icon
                )
                .font(
                    .system(
                        size: 52,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appPrimary
                )
            }

            // ====================================================
            // MARK: Title
            // ====================================================

            Text(
                NSLocalizedString(
                    title,
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 25,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appTextPrimary
            )
            .multilineTextAlignment(
                .center
            )

            // ====================================================
            // MARK: Subtitle
            // ====================================================

            Text(
                NSLocalizedString(
                    subtitle,
                    comment: ""
                )
            )
            .font(
                .system(
                    size: 15,
                    weight: .regular
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .multilineTextAlignment(
                .center
            )
            .lineSpacing(3)
            .padding(
                .horizontal,
                20
            )

            // ====================================================
            // MARK: Highlight Text
            // ====================================================

            if let highlightedText {

                Text(
                    highlightedText
                )
                .font(
                    .system(
                        size: 16,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    Color.appPrimary
                )
                .multilineTextAlignment(
                    .center
                )
                .padding(
                    .top,
                    -6
                )
            }
        }
    }
}
