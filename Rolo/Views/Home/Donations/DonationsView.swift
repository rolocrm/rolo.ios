import SwiftUI

struct DonationsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Donations")
                    .font(.figtreeBold(size: 24))
                    .foregroundColor(.textPrimary)
                
                Text("Track and manage donations")
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
    DonationsView()
}

