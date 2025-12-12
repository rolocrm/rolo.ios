

import SwiftUI

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = LoginViewModel()
    @State private var showForgotPassword = false
    let onNavigateToSignUp: () -> Void
    let onNavigateToProfile: () -> Void
    let onNavigateToHome: () -> Void
    let onNavigateToWelcome: () -> Void

    var body: some View {
        Group {
            if showForgotPassword {
                ForgotPasswordView(onNavigateBack: {
                    showForgotPassword = false
                })
            } else {
                ZStack {
                    Color.primaryBackground
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        Spacer()

                        logoSection()
                        errorSection()
                        formSection()
                        forgotPasswordSection()
                        loginButtonSection()
                        googleLoginButtonSection()
                        signupSection()

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onChange(of: viewModel.navigationState) { state in
            if state == .profile {
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
    
    private func logoSection() -> some View {
        VStack(spacing: 23) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 68, height: 68)
            
            Text("Rolo")
                .font(.figtreeBold(size: 34))
                .foregroundColor(.textPrimary)
        }
        .padding(.bottom, 40)
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
                    .frame(height: 0.5)
                
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
            }
        }
        .padding(.bottom, 16)
    }
    
    private func forgotPasswordSection() -> some View {
        HStack {
            Spacer()
            Button("Forgot password?") {
                showForgotPassword = true
            }
            .font(.custom("Figtree", size: 14))
            .foregroundColor(.textSecondary)
            .underline(true, color: .textSecondary)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.textSecondary)
                    .offset(y: 8)
            )
        }
        .padding(.bottom, 20)
    }
    
    private func loginButtonSection() -> some View {
        ActionButton(
            title: "Log in",
            isLoading: viewModel.isLoading,
            isDisabled: viewModel.email.isEmpty || viewModel.password.isEmpty,
            action: {
                print("Login pressed - email: \(viewModel.email), password: \(viewModel.password)")
                viewModel.login()
            }
        )
        .padding(.bottom, 16)
    }
    
    private func googleLoginButtonSection() -> some View {
        GoogleButton(title: "Log in with Google", isLoading: viewModel.isGoogleLoading) {
            viewModel.loginWithGoogle()
        }
        .padding(.bottom, 32)
    }
    
    private func signupSection() -> some View {
        HStack(spacing: 4) {
            Text("Not a member?")
                .font(.custom("Figtree", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color.highlightGreen)
            
            Button("Sign up") {
                onNavigateToSignUp()
            }
            .font(.custom("Figtree", size: 16))
            .fontWeight(.semibold)
            .foregroundColor(Color.highlightGreen)
            .underline(true, color: Color.highlightGreen)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.highlightGreen)
                    .offset(y: 8)
            )
        }
    }
}




