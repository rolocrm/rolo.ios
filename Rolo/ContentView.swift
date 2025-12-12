
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentView: AppView = .login
//    @State private var userFirstName: String = "firstName"
//    @State private var userProfileImage: UIImage? = nil
    @State private var isCheckingAuth = true

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserProfile.id) private var users: [UserProfile]

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
//        VStack {
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
                                onNavigateToProfile: {
                                    currentView = .profile
                                },
                                onNavigateToHome: {
                                    currentView = .home
                                },
                                onNavigateToWelcome: {
                                    currentView = .welcome
                                }
                            )
                        case .signup:
                            SignUpView(
                                onNavigateToProfile: {
                                    currentView = .profile
                                },
                                onNavigateToHome: {
                                    currentView = .home
                                },
                                onNavigateToWelcome: {
                                    currentView = .welcome
                                },
                                onNavigateBack: {
                                    currentView = .login
                                }
                            )

                        case .profile:
                            ProfileView(
                                onNavigateToWelcome: {
                                    currentView = .welcome
                                },
                                onNavigateBack: {
                                    currentView = .signup
                                }
                            )


                        case .welcome:
                            if let user = users.first {
                                WelcomeView(
                                    user: user,
                                    onNavigateToCreateCommunity: {
                                        currentView = .createCommunity
                                    },
                                    onNavigateToJoinCommunity: {
                                        currentView = .joinCommunity
                                    },
                                    onNavigateToLogin: {
                                        currentView = .profile
                                    }
                                )
                            }
                        case .createCommunity:
                            if let user = users.first {
                                CreateCommunityView(
                                    user: user,
                                    onNavigateBack: {
                                        currentView = .welcome
                                    },
                                    onCommunityCreated: {
                                        currentView = .getStarted
                                    }
                                )
                            }

                        case .home:
                            HomeView(onNavigateToLogin: {
                                currentView = .login
                            })
                        default:
                            VStack {
                                Text("currentView= \(currentView)")
                                if let user = users.first {
                                    Text("user= \(user)")
                                }
                            }

                            //                case .joinCommunity:
                            //                    JoinCommunityView(
                            //                        onNavigateBack: {
                            //                            currentView = .home
                            //                        }
                            //                    )
                            //                case .getStarted:
                            //                    GetStartedView(
                            //                        firstName: userFirstName,
                            //                        profileImage: userProfileImage,
                            //                        onSkip: {
                            //                            currentView = .home
                            //                        },
                            //                        onAddMembers: {
                            //
                            //                        },
                            //                        onConnectStripe: {
                            //
                            //                        },
                            //                        onIntegrateGoogleCalendar: {
                            //
                            //                        }
                            //                    )
                    }
                }
            }
            .task {
                await checkAuthStatus()
            }
//        }
    }

    func checkAuthStatus() async {
        print("Checking auth status on app launch")
        guard let token = KeychainManager.shared.getToken() else {
            print("No token found in keychain")
            isCheckingAuth = false
            return
        }

        print("Token found in keychain, fetching profile")

        var profile: UserProfile?
        do {
            let profileTemp = try await UserService.shared.getProfile(token: token)
            profile = profileTemp
            modelContext.insert(profileTemp)
            do {
                try modelContext.save()
            } catch {
                print("SwiftData save error:", error)
            }
        } catch {
            if let user = users.first {
                profile = user
            }
        }

        guard let profile else {
            print("No Users found")
            isCheckingAuth = false
            KeychainManager.shared.deleteToken()
            return
        }

        do {
            print("ContentView() | Profile | profile= \(profile)")

            if profile.name == nil || profile.lastname == nil {
                print("Profile incomplete, navigating to ProfileView")
                currentView = .profile
            } else {
                print("Profile complete, checking communities")
                if let imageStringURL = profile.imageStringURL,
                   let url = URL(string: imageStringURL) {
                    print("Downloading profile image from:", imageStringURL)
                    let (data, _) = try await URLSession.shared.data(from: url)
                    profile.imageData = data
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
            // Delete user form SwiftUI
        }

        isCheckingAuth = false
    }
}

#Preview {
    ContentView()
}
