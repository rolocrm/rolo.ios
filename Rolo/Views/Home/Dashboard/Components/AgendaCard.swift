import SwiftUI

struct AgendaCard: View {
    let name: String
    let eventDescription: String
    let priority: String
    let avatarImage: String?
    let isPinned: Bool
    
    var body: some View {
        VStack(spacing: 58) {
            topRowSection()
            contentAndPrioritySection()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .background(Color.primaryBackground)
        .cornerRadius(26)
    }
    
    private func topRowSection() -> some View {
        HStack(spacing: 12) {
            avatarSection()
            
            Text(name)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.white)
            
            Spacer()
            
            if isPinned {
                pinIconSection()
            }
        }
    }
    
    private func contentAndPrioritySection() -> some View {
        HStack {
            Text(eventDescription)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.highlightGreen)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Text(priority)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.errorRed)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.errorRed.opacity(0.15))
                .cornerRadius(40)
        }
    }
    
    private func pinIconSection() -> some View {
        Image("Pin")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 28)
    }
    
    private func avatarSection() -> some View {
        Group {
            if let avatarImage = avatarImage,
               let url = URL(string: avatarImage) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.4))
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 48, height: 48)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AgendaCard(
            name: "James H.",
            eventDescription: "In 7 days is James Birthday",
            priority: "High priority",
            avatarImage: nil,
            isPinned: true
        )
    }
    .padding()
    .background(Color.black)
}
