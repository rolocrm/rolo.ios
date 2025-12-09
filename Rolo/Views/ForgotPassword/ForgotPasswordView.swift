import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    let onNavigateBack: () -> Void

    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection()
                Spacer()
                contentSection()
                Spacer()
                sendResetLinkButton()
            }
            .padding(.horizontal, 20)
        }
    }

    private func headerSection() -> some View {
        HStack {
            Button("Back") {
                onNavigateBack()
            }
            .font(.figtreeSemiBold(size: 18))
            .foregroundColor(.headerColor)

            Spacer()

            Text("Forgot password")
                .font(.figtreeBold(size: 18))
                .foregroundColor(.headerColor)

            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    private func contentSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Oops, locked out?")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.textPrimary)
                .padding(.bottom, 16)

            Text("No worries, it happens. Enter your email address and we'll send you a link to reset your password.")
                .font(.figtree(size: 16))
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 32)

            ErrorMessage(message: viewModel.errorMessage)

            emailField()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func emailField() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.email.isEmpty {
                Text("Email")
                    .font(.custom("Figtree", size: 15))
                    .foregroundColor(.textSecondary)
                    .frame(height: 20)
                    .padding(.leading, 20)
            }

            TextField("Email", text: $viewModel.email, prompt: Text("Email").foregroundColor(Color.greyColor))
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.textPrimary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .frame(height: viewModel.email.isEmpty ? 48 : 28)
                .padding(.horizontal, 20)
                .onChange(of: viewModel.email) { _ in
                    viewModel.clearError()
                }
        }
        .padding(.vertical, 12)
        .background(Color.secondaryGreen)
        .cornerRadius(8)
    }

    private func sendResetLinkButton() -> some View {
        ActionButton(
            title: "Send reset link",
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid,
            action: {
                viewModel.sendResetLink()
            }
        )
        .padding(.bottom, 32)
    }
}

#Preview {
    ForgotPasswordView(onNavigateBack: {})
}
