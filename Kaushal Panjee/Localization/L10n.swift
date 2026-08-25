import Foundation

enum L10n {

    static func text(
        _ key: String
    ) -> String {

        NSLocalizedString(
            key,
            comment: ""
        )
    }

    static func text(
        _ key: String,
        _ arguments: CVarArg...
    ) -> String {

        String(
            format: NSLocalizedString(
                key,
                comment: ""
            ),
            arguments: arguments
        )
    }
}
