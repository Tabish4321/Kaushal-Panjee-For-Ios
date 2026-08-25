import Foundation
import Alamofire

final class LoginRepository {

    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }

    func generateToken(
        request: TokenRequest
    ) async throws -> TokenResponse {

        return try await apiClient.request(
            endpoint: APIConstants.generateToken,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
    
    

    func login(
        request: LoginRequest
    ) async throws -> LoginResponse {

        return try await apiClient.request(
            endpoint: APIConstants.login,
            method: .post,
            parameters: request,
            requiresAuth: false
        )
    }
}
