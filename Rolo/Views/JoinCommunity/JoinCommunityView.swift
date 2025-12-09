import SwiftUI

struct JoinCommunityView: View {
    @StateObject private var viewModel = JoinCommunityViewModel()
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
                requestToJoinButton()
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

            Text("Join")
                .font(.figtreeBold(size: 18))
                .foregroundColor(.headerColor)

            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    private func contentSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Join a Community.")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.textPrimary)
                .padding(.bottom, 16)

            Text("Enter your community's unique handle to request access. Don't know your community's handle? Ask your admin or rabbi.")
                .font(.figtree(size: 16))
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 32)

            ErrorMessage(message: viewModel.errorMessage)

            communityHandleField()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func communityHandleField() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.communityHandle.isEmpty {
                Text("Community handle")
                    .font(.custom("Figtree", size: 15))
                    .foregroundColor(.textSecondary)
                    .frame(height: 20)
                    .padding(.leading, 20)
            }

            TextField("Community handle", text: $viewModel.communityHandle, prompt: Text("Community handle").foregroundColor(Color.greyColor))
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.textPrimary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: viewModel.communityHandle.isEmpty ? 48 : 28)
                .padding(.horizontal, 20)
                .onChange(of: viewModel.communityHandle) { _ in
                    viewModel.clearError()
                }
        }
        .padding(.vertical, 12)
        .background(Color.secondaryGreen)
        .cornerRadius(8)
    }

    private func requestToJoinButton() -> some View {
        ActionButton(
            title: "Request to join",
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid,
            action: {
                viewModel.requestToJoin()
            }
        )
        .padding(.bottom, 32)
    }
}

#Preview {
    JoinCommunityView(onNavigateBack: {})
}
