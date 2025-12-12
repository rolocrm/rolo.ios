import SwiftUI
import Foundation

enum SignUpNavigationState: Equatable {
    case none
    case profile
    case home(userProfile: UserProfile)
    case welcome(userProfile: UserProfile)

//    static func == (lhs: SignUpNavigationState, rhs: SignUpNavigationState) -> Bool {
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
class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var isGoogleLoading = false
    @Published var errorMessage = ""
    @Published var navigationState: SignUpNavigationState = .none
    @Published var showPassword = false
    @Published var showConfirmPassword = false

    private let repository: SignUpRepositoryProtocol
    private let googleRepository: LoginRepositoryProtocol

    init(repository: SignUpRepositoryProtocol = SignUpRepository(), googleRepository: LoginRepositoryProtocol = LoginRepository()) {
        self.repository = repository
        self.googleRepository = googleRepository
    }

    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    func signUp() {
        guard !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        Task {
            isLoading = true
            errorMessage = ""

            do {
                _ = try await repository.signup(email: email, password: password)
                isLoading = false
                navigationState = .profile
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    func signUpWithGoogle() {
        Task {
            isGoogleLoading = true
            errorMessage = ""

            do {
                let result = try await googleRepository.googleLogin()
                isGoogleLoading = false
                await checkProfileAndNavigate(token: result.token, profileCreated: result.profileCreated)
            } catch {
                isGoogleLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }

    private func checkProfileAndNavigate(token: String, profileCreated: Bool) async {
        print("Checking profile completeness after signup, profileCreated:", profileCreated)

        if profileCreated {
            print("Profile created, fetching profile and checking communities")
            do {
                let profile = try await UserService.shared.getProfile(token: token)
                if let imageStringURL = profile.imageStringURL, let url = URL(string: imageStringURL) {
                    print("Downloading profile image from:", imageStringURL)
                    let (data, _) = try await URLSession.shared.data(from: url)
                    profile.imageData = data
                }

                // Check if user has communities (same logic as ContentView and LoginView)
                if let communities = profile.communities, !communities.isEmpty {
                    print("User has \(communities.count) communities, navigating to HomeView")
                    navigationState = .home(userProfile: profile)
                } else {
                    print("User has no communities, navigating to WelcomeView")
                    navigationState = .welcome(userProfile: profile)
                }
            } catch {
                print("Failed to load profile after signup:", error.localizedDescription)
                errorMessage = "Failed to load profile"
            }
        } else {
            print("Profile not created, navigating to ProfileView")
            navigationState = .profile
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
