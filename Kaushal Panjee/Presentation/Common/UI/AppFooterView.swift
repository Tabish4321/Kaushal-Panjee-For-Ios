import SwiftUI

struct AppFooterView: View {

    var body: some View {

        VStack(
            spacing: 4
        ) {

            // MARK: - Security Banner

            AppSecurityBanner(
                title: "login.secure.title",
                subtitle: "login.secure.subtitle",
                icon: "checkmark.shield.fill"
            )


            // MARK: - Version

            Text(
                String(
                    format: NSLocalizedString(
                        "common.version",
                        comment: ""
                    ),
                    AppUtil.appVersion()
                )
            )
            .font(
                .system(
                    size: 10,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
        }
    }
}
