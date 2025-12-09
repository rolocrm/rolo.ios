import Foundation

class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    init() {
    }
    
    func refreshData() {
    }
}
