import Foundation

struct AnyCodable: Codable {

    let value: Any

    init(from decoder: Decoder) throws {

        let container =
            try decoder.singleValueContainer()

        if let value =
            try? container.decode(String.self) {

            self.value = value

        } else if let value =
                    try? container.decode(Int.self) {

            self.value = value

        } else if let value =
                    try? container.decode(Double.self) {

            self.value = value

        } else if let value =
                    try? container.decode(Bool.self) {

            self.value = value

        } else {

            self.value = NSNull()
        }
    }

    func encode(
        to encoder: Encoder
    ) throws {

        var container =
            encoder.singleValueContainer()

        if let value = value as? String {
            try container.encode(value)

        } else if let value = value as? Int {
            try container.encode(value)

        } else if let value = value as? Double {
            try container.encode(value)

        } else if let value = value as? Bool {
            try container.encode(value)

        } else {
            try container.encodeNil()
        }
    }
}
