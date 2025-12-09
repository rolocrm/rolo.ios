import SwiftUI

struct MembersView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Members")
                    .font(.figtreeBold(size: 24))
                    .foregroundColor(.textPrimary)
                
                Text("Manage your community members")
                    .font(.figtree(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBackground)
        }
    }
}

#Preview {
    MembersView()
}

