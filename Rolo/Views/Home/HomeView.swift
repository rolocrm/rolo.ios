import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    let onNavigateToLogin: () -> Void
    
    init(onNavigateToLogin: @escaping () -> Void = {}) {
        self.onNavigateToLogin = onNavigateToLogin
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(selectedTab == 0 ? UIConstants.ImageNames.TabBar.dashboardSelected : UIConstants.ImageNames.TabBar.dashboard)
                        .renderingMode(.original)
                    Text("Dashboard")
                }
                .tag(0)
            
            MembersView()
                .tabItem {
                    Image(selectedTab == 1 ? UIConstants.ImageNames.TabBar.membersSelected : UIConstants.ImageNames.TabBar.members)
                        .renderingMode(.original)
                    Text("Members")
                }
                .tag(1)
            
            DonationsView()
                .tabItem {
                    Image(selectedTab == 2 ? UIConstants.ImageNames.TabBar.donationsSelected : UIConstants.ImageNames.TabBar.donations)
                        .renderingMode(.original)
                    Text("Donations")
                }
                .tag(2)
            
            ProfileTabView(onNavigateToLogin: onNavigateToLogin)
                .tabItem {
                    Image(systemName: "person.circle")
                        .renderingMode(.template)
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Color.primaryGreen)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.unselectedTabColor)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.unselectedTabColor),
            .font: UIFont(name: "Figtree-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryGreen)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryGreen),
            .font: UIFont(name: "Figtree-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}


#Preview {
    HomeView(onNavigateToLogin: {})
}
