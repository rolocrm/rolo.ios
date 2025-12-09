import SwiftUI
import Foundation

@MainActor
class WelcomeViewModel: ObservableObject {
    @Published var isDeleting = false
    @Published var showDeleteConfirmation = false
    @Published var errorMessage = ""
    @Published var accountDeleted = false

    private let keychainManager: KeychainManager

    init(keychainManager: KeychainManager = .shared) {
        self.keychainManager = keychainManager
    }

    func deleteAccount() {
        guard let token = keychainManager.getToken() else {
            print("Delete account error: No token found")
            errorMessage = "No authentication token found"
            return
        }

        Task {
            isDeleting = true
            errorMessage = ""

            do {
                let url = URL(string: APIConstants.Auth.deleteAccount)!
                print("Delete account URL:", url)
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.delete.rawValue
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let (_, _) = try await URLSession.shared.data(for: request)
                print("Account deleted successfully")

                keychainManager.deleteToken()

                await MainActor.run {
                    isDeleting = false
                    accountDeleted = true
                }
            } catch {
                print("Delete account error:", error.localizedDescription)
                await MainActor.run {
                    isDeleting = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
