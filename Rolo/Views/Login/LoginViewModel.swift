import SwiftUI
import Foundation

enum LoginNavigationState: Equatable {
    case none
    case profile
    case welcome(userProfile: UserProfile)
    case home(userProfile: UserProfile)

//    static func == (lhs: LoginNavigationState, rhs: LoginNavigationState) -> Bool {
//        switch (lhs, rhs) {
//        case (.none, .none), (.profile, .profile):
//            return true
//        case (.home(let lhsName, _), .home(let rhsName, _)):
//            return lhsName == rhsName
//        case (.welcome(let lhsName, _), .welcome(let rhsName, _)):
//            return lhsName == rhsName
//        default:
//            return false
//        }
//    }
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var isGoogleLoading = false
    @Published var errorType = ""
    @Published var errorMessage = ""
    @Published var navigationState: LoginNavigationState = .none
    @Published var showPassword = false

    private let repository: LoginRepositoryProtocol

    init(repository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
    }

    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }

        Task {
            isLoading = true
            errorMessage = ""

            do {
                let result = try await repository.login(email: email, password: password)
                isLoading = false

                if result.profileCreated {
                    print("Profile created, fetching profile and navigating to WelcomeView")
                    await fetchProfileAndNavigateToHome(token: result.token)
                } else {
                    print("Profile not created, navigating to ProfileView")
                    navigationState = .profile
                }
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    func loginWithGoogle() {
        Task {
            isGoogleLoading = true
            errorMessage = ""

            do {
                let result = try await repository.googleLogin()
                print("Login with Google successful - Token: \(result.token), Profile Created: \(result.profileCreated)")
                isGoogleLoading = false

                if result.profileCreated {
                    print("Profile created, fetching profile and navigating to WelcomeView")
                    await fetchProfileAndNavigateToHome(token: result.token)
                } else {
                    print("Profile not created, navigating to ProfileView")
                    navigationState = .profile
                }
            } catch {
                isGoogleLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    private func fetchProfileAndNavigateToHome(token: String) async {
        do {
            let profile = try await UserService.shared.getProfile(token: token)
            if let imageStringURL = profile.imageStringURL, let url = URL(string: imageStringURL) {
                print("Downloading profile image from:", imageStringURL)
                let (data, _) = try await URLSession.shared.data(from: url)
                profile.imageData = data
            }

            // Check if user has communities (same logic as ContentView)
            if let communities = profile.communities, !communities.isEmpty {
                print("User has \(communities.count) communities, navigating to HomeView")
                navigationState = .home(userProfile: profile)
            } else {
                print("User has no communities, navigating to WelcomeView")
                navigationState = .welcome(userProfile: profile)
            }
        } catch {
            print("Failed to load profile after login:", error.localizedDescription)
            errorMessage = "Failed to load profile"
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func clearError() {
        errorMessage = ""
    }
}
