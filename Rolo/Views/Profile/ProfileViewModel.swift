import SwiftUI
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isProfileCreated: UserProfile?
    @Published var selectedImage: UIImage?
    @Published var showingImagePicker = false
    @Published var showingCamera = false
    @Published var showingActionSheet = false

    private let userService: UserService
    private let fileService: FileService
    private let keychainManager: KeychainManager

    init(
        userService: UserService = .shared,
        fileService: FileService = .shared,
        keychainManager: KeychainManager = .shared
    ) {
        self.userService = userService
        self.fileService = fileService
        self.keychainManager = keychainManager
    }

    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty
    }

    func clearError() {
        errorMessage = ""
    }

    func createProfile(profileImage: UIImage?) {
        guard isFormValid else {
            errorMessage = "Please fill in all required fields"
            return
        }

        guard let token = keychainManager.getToken() else {
            print("Create profile error: Authentication token not found")
            errorMessage = "Authentication token not found"
            return
        }

        isLoading = true
        errorMessage = ""

        Task {
            print("Creating profile with name:", firstName, "lastName:", lastName, "phone:", phoneNumber)

            do {
                var imageUrl: String?

                if let profileImage = profileImage {
                    print("Uploading profile image")
                    let uploadResponse = try await fileService.uploadFile(token: token, image: profileImage)
                    imageUrl = uploadResponse.url
                    print("Image uploaded successfully, URL:", imageUrl ?? "")
                }

                print("Calling create profile API")
                _ = try await userService.createProfile(
                    token: token,
                    imageUrl: imageUrl,
                    name: firstName,
                    lastName: lastName,
                    phone: phoneNumber
                )

                print("Profile created successfully")
                do {
                    let userProfile = try await userService.getProfile(token: token)
                    await MainActor.run {
                        isLoading = false
                        isProfileCreated = userProfile
                    }
                } catch {
                    print("ProfileViewModel | Unable to get new Profile after creation")
                }
            } catch {
                await MainActor.run {
                    print("Create profile error:", error.localizedDescription)
                    isLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func goBack() {
        isProfileCreated = nil
    }

    func showImagePicker() {
        showingActionSheet = true
    }

    func selectCamera() {
        showingCamera = true
        showingActionSheet = false
    }

    func selectPhotoLibrary() {
        showingImagePicker = true
        showingActionSheet = false
    }

    func setSelectedImage(_ image: UIImage?) {
        selectedImage = image
    }
}
