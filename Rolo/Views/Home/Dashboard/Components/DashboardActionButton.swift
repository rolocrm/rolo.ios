import SwiftUI

struct DashboardActionButton: View {
    let icon: String
    let text: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            buttonContentSection()
        }
    }
    
    private func buttonContentSection() -> some View {
        HStack(spacing: 12) {
            textSection()
            iconSection()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 11)
        .background(Color.buttonBackground)
        .cornerRadius(100)
    }
    
    private func textSection() -> some View {
        Text(text)
            .font(.figtreeMedium(size: 14))
            .foregroundColor(.highlightGreen)
    }
    
    private func iconSection() -> some View {
        Image(icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
    }
}

#Preview {
    HStack(spacing: 12) {
        DashboardActionButton(
            icon: "Add Member",
            text: "Add Member",
            onTap: {}
        )
        
        DashboardActionButton(
            icon: "Add Todo",
            text: "Add Todo",
            onTap: {}
        )
    }
    .padding()
    .background(Color.white)
}
