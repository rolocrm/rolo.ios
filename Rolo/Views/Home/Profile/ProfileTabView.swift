import SwiftUI

struct ProfileTabView: View {
    @StateObject private var viewModel = ProfileTabViewModel()
    let onNavigateToLogin: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                profileHeaderSection()
                actionButtonsSection()
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBackground)
        }
        .alert("Delete Account", isPresented: $viewModel.showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount()
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        .onChange(of: viewModel.accountDeleted) { deleted in
            if deleted {
                onNavigateToLogin()
            }
        }
    }
}

private extension ProfileTabView {
    func profileHeaderSection() -> some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.figtreeBold(size: 24))
                .foregroundColor(.textPrimary)
            
            Text("Manage your profile settings")
                .font(.figtree(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    func actionButtonsSection() -> some View {
        VStack(spacing: 16) {
            logoutButton()
            deleteAccountButton()
        }
    }
    
    func logoutButton() -> some View {
        ActionButton(
            title: "Logout",
            isLoading: viewModel.isLoggingOut,
            isDisabled: viewModel.isLoggingOut,
            backgroundColor: Color.secondaryGreen,
            textColor: Color.highlightGreen,
            borderColor: Color.secondaryGreen
        ) {
            viewModel.logout()
        }
    }
    
    func deleteAccountButton() -> some View {
        ActionButton(
            title: "Delete Account",
            isLoading: viewModel.isDeleting,
            isDisabled: viewModel.isDeleting,
            backgroundColor: Color.secondaryGreen,
            textColor: .red,
            borderColor: Color.secondaryGreen
        ) {
            viewModel.showDeleteConfirmation = true
        }
    }
}

#Preview {
    ProfileTabView(onNavigateToLogin: {})
}
