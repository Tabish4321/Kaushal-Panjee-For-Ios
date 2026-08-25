import Foundation

final class AppPreferences {

    static let shared = AppPreferences()

    private init() {}

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {

        static let userId = "user_id"
        static let isLoggedIn = "is_logged_in"
    }


    // MARK: - User ID

    func saveUserId(
        _ userId: String
    ) {

        defaults.set(
            userId,
            forKey: Keys.userId
        )
    }

    func getUserId() -> String? {

        defaults.string(
            forKey: Keys.userId
        )
    }


    // MARK: - Login Status

    func saveLoginStatus(
        _ status: Bool
    ) {

        defaults.set(
            status,
            forKey: Keys.isLoggedIn
        )
    }

    func isLoggedIn() -> Bool {

        defaults.bool(
            forKey: Keys.isLoggedIn
        )
    }


    // MARK: - Clear Login Data

    func clearLoginData() {

        defaults.removeObject(
            forKey: Keys.userId
        )

        defaults.set(
            false,
            forKey: Keys.isLoggedIn
        )
    }
}
