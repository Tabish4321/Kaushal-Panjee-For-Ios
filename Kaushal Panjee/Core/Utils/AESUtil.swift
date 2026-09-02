import Foundation
import CommonCrypto

enum AESUtil {

    // MARK: - Configuration

    private static let enableEncryption = true

    // IMPORTANT:
    // Android mein formatKey() first 16 bytes leta hai.
    // Isliye iOS mein bhi exactly same behavior rakha gaya hai.

    static let cryptId =
        "$10A80$10A80$10A80$10A80$10A80$10A80$10A80$10A80"

    static let cryptIV =
        "$10A80$10A80$10A80$10A80$10A80$10A80$10A80$10A80"


    // MARK: - Encrypt → Base64

    static func encryptIntoBase64String(
        inputText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        guard enableEncryption else {
            return inputText
        }

        // Android:
        //
        // val keyBytes = formatKey(secretKey)
        // val ivBytes = formatIV(ivKey)

        let keyBytes = formatKey(secretKey)
        let ivBytes = formatIV(ivKey)

        let inputData = Data(
            inputText.utf8
        )

        let bufferSize =
            inputData.count + kCCBlockSizeAES128

        var encryptedBytes = [UInt8](
            repeating: 0,
            count: bufferSize
        )

        var encryptedLength = 0

        let status: CCCryptorStatus =
            inputData.withUnsafeBytes { inputBuffer in

                encryptedBytes.withUnsafeMutableBytes { outputBuffer in

                    keyBytes.withUnsafeBytes { keyBuffer in

                        ivBytes.withUnsafeBytes { ivBuffer in

                            CCCrypt(
                                CCOperation(kCCEncrypt),

                                // AES
                                CCAlgorithm(kCCAlgorithmAES),

                                // Android:
                                // AES/CBC/PKCS5PADDING
                                //
                                // CommonCrypto:
                                // PKCS7Padding
                                //
                                // AES block size = 16,
                                // so behavior is compatible.
                                CCOptions(kCCOptionPKCS7Padding),

                                keyBuffer.baseAddress,
                                keyBytes.count,

                                ivBuffer.baseAddress,

                                inputBuffer.baseAddress,
                                inputData.count,

                                outputBuffer.baseAddress,
                                bufferSize,

                                &encryptedLength
                            )
                        }
                    }
                }
            }

        guard status == kCCSuccess else {

            print(
                "AES encryption failed. Status: \(status)"
            )

            return ""
        }

        let encryptedData = Data(
            bytes: encryptedBytes,
            count: encryptedLength
        )

        // Android:
        //
        // Base64.encodeToString(
        //     encryptedBytes,
        //     Base64.DEFAULT
        // ).trim()
        //
        // iOS Base64 does not add newline by default,
        // so this is equivalent.

        return encryptedData
            .base64EncodedString()
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
    }


    // MARK: - Decrypt Base64 → String

    static func decryptIntoString(
        inputText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        let keyBytes = formatKey(secretKey)
        let ivBytes = formatIV(ivKey)

        guard let encryptedData =
            Data(
                base64Encoded: inputText,
                options: [
                    .ignoreUnknownCharacters
                ]
            )
        else {

            print("AES: Invalid Base64")

            return ""
        }

        let bufferSize =
            encryptedData.count + kCCBlockSizeAES128

        var decryptedBytes = [UInt8](
            repeating: 0,
            count: bufferSize
        )

        var decryptedLength = 0

        let status: CCCryptorStatus =
            encryptedData.withUnsafeBytes { inputBuffer in

                decryptedBytes.withUnsafeMutableBytes { outputBuffer in

                    keyBytes.withUnsafeBytes { keyBuffer in

                        ivBytes.withUnsafeBytes { ivBuffer in

                            CCCrypt(
                                CCOperation(kCCDecrypt),

                                CCAlgorithm(kCCAlgorithmAES),

                                CCOptions(kCCOptionPKCS7Padding),

                                keyBuffer.baseAddress,
                                keyBytes.count,

                                ivBuffer.baseAddress,

                                inputBuffer.baseAddress,
                                encryptedData.count,

                                outputBuffer.baseAddress,
                                bufferSize,

                                &decryptedLength
                            )
                        }
                    }
                }
            }

        guard status == kCCSuccess else {

            print(
                "AES decryption failed. Status: \(status)"
            )

            return ""
        }

        let decryptedData = Data(
            bytes: decryptedBytes,
            count: decryptedLength
        )

        return String(
            data: decryptedData,
            encoding: .utf8
        ) ?? ""
    }


    // MARK: - AES Hex Decrypt

    static func aesDecrypt(
        encryptedText: String,
        secretKey: String,
        ivKey: String
    ) -> String {

        let keyBytes = formatKey(secretKey)
        let ivBytes = formatIV(ivKey)

        guard let encryptedData =
            hexStringToData(
                encryptedText
            )
        else {

            print("AES: Invalid hex string")

            return ""
        }

        let bufferSize =
            encryptedData.count + kCCBlockSizeAES128

        var decryptedBytes = [UInt8](
            repeating: 0,
            count: bufferSize
        )

        var decryptedLength = 0

        let status: CCCryptorStatus =
            encryptedData.withUnsafeBytes { inputBuffer in

                decryptedBytes.withUnsafeMutableBytes { outputBuffer in

                    keyBytes.withUnsafeBytes { keyBuffer in

                        ivBytes.withUnsafeBytes { ivBuffer in

                            CCCrypt(
                                CCOperation(kCCDecrypt),

                                CCAlgorithm(kCCAlgorithmAES),

                                CCOptions(kCCOptionPKCS7Padding),

                                keyBuffer.baseAddress,
                                keyBytes.count,

                                ivBuffer.baseAddress,

                                inputBuffer.baseAddress,
                                encryptedData.count,

                                outputBuffer.baseAddress,
                                bufferSize,

                                &decryptedLength
                            )
                        }
                    }
                }
            }

        guard status == kCCSuccess else {

            print(
                "AES hex decryption failed. Status: \(status)"
            )

            return ""
        }

        let decryptedData = Data(
            bytes: decryptedBytes,
            count: decryptedLength
        )

        return String(
            data: decryptedData,
            encoding: .utf8
        ) ?? ""
    }


    // MARK: - Android Compatible Key Formatter

    private static func formatKey(
        _ key: String
    ) -> [UInt8] {

        let keyBytes = Array(
            key.utf8
        )

        // Android:
        //
        // if (keyBytes.size == 16)
        //     return keyBytes
        //
        // if (keyBytes.size < 16)
        //     return keyBytes.copyOf(16)
        //
        // else
        //     return keyBytes.copyOf(16)

        if keyBytes.count == 16 {
            return keyBytes
        }

        if keyBytes.count < 16 {

            return keyBytes + Array(
                repeating: UInt8(0),
                count: 16 - keyBytes.count
            )
        }

        return Array(
            keyBytes.prefix(16)
        )
    }


    // MARK: - Android Compatible IV Formatter

    private static func formatIV(
        _ iv: String
    ) -> [UInt8] {

        let ivBytes = Array(
            iv.utf8
        )

        // IV must be exactly 16 bytes.

        if ivBytes.count == 16 {
            return ivBytes
        }

        if ivBytes.count < 16 {

            return ivBytes + Array(
                repeating: UInt8(0),
                count: 16 - ivBytes.count
            )
        }

        return Array(
            ivBytes.prefix(16)
        )
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
