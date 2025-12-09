import SwiftUI

class JoinCommunityViewModel: ObservableObject {
    @Published var communityHandle = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isRequestSent = false

    var isFormValid: Bool {
        return !communityHandle.isEmpty
    }

    func clearError() {
        errorMessage = ""
    }

    func requestToJoin() {
        guard isFormValid else {
            errorMessage = "Please enter a community handle"
            return
        }

        isLoading = true
        errorMessage = ""

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            self.isRequestSent = true
        }
    }
}
