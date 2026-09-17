import SwiftUI

struct LoginHeaderView: View {
    
    @EnvironmentObject
    private var languageManager: LanguageManager

    var body: some View {

        VStack(
            spacing: 0
        ) {

            // MARK: Logos

            HStack(
                alignment: .center,
                spacing: 0
            ) {

                Image("ic_ddgky")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 95,
                        height: 58
                    )


                Rectangle()
                    .fill(
                        Color.appBorder
                    )
                    .frame(
                        width: 1,
                        height: 40
                    )
                    .padding(
                        .horizontal,
                        12
                    )


                Image("ic_rseti")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 95,
                        height: 58
                    )
            }


            // MARK: App Name

            Text(
                languageManager.localized("app.name")
            )
            .font(
                .system(
                    size: 25,
                    weight: .bold
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(
                .top,
                5
            )


            // MARK: Decorative Line

            HStack(
                spacing: 7
            ) {

                Rectangle()
                    .fill(
                        Color.appBorder
                    )
                    .frame(
                        width: 42,
                        height: 1
                    )

                Circle()
                    .fill(
                        Color.appDarkGreen
                    )
                    .frame(
                        width: 5,
                        height: 5
                    )

                Rectangle()
                    .fill(
                        Color.appBorder
                    )
                    .frame(
                        width: 42,
                        height: 1
                    )
            }
            .padding(
                .top,
                3
            )


            // MARK: Department

            Text(
                languageManager.localized("app.department")
            )
            .font(
                .system(
                    size: 13,
                    weight: .regular
                )
            )
            .foregroundStyle(
                Color.appTextSecondary
            )
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(
                .top,
                3
            )
        }
    }
}
