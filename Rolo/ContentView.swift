
import SwiftUI

struct ContentView: View {
    @State private var currentView: AppView = .login
    @State private var userFirstName: String = "firstName"
    @State private var userProfileImage: UIImage? = nil
    @State private var isCheckingAuth = true

    enum AppView {
        case login
        case signup
        case profile
        case welcome
        case home
        case createCommunity
        case joinCommunity
        case getStarted
    }

    var body: some View {
        Group {
            if isCheckingAuth {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                switch currentView {
                case .login:
                    LoginView(
                        onNavigateToSignUp: {
                            currentView = .signup
                        },
                        onNavigateToCreateCommunity: {
                            currentView = .createCommunity
                        },
                        onNavigateToJoinCommunity: {
                            currentView = .joinCommunity
                        },
                        onNavigateToProfile: {
                            currentView = .profile
                        },
                        onNavigateToHome: { firstName, profileImage in
                            userFirstName = firstName
                            userProfileImage = profileImage
                            currentView = .home
                        },
                        onNavigateToWelcome: { firstName, profileImage in
                            userFirstName = firstName
                            userProfileImage = profileImage
                            currentView = .welcome
                        }
                    )
                case .signup:
                    SignUpView(
                        onNavigateToProfile: {
                            currentView = .profile
                        },
                        onNavigateToHome: { firstName, profileImage in
                            userFirstName = firstName
                            userProfileImage = profileImage
                            currentView = .home
                        },
                        onNavigateToWelcome: { firstName, profileImage in
                            userFirstName = firstName
                            userProfileImage = profileImage
                            currentView = .welcome
                        },
                        onNavigateBack: {
                            currentView = .login
                        }
                    )
                case .profile:
                    ProfileView(
                        onNavigateToHome: { firstName, profileImage in
                            userFirstName = firstName
                            userProfileImage = profileImage
                            currentView = .home
                        },
                        onNavigateBack: {
                            currentView = .signup
                        }
                    )
                case .welcome:
                    WelcomeView(
                        firstName: userFirstName,
                        profileImage: userProfileImage,
                        onNavigateToCreateCommunity: {
                            currentView = .createCommunity
                        },
                        onNavigateToJoinCommunity: {
                            currentView = .joinCommunity
                        },
                        onNavigateToLogin: {
                            currentView = .login
                        }
                    )
                case .home:
                    HomeView(onNavigateToLogin: {
                        currentView = .login
                    })
                case .createCommunity:
                    CreateCommunityView(
                        onNavigateBack: {
                            currentView = .home
                        },
                        onCommunityCreated: {
                            currentView = .getStarted
                        }
                    )
                case .joinCommunity:
                    JoinCommunityView(
                        onNavigateBack: {
                            currentView = .home
                        }
                    )
                case .getStarted:
                    GetStartedView(
                        firstName: userFirstName,
                        profileImage: userProfileImage,
                        onSkip: {
                            currentView = .home
                        },
                        onAddMembers: {

                        },
                        onConnectStripe: {

                        },
                        onIntegrateGoogleCalendar: {

                        }
                    )
                }
            }
        }
        .task {
            await checkAuthStatus()
        }
    }

    func checkAuthStatus() async {
        print("Checking auth status on app launch")
        guard let token = KeychainManager.shared.getToken() else {
            print("No token found in keychain")
            isCheckingAuth = false
            return
        }
    
        print("Token found in keychain, fetching profile")
        do {
            let profile = try await UserService.shared.getProfile(token: token)

            if profile.name == nil || profile.lastname == nil {
                print("Profile incomplete, navigating to ProfileView")
                currentView = .profile
            } else {
                print("Profile complete, checking communities")
                userFirstName = profile.name ?? "User"
                if let imageUrl = profile.image, let url = URL(string: imageUrl) {
                    print("Downloading profile image from:", imageUrl)
                    let (data, _) = try await URLSession.shared.data(from: url)
                    userProfileImage = UIImage(data: data)
                }
                
                // Check if user has communities
                if let communities = profile.communities, !communities.isEmpty {
                    print("User has \(communities.count) communities, navigating to HomeView")
                    currentView = .home
                } else {
                    print("User has no communities, navigating to WelcomeView")
                    currentView = .welcome
                }
            }
        } catch {
            print("Failed to fetch profile on launch:", error.localizedDescription)
            KeychainManager.shared.deleteToken()
        }

        isCheckingAuth = false
    }
}

#Preview {
    ContentView()
}
