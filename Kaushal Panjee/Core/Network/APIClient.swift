import Foundation
import Alamofire

final class APIClient {

    static let shared = APIClient()

    private init() {}

    // MARK: - Request With Body

    func request<T: Decodable, Body: Encodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        parameters: Body,
        requiresAuth: Bool = false,
        additionalHeaders: HTTPHeaders? = nil
    ) async throws -> T {

        let url = APIConstants.baseURL + endpoint
        var headers = HTTPHeaders()

        headers.add(
            name: "Content-Type",
            value: "application/json"
        )

        headers.add(
            name: "Accept",
            value: "application/json"
        )

        // Custom Headers
        if let additionalHeaders {
            for header in additionalHeaders {
                headers.update(header)
            }
        }
        // MARK: - Authorization

        if requiresAuth {

            guard let token = KeychainManager.shared.get(
                key: KeychainKeys.accessToken
            ) else {

                throw APIError.unauthorized
            }

            headers.add(
                name: "Authorization",
                value: token
            )
        }

        // MARK: - Request Log

        print("")
        print("========== API REQUEST ==========")
        print("URL: \(url)")
        print("METHOD: \(method.rawValue)")
        print("HEADERS: \(headers)")

        logRequestBody(parameters)

        print("=================================")
        print("")

        do {

            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )

            // MARK: - Response

            let response = await request
                .validate()
                .serializingData()
                .response

            // MARK: - Response Log

            print("")
            print("========== API RESPONSE ==========")
            print("URL: \(url)")

            if let statusCode = response.response?.statusCode {

                print("STATUS CODE: \(statusCode)")
            }

            if let data = response.data {

                logResponseBody(data)
            }

            print("==================================")
            print("")

            // MARK: - Error

            if let error = response.error {

                if let statusCode = response.response?.statusCode {

                    switch statusCode {

                    case 401:

                        throw APIError.unauthorized

                    case 500...599:

                        throw APIError.serverError

                    default:

                        throw APIError.invalidResponse
                    }
                }

                throw mapAFError(error)
            }

            // MARK: - Decode Response

            guard let data = response.data else {

                throw APIError.decodingError
            }

            do {

                let decodedResponse =
                    try JSONDecoder().decode(
                        T.self,
                        from: data
                    )

                return decodedResponse

            } catch {

                print("")
                print("========== DECODING ERROR ==========")
                print(error)
                print("====================================")
                print("")

                throw APIError.decodingError
            }

        } catch let error as APIError {

            throw error

        } catch {

            throw APIError.networkError
        }
    }


    // MARK: - Request Without Body

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        requiresAuth: Bool = false
    ) async throws -> T {

        let url = APIConstants.baseURL + endpoint

        var headers = HTTPHeaders()

        headers.add(
            name: "Accept",
            value: "application/json"
        )

        // MARK: - Authorization

        if requiresAuth {

            guard let token = KeychainManager.shared.get(
                key: KeychainKeys.accessToken
            ) else {

                throw APIError.unauthorized
            }

            headers.add(
                name: "Authorization",
                value: token
            )
        }

        // MARK: - Request Log

        print("")
        print("========== API REQUEST ==========")
        print("URL: \(url)")
        print("METHOD: \(method.rawValue)")
        print("HEADERS: \(headers)")
        print("REQUEST BODY: NONE")
        print("=================================")
        print("")

        do {

            let request = AF.request(
                url,
                method: method,
                headers: headers
            )

            // MARK: - Response

            let response = await request
                .validate()
                .serializingData()
                .response

            // MARK: - Response Log

            print("")
            print("========== API RESPONSE ==========")
            print("URL: \(url)")

            if let statusCode = response.response?.statusCode {

                print("STATUS CODE: \(statusCode)")
            }

            if let data = response.data {

                logResponseBody(data)
            }

            print("==================================")
            print("")

            // MARK: - Error

            if let error = response.error {

                if let statusCode = response.response?.statusCode {

                    switch statusCode {

                    case 401:

                        throw APIError.unauthorized

                    case 500...599:

                        throw APIError.serverError

                    default:

                        throw APIError.invalidResponse
                    }
                }

                throw mapAFError(error)
            }

            // MARK: - Decode

            guard let data = response.data else {

                throw APIError.decodingError
            }

            do {

                let decodedResponse =
                    try JSONDecoder().decode(
                        T.self,
                        from: data
                    )

                return decodedResponse

            } catch {

                print("")
                print("========== DECODING ERROR ==========")
                print(error)
                print("====================================")
                print("")

                throw APIError.decodingError
            }

        } catch let error as APIError {

            throw error

        } catch {

            throw APIError.networkError
        }
    }


    // MARK: - Request Body Logger

    private func logRequestBody<Body: Encodable>(
        _ body: Body
    ) {

        do {

            let encoder = JSONEncoder()

            encoder.outputFormatting = [
                .prettyPrinted,
                .sortedKeys
            ]

            let data = try encoder.encode(body)

            guard
                var jsonObject =
                    try JSONSerialization.jsonObject(
                        with: data
                    ) as? [String: Any]
            else {

                print("REQUEST: \(String(data: data, encoding: .utf8) ?? "")")
                return
            }

            // MARK: - Hide Sensitive Fields

            let sensitiveKeys = [
                "password",
                "accessToken",
                "authToken",
                "token",
                "fcmToken"
            ]

            for key in sensitiveKeys {

                if jsonObject[key] != nil {

                    jsonObject[key] = "******"
                }
            }

            let safeData =
                try JSONSerialization.data(
                    withJSONObject: jsonObject,
                    options: [
                        .prettyPrinted,
                        .sortedKeys
                    ]
                )

            print(
                "REQUEST:\n\(String(data: safeData, encoding: .utf8) ?? "")"
            )

        } catch {

            print(
                "REQUEST BODY: Unable to print request"
            )
        }
    }


    // MARK: - Response Logger

    private func logResponseBody(
        _ data: Data
    ) {

        guard !data.isEmpty else {

            print("RESPONSE: EMPTY")

            return
        }

        do {

            let jsonObject =
                try JSONSerialization.jsonObject(
                    with: data
                )

            let prettyData =
                try JSONSerialization.data(
                    withJSONObject: jsonObject,
                    options: [
                        .prettyPrinted,
                        .sortedKeys
                    ]
                )

            print(
                "RESPONSE:\n\(String(data: prettyData, encoding: .utf8) ?? "")"
            )

        } catch {

            print(
                "RESPONSE:\n\(String(data: data, encoding: .utf8) ?? "")"
            )
        }
    }


    // MARK: - Alamofire Error Mapping

    private func mapAFError(
        _ error: AFError
    ) -> APIError {

        if error.isSessionTaskError {

            return .networkError
        }

        if error.isResponseSerializationError {

            return .decodingError
        }

        return .networkError
    }
    
    
    // MARK: - External eKYC Request

    func requestExternalEkyc(
        url: String,
        parameters: [String: String]
    ) async throws -> Data {

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        print("")
        print("========== EKYC API REQUEST ==========")
        print("URL: \(url)")
        print("METHOD: POST")
        print("PARAMETERS: \(parameters)")
        print("======================================")

        let request = AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )

        let response = await request
            .validate()
            .serializingData()
            .response

        print("")
        print("========== EKYC API RESPONSE ==========")

        if let statusCode = response.response?.statusCode {
            print("STATUS CODE: \(statusCode)")
        }

        if let data = response.data {
            print("RESPONSE:")
            print(String(data: data, encoding: .utf8) ?? "")
        }

        print("=======================================")
        print("")

        if let error = response.error {
            throw error
        }

        guard let data = response.data else {
            throw APIError.decodingError
        }

        return data
    }
    
    
    
}
