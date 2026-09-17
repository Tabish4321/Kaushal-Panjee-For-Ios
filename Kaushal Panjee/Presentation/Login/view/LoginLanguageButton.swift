import SwiftUI

struct LoginLanguageButton: View {

    @EnvironmentObject
    private var languageManager: LanguageManager

    @State
    private var showLanguageMenu = false

    var body: some View {

        Button {
            showLanguageMenu = true
        } label: {

            HStack(spacing: 6) {

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
                    languageManager.currentLanguage == "hi"
                    ? "हिंदी"
                    : "English"
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
        .confirmationDialog(
            languageManager.localized("login.language"),
            isPresented: $showLanguageMenu,
            titleVisibility: .visible
        ) {

            Button("English") {
                languageManager.setLanguage("en")
            }

            Button("हिंदी") {
                languageManager.setLanguage("hi")
            }

            Button(
                languageManager.localized("common.cancel"),
                role: .cancel
            ) {}

        }
    }
}
