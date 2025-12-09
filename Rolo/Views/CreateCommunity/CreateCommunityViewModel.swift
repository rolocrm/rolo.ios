import SwiftUI
import UIKit

struct Collaborator: Identifiable {
    let id = UUID()
    var name: String = ""
    var email: String = ""
    var role: String = ""

    var isValid: Bool {
        return !name.isEmpty && !email.isEmpty && !role.isEmpty
    }
}

class CreateCommunityViewModel: ObservableObject {
    @Published var communityName = ""
    @Published var handle = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var taxId = ""
    @Published var country = ""
    @Published var address = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""
    @Published var selectedLogo: UIImage?
    @Published var collaborators: [Collaborator] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isCommunityCreated = false
    @Published var showImagePicker = false
    @Published var isHandleValidating = false
    @Published var handleValidationMessage = ""
    @Published var handleFormatValid = false
    @Published var availableRoles: [String] = []
    @Published var isLoadingRoles = false
    private var rolesLoaded = false
    @Published var logoUrl: String?
    private var handleValidationTask: Task<Void, Never>?

    let countryOptions = [
        "United States", "Canada", "United Kingdom", "Australia", "Germany",
        "France", "Spain", "Italy", "Japan", "China", "India", "Brazil",
        "Mexico", "South Africa", "Netherlands", "Sweden", "Switzerland"
    ]

    init() {
        loadRoles()
    }

    var isFormValid: Bool {
        return isMainFormValid && areCollaboratorsValid
    }

    var isMainFormValid: Bool {
        return !communityName.isEmpty &&
               !handle.isEmpty &&
               handleFormatValid &&
               !email.isEmpty &&
               !phoneNumber.isEmpty &&
               !country.isEmpty &&
               !address.isEmpty &&
               !city.isEmpty &&
               !state.isEmpty &&
               !zipCode.isEmpty
    }

    var areCollaboratorsValid: Bool {
        if collaborators.isEmpty {
            return true
        }
        return collaborators.allSatisfy { $0.isValid }
    }

    func clearError() {
        errorMessage = ""
    }

    func createCommunity() {
        guard isMainFormValid else {
            errorMessage = "Please fill in all required community fields"
            return
        }

        guard areCollaboratorsValid else {
            errorMessage = "Please fill in all collaborator fields or remove incomplete collaborators"
            return
        }

        isLoading = true
        errorMessage = ""

        Task {
            do {
                guard let token = KeychainManager.shared.getToken() else {
                    await MainActor.run {
                        self.errorMessage = "Authentication required"
                        self.isLoading = false
                    }
                    return
                }

                let request = CreateCommunityRequest(
                    logo: logoUrl,
                    handle: handle,
                    name: communityName,
                    email: email,
                    phone: phoneNumber,
                    tax_id: taxId.isEmpty ? nil : taxId,
                    country: country,
                    address: address,
                    city: city,
                    stat: state,
                    zip_code: zipCode
                )

                let response = try await CommunityService.shared.createCommunity(token: token, request: request)
                print("Create community response received:", response)
                
                print("Number of collaborators:", collaborators.count)
                for (index, collaborator) in collaborators.enumerated() {
                    print("Processing collaborator \(index):", collaborator.name, collaborator.email, collaborator.role, "isValid:", collaborator.isValid)
                    if collaborator.isValid {
                        let collaboratorRequest = AddCollaboratorRequest(
                            handle: handle,
                            email: collaborator.email,
                            name: collaborator.name,
                            role: collaborator.role
                        )
                        print("Adding collaborator:", collaboratorRequest)
                        let collaboratorResponse = try await CommunityService.shared.addCollaborator(token: token, request: collaboratorRequest)
                        print("Collaborator added successfully:", collaboratorResponse)
                    } else {
                        print("Skipping invalid collaborator:", collaborator)
                    }
                }
                
                await MainActor.run {
                    self.isLoading = false
                    self.isCommunityCreated = true
                }
            } catch {
                print("Create community error:", error)
                await MainActor.run {
                    self.errorMessage = "Failed to create community: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }

    func addCollaborator() {
        collaborators.append(Collaborator())
    }

    func removeCollaborator(at index: Int) {
        guard index < collaborators.count else { return }
        collaborators.remove(at: index)
    }

    func updateCollaboratorName(at index: Int, name: String) {
        guard index < collaborators.count else { return }
        collaborators[index].name = name
        clearError()
    }

    func updateCollaboratorEmail(at index: Int, email: String) {
        guard index < collaborators.count else { return }
        collaborators[index].email = email
        clearError()
    }

    func updateCollaboratorRole(at index: Int, role: String) {
        guard index < collaborators.count else { return }
        collaborators[index].role = role
        clearError()
    }

    func selectLogo(_ image: UIImage?) {
        selectedLogo = image
    }

    func generateNewHandle() {
        let randomSuffix = String(Int.random(in: 1000...9999))
        handle = "handle\(randomSuffix)"
        validateHandle()
    }
    
    func validateHandleFormat() -> Bool {
        let trimmedHandle = handle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedHandle.count >= 4 else {
            return false
        }
        
        guard !trimmedHandle.contains(" ") else {
            return false
        }
        
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        guard trimmedHandle.rangeOfCharacter(from: allowedCharacters.inverted) == nil else {
            return false
        }
        
        return true
    }
    
    func validateHandle() {
        handleValidationTask?.cancel()
        
        let isFormatValid = validateHandleFormat()
        handleFormatValid = isFormatValid
        
        if handle.isEmpty {
            handleValidationMessage = ""
            return
        }
        
        if !isFormatValid {
            handleValidationMessage = "Handle must be 4+ characters. No spaces or special characters allowed."
            return
        }
        
        handleValidationTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if !Task.isCancelled {
                await MainActor.run {
                    self.checkHandleAvailability()
                }
            }
        }
    }
    
    private func checkHandleAvailability() {
        isHandleValidating = true
        handleValidationMessage = ""
        
        Task {
            do {
                guard let token = KeychainManager.shared.getToken() else {
                    await MainActor.run {
                        self.handleValidationMessage = "Authentication required"
                        self.isHandleValidating = false
                    }
                    return
                }
                
                let response = try await CommunityService.shared.checkHandle(token: token, handle: handle)
                
                await MainActor.run {
                    self.isHandleValidating = false
                    if response.exists {
                        self.handleValidationMessage = "Handle is not available"
                    } else {
                        self.handleValidationMessage = "Handle is available"
                    }
                }
            } catch {
                await MainActor.run {
                    self.handleValidationMessage = "Error checking handle availability"
                    self.isHandleValidating = false
                }
            }
        }
    }
    
    func loadRoles() {
        guard !rolesLoaded else { return }
        
        Task {
            await MainActor.run {
                self.isLoadingRoles = true
            }
            
            do {
                guard let token = KeychainManager.shared.getToken() else {
                    await MainActor.run {
                        self.errorMessage = "Authentication required"
                    }
                    return
                }
                print("Token:", token)

                let response = try await CommunityService.shared.getRoles(token: token)
                
                await MainActor.run {
                    self.availableRoles = response.roles
                    self.isLoadingRoles = false
                    self.rolesLoaded = true
                }
            } 
        }
    }
    
    func uploadLogo() {
        guard let logo = selectedLogo else { return }
        
        Task {
            do {
                guard let token = KeychainManager.shared.getToken() else {
                    await MainActor.run {
                        self.errorMessage = "Authentication required"
                    }
                    return
                }
                
                let response = try await FileService.shared.uploadFile(token: token, image: logo)
                
                await MainActor.run {
                    self.logoUrl = response.url
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to upload logo: \(error.localizedDescription)"
                }
            }
        }
    }
}
