import Foundation

class AuthService {
    static let shared = AuthService()
    private init() {}

    func signup(email: String, password: String) async throws -> String {
        let url = URL(string: APIConstants.Auth.signup)!
        print("Signup URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        print("Signup request body:", body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([String: String].self, from: data)
        print("Signup response:", response)

        if let error = response["error"] {
            print("Signup error:", error)
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
        }

        guard let token = response["token"] else {
            print("Signup error: No token in response")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token"])
        }

        print("Signup successful, token received")
        return token
    }

    func login(email: String, password: String) async throws -> (token: String, profileCreated: Bool) {
        let url = URL(string: APIConstants.Auth.login)!
        print("Login URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        print("Login request body:", body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        print("Login response:", response)

        if let error = response["error"] as? String {
            print("Login error:", error)
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
        }

        guard let token = response["token"] as? String else {
            print("Login error: No token in response")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        }

        guard let profileCreated = response["profile_created"] as? Bool else {
            print("Login error: No profile_created in response")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        }

        print("Login successful, token:", token, "profile_created:", profileCreated)
        return (token, profileCreated)
    }

    func googleLogin(token: String) async throws -> (token: String, profileCreated: Bool) {
        let url = URL(string: APIConstants.Auth.googleLogin)!
        print("Google login URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["idToken": token]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        print("Google login request body:", body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        print("Google login response:", response)

        if let error = response["error"] as? String {
            print("Google login error:", error)
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
        }

        guard let authToken = response["token"] as? String else {
            print("Google login error: No token in response")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token in response"])
        }

        guard let profileCreated = response["profile_created"] as? Bool else {
            print("Google login error: No profile_created in response")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No profile_created in response"])
        }

        print("Google login successful, token:", authToken, "profile_created:", profileCreated)
        return (authToken, profileCreated)
    }
    
    func logout() async throws {
        KeychainManager.shared.deleteToken()
        print("AuthService: User logged out successfully")
    }
    
    func deleteAccount() async throws {
        guard let token = KeychainManager.shared.getToken() else {
            print("AuthService: No token found for account deletion")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token found"])
        }
        
        let url = URL(string: APIConstants.Auth.deleteAccount)!
        print("AuthService: Delete account URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (_, _) = try await URLSession.shared.data(for: request)
        print("AuthService: Account deleted successfully")
        
        KeychainManager.shared.deleteToken()
    }

}
