import Foundation

struct AgendaItem: Identifiable {
    let id = UUID()
    let name: String
    let eventDescription: String
    let priority: String
    let avatarImage: String?
    let isPinned: Bool
}

class DashboardViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var communityName = "Yorkville Jewish Centre"
    @Published var hasNotification = true
    @Published var agendaItems: [AgendaItem] = []
    
    init() {
        loadMockData()
    }
    
    func loadDashboardData() {
        isLoading = true
        errorMessage = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
    
    func loadMockData() {
        agendaItems = [
            AgendaItem(
                name: "James H.",
                eventDescription: "In 7 days is James Birthday",
                priority: "High priority",
                avatarImage: "https://randomuser.me/api/portraits/men/1.jpg",
                isPinned: true
            ),
            AgendaItem(
                name: "Sarah M.",
                eventDescription: "Birthday",
                priority: "High priority",
                avatarImage: "https://randomuser.me/api/portraits/women/1.jpg",
                isPinned: true
            ),
            AgendaItem(
                name: "Michael R.",
                eventDescription: "Birthday",
                priority: "High priority",
                avatarImage: "https://randomuser.me/api/portraits/men/2.jpg",
                isPinned: true
            ),
            AgendaItem(
                name: "Emma L.",
                eventDescription: "Birthday",
                priority: "High priority",
                avatarImage: "https://randomuser.me/api/portraits/women/2.jpg",
                isPinned: true
            )
        ]
    }
    
    func addMember() {
        print("Add member tapped")
    }
    
    func addTodo() {
        print("Add todo tapped")
    }
    
    func createEvent() {
        print("Create event tapped")
    }
    
    func requestDonation() {
        print("Request donation tapped")
    }
    
    func refresh() {
        loadDashboardData()
    }
    
    func filterAgenda() {
        print("Filter agenda tapped")
    }
    
    func sortAgenda() {
        print("Sort agenda tapped")
    }
}
