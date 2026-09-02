import SwiftUI
internal import UIKit

// ============================================================
// MARK: - App Colors
// ============================================================

extension Color {

    // --------------------------------------------------------
    // MARK: Brand
    // --------------------------------------------------------

    static let appPrimary = Color(
        light: "#176B3A",
        dark: "#65C98A"
    )

    static let appDarkGreen = Color(
        light: "#176B3A",
        dark: "#65C98A"
    )

    static let appGreen = Color(
        light: "#2E9B57",
        dark: "#79D99A"
    )


    // --------------------------------------------------------
    // MARK: Background
    // --------------------------------------------------------

    static let appBackground = Color(
        light: "#F4FAF6",
        dark: "#101713"
    )

    /// Generic surface color
    /// Used for cards, fields and other elevated surfaces.
    static let appSurface = Color(
        light: "#FFFFFF",
        dark: "#1A241E"
    )

    /// Card color
    static let appCard = Color(
        light: "#FFFFFF",
        dark: "#1A241E"
    )

    /// Input / secondary surface
    static let appInputBackground = Color(
        light: "#FFFFFF",
        dark: "#202C25"
    )

    /// Very light green
    static let appVeryLightGreen = Color(
        light: "#E8F5EC",
        dark: "#21382A"
    )


    // --------------------------------------------------------
    // MARK: Text
    // --------------------------------------------------------

    static let appTextPrimary = Color(
        light: "#17231B",
        dark: "#F2F7F3"
    )

    static let appTextSecondary = Color(
        light: "#68756D",
        dark: "#AAB8AF"
    )

    static let appTextTertiary = Color(
        light: "#8A968F",
        dark: "#829188"
    )


    // --------------------------------------------------------
    // MARK: Border
    // --------------------------------------------------------

    static let appBorder = Color(
        light: "#C9D8CE",
        dark: "#3A4B40"
    )

    static let appDivider = Color(
        light: "#DCE7E0",
        dark: "#314138"
    )
}


// ============================================================
// MARK: - Dynamic Color
// ============================================================

extension Color {

    init(
        light: String,
        dark: String
    ) {
        self.init(
            UIColor(
                light: light,
                dark: dark
            )
        )
    }
}


// ============================================================
// MARK: - Dynamic UIColor
// ============================================================

extension UIColor {

    convenience init(
        light: String,
        dark: String
    ) {
        self.init { traitCollection in

            let hexColor =
                traitCollection.userInterfaceStyle == .dark
                ? dark
                : light

            return UIColor(
                hex: hexColor
            )
        }
    }


    // --------------------------------------------------------
    // MARK: Hex
    // --------------------------------------------------------

    convenience init(
        hex: String
    ) {

        let cleanedHex =
            hex
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
                .replacingOccurrences(
                    of: "#",
                    with: ""
                )

        var hexValue: UInt64 = 0

        Scanner(
            string: cleanedHex
        )
        .scanHexInt64(
            &hexValue
        )

        let red =
            CGFloat(
                (hexValue & 0xFF0000) >> 16
            ) / 255.0

        let green =
            CGFloat(
                (hexValue & 0x00FF00) >> 8
            ) / 255.0

        let blue =
            CGFloat(
                hexValue & 0x0000FF
            ) / 255.0

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: 1.0
        )
    }
}
