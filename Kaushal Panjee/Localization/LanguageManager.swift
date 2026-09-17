import Foundation
import Combine
import SwiftUI

final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()

    @Published var currentLanguage: String

    private init() {

        currentLanguage =
            UserDefaults.standard.string(
                forKey: "appLanguage"
            ) ?? "en"
    }

    func setLanguage(
        _ language: String
    ) {

        guard
            language == "en" ||
            language == "hi"
        else {
            return
        }

        currentLanguage = language

        UserDefaults.standard.set(
            language,
            forKey: "appLanguage"
        )
    }

    func localized(
        _ key: String
    ) -> String {

        let languageCode =
            currentLanguage == "hi"
            ? "hi"
            : "en"

        guard
            let path = Bundle.main.path(
                forResource: languageCode,
                ofType: "lproj"
            ),
            let bundle = Bundle(path: path)
        else {

            return NSLocalizedString(
                key,
                comment: ""
            )
        }

        return NSLocalizedString(
            key,
            bundle: bundle,
            comment: ""
        )
    }
}
