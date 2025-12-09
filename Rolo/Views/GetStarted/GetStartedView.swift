import SwiftUI

struct GetStartedView: View {
    let firstName: String
    let profileImage: UIImage?
    let onSkip: () -> Void
    let onAddMembers: () -> Void
    let onConnectStripe: () -> Void
    let onIntegrateGoogleCalendar: () -> Void

    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection()
                Spacer()
                contentSection()
                actionsSection()
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }

    private func headerSection() -> some View {
        ZStack {
            Text("Get started")
                .font(.figtreeBold(size: 18))
                .foregroundColor(.headerColor)

            HStack {
                Spacer()
                Button("Skip") {
                    onSkip()
                }
                .font(.figtreeSemiBold(size: 18))
                .foregroundColor(.headerColor)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    private func contentSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("You're all set.")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.textPrimary)

            Text("Want to go further?")
                .font(.figtreeBold(size: 28))
                .foregroundColor(.highlightGreen)

            Text("Connect tools and add members now for a smoother, smarter experience. Or skip and do it later.")
                .font(.figtree(size: 16))
                .foregroundColor(.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 48)
    }

    private func actionsSection() -> some View {
        VStack(spacing: 16) {
            ActionButton(
                title: "Add members",
                isLoading: false,
                isDisabled: false,
                backgroundColor: Color.googleButtonBackground,
                textColor: .textPrimary,
                borderColor: Color.secondaryGreen
            ) {
                onAddMembers()
            }

            StripeButton(title: "Connect to") {
                onConnectStripe()
            }

            ActionButton(
                title: "Integrate with Google Calendar",
                isLoading: false,
                isDisabled: false,
                backgroundColor: Color.googleButtonBackground,
                textColor: .textPrimary,
                borderColor: Color.secondaryGreen
            ) {
                onIntegrateGoogleCalendar()
            }
        }
    }
}

#Preview {
    GetStartedView(
        firstName: "John",
        profileImage: nil,
        onSkip: {},
        onAddMembers: {},
        onConnectStripe: {},
        onIntegrateGoogleCalendar: {}
    )
}
