import SwiftUI

struct DashboardHeader: View {
    let communityName: String
    let hasNotification: Bool
    let onAddMember: () -> Void
    let onAddTodo: () -> Void
    let onCreateEvent: () -> Void
    let onRequestDonation: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            titleSection()
            actionButtonsSection()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private func titleSection() -> some View {
        HStack {
            Text(communityName)
                .font(.custom("EB Garamond", size: 28))
                .fontWeight(.medium)
                .foregroundColor(.primaryBackground)
            
            Spacer()
            
            notificationButtonSection()
        }
    }
    
    private func notificationButtonSection() -> some View {
        Button(action: {}) {
            ZStack {
                Image(systemName: "bell")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primaryBackground)
                
                if hasNotification {
                    Circle()
                        .fill(Color.highlightGreen)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
    
    private func actionButtonsSection() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                DashboardActionButton(
                    icon: "AddMember",
                    text: "Add Member",
                    onTap: onAddMember
                )
                
                DashboardActionButton(
                    icon: "AddTodo",
                    text: "Add Todo",
                    onTap: onAddTodo
                )
                
                DashboardActionButton(
                    icon: "CreateEvent",
                    text: "Create Event",
                    onTap: onCreateEvent
                )
                
                DashboardActionButton(
                    icon: "RequestDonation",
                    text: "Request Donation",
                    onTap: onRequestDonation
                )
            }
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    VStack {
        DashboardHeader(
            communityName: "Yorkville Jewish Centre",
            hasNotification: true,
            onAddMember: {},
            onAddTodo: {},
            onCreateEvent: {},
            onRequestDonation: {}
        )
        
        Spacer()
    }
    .background(Color.white)
}
