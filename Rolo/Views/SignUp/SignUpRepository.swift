import Foundation

protocol SignUpRepositoryProtocol {
    func signup(email: String, password: String) async throws -> String
}

class SignUpRepository: SignUpRepositoryProtocol {
    private let authService: AuthService
    private let keychainManager: KeychainManager

    init(authService: AuthService = .shared, keychainManager: KeychainManager = .shared) {
        self.authService = authService
        self.keychainManager = keychainManager
    }

    func signup(email: String, password: String) async throws -> String {
        let token = try await authService.signup(email: email, password: password)
        keychainManager.saveToken(token)
        return token
    }
}
