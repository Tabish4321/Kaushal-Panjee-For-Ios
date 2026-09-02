import SwiftUI

@main
struct KaushalPanjeeApp: App {

    var body: some Scene {

        WindowGroup {

            NavigationStack {

                SplashView()

            }
            .onOpenURL { url in

                print("================================")
                print("OPEN URL RECEIVED")
                print("================================")

                print("URL:")
                print(url.absoluteString)

                FaceRDManager.shared.handleCallback(
                    url: url
                )
            }
        }
    }
}
