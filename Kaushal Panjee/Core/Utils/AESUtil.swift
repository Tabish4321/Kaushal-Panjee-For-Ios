import Foundation
import CommonCrypto

enum AESUtil {

    private static let enableEncryption = true

    // MARK: - Encrypt → Base64

    static func encryptIntoBase64String(
        inputText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        guard enableEncryption else {
            return inputText
        }

        do {
            let keyBytes = formatKey(secretKey)
            let ivBytes = formatIV(ivKey)

            let inputData = Data(inputText.utf8)

            let encryptedData = try crypt(
                data: inputData,
                key: keyBytes,
                iv: ivBytes,
                operation: CCOperation(kCCEncrypt)
            )

            return encryptedData.base64EncodedString()

        } catch {
            print("AES encryption failed: \(error)")
            return ""
        }
    }

    // MARK: - Decrypt Base64 → String

    static func decryptIntoString(
        inputText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        do {
            let keyBytes = formatKey(secretKey)
            let ivBytes = formatIV(ivKey)

            guard let encryptedData = Data(
                base64Encoded: inputText
            ) else {
                return ""
            }

            let decryptedData = try crypt(
                data: encryptedData,
                key: keyBytes,
                iv: ivBytes,
                operation: CCOperation(kCCDecrypt)
            )

            return String(
                data: decryptedData,
                encoding: .utf8
            ) ?? ""

        } catch {
            print("AES decryption failed: \(error)")
            return ""
        }
    }

    // MARK: - Decrypt Hex → String

    static func aesDecrypt(
        encryptedText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        do {
            let keyBytes = formatKey(secretKey)
            let ivBytes = formatIV(ivKey)

            guard let encryptedData = hexStringToData(
                encryptedText
            ) else {
                return ""
            }

            let decryptedData = try crypt(
                data: encryptedData,
                key: keyBytes,
                iv: ivBytes,
                operation: CCOperation(kCCDecrypt)
            )

            return String(
                data: decryptedData,
                encoding: .utf8
            ) ?? ""

        } catch {
            print("AES hex decryption failed: \(error)")
            return ""
        }
    }

    // MARK: - AES Operation

    private static func crypt(
        data: Data,
        key: [UInt8],
        iv: [UInt8],
        operation: CCOperation
    ) throws -> Data {

        let outputSize =
            data.count + kCCBlockSizeAES128

        var output = [UInt8](
            repeating: 0,
            count: outputSize
        )

        var outputLength = 0

        let status: CCCryptorStatus = data.withUnsafeBytes { dataBuffer in

            output.withUnsafeMutableBytes { outputBuffer in

                key.withUnsafeBytes { keyBuffer in

                    iv.withUnsafeBytes { ivBuffer in

                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBuffer.baseAddress,
                            key.count,
                            ivBuffer.baseAddress,
                            dataBuffer.baseAddress,
                            data.count,
                            outputBuffer.baseAddress,
                            outputSize,
                            &outputLength
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else {
            throw NSError(
                domain: "AESUtil",
                code: Int(status),
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "AES operation failed with status: \(status)"
                ]
            )
        }

        return Data(
            bytes: output,
            count: outputLength
        )
    }

    // MARK: - Key Formatter

    private static func formatKey(
        _ key: String
    ) -> [UInt8] {

        let bytes = Array(key.utf8)

        if bytes.count == 16 {
            return bytes
        }

        if bytes.count < 16 {
            return bytes + Array(
                repeating: UInt8(0),
                count: 16 - bytes.count
            )
        }

        return Array(bytes.prefix(16))
    }

    // MARK: - IV Formatter

    private static func formatIV(
        _ iv: String
    ) -> [UInt8] {

        let bytes = Array(iv.utf8)

        if bytes.count == 16 {
            return bytes
        }

        if bytes.count < 16 {
            return bytes + Array(
                repeating: UInt8(0),
                count: 16 - bytes.count
            )
        }

        return Array(bytes.prefix(16))
    }

    // MARK: - Hex → Data

    private static func hexStringToData(
        _ hex: String
    ) -> Data? {

        guard hex.count % 2 == 0 else {
            return nil
        }

        var data = Data()

        var index = hex.startIndex

        while index < hex.endIndex {

            let nextIndex = hex.index(
                index,
                offsetBy: 2
            )

            let byteString = String(
                hex[index..<nextIndex]
            )

            guard let byte = UInt8(
                byteString,
                radix: 16
            ) else {
                return nil
            }

            data.append(byte)

            index = nextIndex
        }

        return data
    }
}
