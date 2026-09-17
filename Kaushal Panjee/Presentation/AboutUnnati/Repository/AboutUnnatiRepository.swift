import Foundation
import Alamofire

final class AboutUnnatiRepository {

    // MARK: - Properties

    private let apiClient: APIClient

    // MARK: - Init

    init(
        apiClient: APIClient = APIClient.shared
    ) {
        self.apiClient = apiClient
    }

    // MARK: - Get Unnati Schemes

    func getUnnati(
        language: String
    ) async throws -> UnnatiResponse {

        let request = UnnatiRequest(
            language: language
        )

        return try await apiClient.request(
            endpoint: APIConstants.getUnnati,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
}
