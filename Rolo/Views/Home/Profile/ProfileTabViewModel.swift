import Foundation

class ProfileTabViewModel: ObservableObject {
    @Published var isLoggingOut = false
    @Published var isDeleting = false
    @Published var showDeleteConfirmation = false
    @Published var accountDeleted = false
    @Published var errorMessage = ""
    
    private let authService = AuthService.shared
    
    func logout() {
        Task {
            await MainActor.run {
                isLoggingOut = true
            }
            
            do {
                try await authService.logout()
                await MainActor.run {
                    isLoggingOut = false
                }
            } catch {
                await MainActor.run {
                    isLoggingOut = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteAccount() {
        Task {
            await MainActor.run {
                isDeleting = true
                errorMessage = ""
            }
            
            do {
                try await authService.deleteAccount()
                await MainActor.run {
                    isDeleting = false
                    accountDeleted = true
                }
            } catch {
                await MainActor.run {
                    isDeleting = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
