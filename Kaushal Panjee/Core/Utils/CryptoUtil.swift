import Foundation
import CommonCrypto

enum CryptoUtil {

    // MARK: - SHA-512

    static func sha512(_ input: String) -> String {

        let data = Data(input.utf8)

        var digest = [UInt8](
            repeating: 0,
            count: Int(CC_SHA512_DIGEST_LENGTH)
        )

        data.withUnsafeBytes { buffer in

            _ = CC_SHA512(
                buffer.baseAddress,
                CC_LONG(data.count),
                &digest
            )
        }

        return digest
            .map {
                String(
                    format: "%02x",
                    $0
                )
            }
            .joined()
    }
}
