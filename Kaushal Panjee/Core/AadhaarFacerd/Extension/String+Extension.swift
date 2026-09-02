//
//  String+Extension.swift
//  Aadhaar Service
//
//  Created by Rohan Kumar on 06/08/26.
//

import Foundation

extension String {

    static func getString(_ value: Any?) -> String {

        guard let value = value, !(value is NSNull) else {
            return ""
        }

        switch value {
        case let string as String:
            return string.trimmingCharacters(in: .whitespacesAndNewlines)

        case let int as Int:
            return "\(int)"

        case let double as Double:
            return "\(double)"

        case let float as Float:
            return "\(float)"

        case let bool as Bool:
            return bool ? "true" : "false"

        case let number as NSNumber:
            return number.stringValue

        default:
            return "\(value)"
        }
    }
    /// Extracts the first number found in the string as a string.
    /// - Returns: An optional string if a number is found, or `nil` if no number exists.
    func extractNumberString() -> String? {
        let pattern = "\\d+" // Regular expression pattern to match one or more digits
        
        do {
            // Check if the string is purely numeric
            if let _ = Double(self) {
                return self // Return the string itself if it's a number
            }
            
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            
            if let match = matches.first {
                return String(self[Range(match.range, in: self)!]) // Extract the matched number as a string
            }
        } catch {
            print("Regex error: \(error)")
        }
        
        return nil
    }
}
