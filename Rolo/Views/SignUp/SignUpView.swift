import SwiftUI

struct SignUpView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = SignUpViewModel()
    let onNavigateToProfile: () -> Void
    let onNavigateToHome: () -> Void
    let onNavigateToWelcome: () -> Void
    let onNavigateBack: () -> Void

    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection()
                Spacer()

                welcomeSection()
                errorSection()
                formSection()
                signUpButtonSection()
                googleSignUpButtonSection()

                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onChange(of: viewModel.navigationState) { state in
            if case .profile = state {
                onNavigateToProfile()
            } else if case .home(let userProfile) = state {
                modelContext.insert(userProfile)
                do {
                    try modelContext.save()
                } catch {
                    print("SwiftData save error:", error)
                }
                onNavigateToHome()
            } else if case .welcome(let userProfile) = state {
                modelContext.insert(userProfile)
                do {
                    try modelContext.save()
                } catch {
                    print("SwiftData save error:", error)
                }
                onNavigateToWelcome()
            }
        }
    }
    
    private func headerSection() -> some View {
        HStack {
            Button("Back") {
                onNavigateBack()
            }
            .font(.figtreeSemiBold(size: 18))
            .foregroundColor(Color.headerColor)
            Spacer()
            
            Text("Create account")
                .font(.figtreeBold(size: 18))
                .foregroundColor(Color.headerColor)
            
            Spacer()
            
          
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
    
    private func welcomeSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome to Rolo!")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.textPrimary)
            
            Text("Create your account to connect, organize, and grow your community.")
                .font(.custom("Figtree", size: 18))
                .foregroundColor(Color.greyColor)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 48)
    }
    
    private func errorSection() -> some View {
        ErrorMessage(message: viewModel.errorMessage)
    }
    
    private func formSection() -> some View {
        FormContainer(hasError: !viewModel.errorMessage.isEmpty) {
            VStack(spacing: 12) {
                TextFieldWithLabel(
                    label: "Email",
                    placeholder: "Email",
                    text: $viewModel.email,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                PasswordFieldWithLabel(
                    label: "Password",
                    placeholder: "Password",
                    text: $viewModel.password,
                    showPassword: $viewModel.showPassword,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                PasswordFieldWithLabel(
                    label: "Confirm Password",
                    placeholder: "Confirm Password",
                    text: $viewModel.confirmPassword,
                    showPassword: $viewModel.showConfirmPassword,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
            }
        }
        .padding(.bottom, 48)
    }
    
    private func signUpButtonSection() -> some View {
        ActionButton(
            title: "Sign up",
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid,
            action: {
                viewModel.signUp()
            }
        )
        .padding(.bottom, 16)
    }
    
    private func googleSignUpButtonSection() -> some View {
        GoogleButton(title: "Sign up with Google", isLoading: viewModel.isGoogleLoading) {
            viewModel.signUpWithGoogle()
        }
        .padding(.bottom, 32)
    }
 
}

//#Preview {
//    SignUpView(
//        onNavigateToProfile: {}, 
//        onNavigateToHome: { _, _ in }, 
//        onNavigateToWelcome: { _, _ in },
//        onNavigateBack: {}
//    )
//}
