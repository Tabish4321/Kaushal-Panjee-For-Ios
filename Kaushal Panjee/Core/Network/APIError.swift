import Foundation

enum APIError: LocalizedError {

    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError
    case decodingError
    case networkError
    case unknown

    var errorDescription: String? {

        switch self {

        case .invalidURL:
            return "Invalid URL"

        case .invalidResponse:
            return "Invalid server response"

        case .unauthorized:
            return "Session expired"

        case .serverError:
            return "Server error"

        case .decodingError:
            return "Unable to process server response"

        case .networkError:
            return "Network error"

        case .unknown:
            return "Something went wrong"
        }
    }
}
