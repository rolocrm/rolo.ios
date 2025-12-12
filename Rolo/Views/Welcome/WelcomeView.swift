import SwiftUI
import SwiftData

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @Bindable var user: UserProfile

    let onNavigateToCreateCommunity: () -> Void
    let onNavigateToJoinCommunity: () -> Void
    let onNavigateToLogin: () -> Void

    var uiImage: UIImage? {
        guard let imageData = user.imageData else { return nil }
        return UIImage(data: imageData)
    }

    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                headerSection()
                Spacer()

                greetingSection()
                primaryActionsSection()

//                deleteAccountSection()

                Spacer()
            }
            .padding(.horizontal, 20)
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

#Preview {
    // Create a lightweight preview user
    let previewUser = UserProfile(id: UUID().uuidString, email: "testemail", name: "testName", lastname: "testLastname", phone: "+1111", imageStringURL: nil, uiImage: nil, type: nil, createdAt: nil, communities: nil, collaborators: nil)
    WelcomeView(
        user: previewUser,
        onNavigateToCreateCommunity: {},
        onNavigateToJoinCommunity: {},
        onNavigateToLogin: {}
    )
}

private extension WelcomeView {
    func headerSection() -> some View {
        ZStack {
            Text("Welcome")
                .font(.figtreeBold(size: 18))
                .foregroundColor(.headerColor)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            Group {
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image("Default")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .onTapGesture {
                            onNavigateToLogin()
                        }
                }
            }
        }
        .padding(.top, 16)
    }
    
    func greetingSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Welcome \(user.name ?? "")!")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.textPrimary)
            Text("Before you can manage members, events, or donations, you’ll need to join or create your community.")
                .font(.figtree(size: 16))
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 48)
    }
    
    func primaryActionsSection() -> some View {
        VStack(spacing: 16) {
            ActionButton(
                title: "Create a community",
                isLoading: false,
                isDisabled: false,
                backgroundColor: Color.secondaryGreen,
                textColor: Color.highlightGreen,
                borderColor: Color.secondaryGreen
            ) {
                onNavigateToCreateCommunity()
            }
            ActionButton(
                title: "Join a community",
                isLoading: false,
                isDisabled: false,
                backgroundColor: Color.googleButtonBackground,
                textColor: .textPrimary,
                borderColor: Color.secondaryGreen
            ) {
                onNavigateToJoinCommunity()
            }
        }
    }

    func deleteAccountSection() -> some View {
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
        .padding(.top, 16)
    }

}
