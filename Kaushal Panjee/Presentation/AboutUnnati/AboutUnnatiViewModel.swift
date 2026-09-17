import Foundation
import Combine

@MainActor
final class AboutUnnatiViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var isLoading = false
    @Published var errorMessage = ""

    @Published var unnatiData: UnnatiData?

    // MARK: - Repository

    private let repository: AboutUnnatiRepository

    // MARK: - Init

    init(
        repository: AboutUnnatiRepository = AboutUnnatiRepository()
    ) {
        self.repository = repository
    }

    // MARK: - Get Unnati

    func getUnnati(
        language: String
    ) {

        isLoading = true
        errorMessage = ""

        Task {

            do {

                let response = try await repository.getUnnati(
                    language: language
                )

                unnatiData = response.data

                isLoading = false

            } catch {

                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
