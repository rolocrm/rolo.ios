import Foundation

protocol LoginRepositoryProtocol {
    func login(email: String, password: String) async throws -> (token: String, profileCreated: Bool)
    func googleLogin() async throws -> (token: String, profileCreated: Bool)
}

class LoginRepository: LoginRepositoryProtocol {
    private let authService: AuthService
    private let googleSignInService: GoogleSignInService
    private let keychainManager: KeychainManager

    init(
        authService: AuthService = .shared,
        googleSignInService: GoogleSignInService = .shared,
        keychainManager: KeychainManager = .shared
    ) {
        self.authService = authService
        self.googleSignInService = googleSignInService
        self.keychainManager = keychainManager
    }

    func login(email: String, password: String) async throws -> (token: String, profileCreated: Bool) {
        let result = try await authService.login(email: email, password: password)
        keychainManager.saveToken(result.token)
        return result
    }

    func googleLogin() async throws -> (token: String, profileCreated: Bool) {
        let idToken = try await googleSignInService.signIn()
        let result = try await authService.googleLogin(token: idToken)
        keychainManager.saveToken(result.token)
        return result
    }
}
