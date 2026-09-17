import SwiftUI

struct AppOutlinedButton: View {

    // MARK: - Properties

    let title: String

    let icon: String

    let action: () -> Void


    // MARK: - Body

    var body: some View {

        Button(
            action: action
        ) {

            HStack(
                spacing: 7
            ) {

                // =====================================================
                // MARK: Icon
                // =====================================================

                Image(
                    systemName: icon
                )
                .font(
                    .system(
                        size: 18,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appDarkGreen
                )


                // =====================================================
                // MARK: Title
                // =====================================================

                Text(verbatim: title)
                    .font(
                        .system(
                            size: 12,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        Color.appDarkGreen
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(
                maxWidth: .infinity
            )
            .frame(
                height: 46
            )
            .background(
                Color.appCard
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 13
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 13
                )
                .stroke(
                    Color.appBorder,
                    lineWidth: 1
                )
            }
        }
        .buttonStyle(.plain)
    }
}
