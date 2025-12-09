import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isResetLinkSent = false

    var isFormValid: Bool {
        return !email.isEmpty && email.contains("@")
    }

    func clearError() {
        errorMessage = ""
    }

    func sendResetLink() {
        guard isFormValid else {
            errorMessage = "Please enter a valid email address"
            return
        }

        isLoading = true
        errorMessage = ""

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.isResetLinkSent = true
        }
    }
}
