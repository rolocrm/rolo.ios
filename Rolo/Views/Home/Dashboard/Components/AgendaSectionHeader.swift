import SwiftUI

struct AgendaSectionHeader: View {
    let title: String
    let onFilter: () -> Void
    let onSort: () -> Void
    
    var body: some View {
        HStack {
            titleSection()
            Spacer()
            actionButtonsSection()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
    
    private func titleSection() -> some View {
        HStack(spacing: 0) {
            Text("Today's")
                .font(.figtreeMedium(size: 18))
                .foregroundColor(.highlightGreen)
                .underline(true, color: .highlightGreen)
            
            Text(" Agenda")
                .font(.figtreeMedium(size: 18))
                .foregroundColor(.textSecondary)
        }
    }
    
    private func actionButtonsSection() -> some View {
        HStack(spacing: 0) {
            filterButtonSection()
            sortButtonSection()
        }
    }
    
    private func filterButtonSection() -> some View {
        Button(action: onFilter) {
            Image("Filter")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
        }
    }
    
    private func sortButtonSection() -> some View {
        Button(action: onSort) {
            Image("ArrowDown 1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
        }
    }
}

#Preview {
    VStack {
        AgendaSectionHeader(
            title: "Today's agenda",
            onFilter: {},
            onSort: {}
        )
        
        Spacer()
    }
    .background(Color.primaryBackground)
}
