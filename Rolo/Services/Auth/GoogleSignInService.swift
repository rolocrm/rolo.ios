import Foundation
import GoogleSignIn

class GoogleSignInService {
    static let shared = GoogleSignInService()
    private init() {}

    private let clientID = "880195735821-5qdbec3eua4pcvkho6gvi35ao2do3gtc.apps.googleusercontent.com"

    func signIn() async throws -> String {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = await windowScene.windows.first?.rootViewController else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller"])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ID token"])
        }

        print("Google ID Token: \(idToken)")
        return idToken
    }
}
