import SwiftUI
import SwiftData

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
//    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserProfile.id) private var users: [UserProfile]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerSection
                agendaSection
                agendaListSection
            }
            .background(Color.white)
        }
        .onAppear {
            viewModel.loadDashboardData()
        }
    }
    
    private var headerSection: some View {
        DashboardHeader(
            communityName: viewModel.communityName,
            hasNotification: viewModel.hasNotification,
            onAddMember: viewModel.addMember,
            onAddTodo: viewModel.addTodo,
            onCreateEvent: viewModel.createEvent,
            onRequestDonation: viewModel.requestDonation
        )
    }
    
    private var agendaSection: some View {
        AgendaSectionHeader(
            title: "Today's agenda",
            onFilter: viewModel.filterAgenda,
            onSort: viewModel.sortAgenda
        )
    }
    
    private var agendaListSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.agendaItems) { item in
                    AgendaCard(
                        name: item.name,
                        eventDescription: item.eventDescription,
                        priority: item.priority,
                        avatarImage: item.avatarImage,
                        isPinned: item.isPinned
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            Text("users count= \(users.count)")
            if let user = users.first {
                Text("user= \(user)")
            }
        }
    }
}

#Preview {
    DashboardView()
}
