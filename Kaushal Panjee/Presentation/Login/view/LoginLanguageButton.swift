import SwiftUI

struct LoginLanguageButton: View {

    var body: some View {

        Button {

            // TODO:
            // Open language selection

        } label: {

            HStack(
                spacing: 6
            ) {

                Image(
                    systemName: "character.bubble"
                )
                .font(
                    .system(
                        size: 14,
                        weight: .medium
                    )
                )


                Text(
                    NSLocalizedString(
                        "login.language",
                        comment: ""
                    )
                )
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )


                Image(
                    systemName: "chevron.down"
                )
                .font(
                    .system(
                        size: 8,
                        weight: .bold
                    )
                )
            }
            .foregroundStyle(
                Color.appDarkGreen
            )
            .padding(
                .horizontal,
                13
            )
            .frame(
                height: 34
            )
            .background(
                Color.appSurface
            )
            .clipShape(
                Capsule()
            )
            .overlay {

                Capsule()
                    .stroke(
                        Color.appBorder,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
    }
}
