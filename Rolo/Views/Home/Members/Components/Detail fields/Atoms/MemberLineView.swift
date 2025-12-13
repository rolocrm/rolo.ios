//
//  MemberLineView.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/10/25.
//

import SwiftUI

struct MemberLineView: View {
    var member: Member

    var body: some View {
        HStack(spacing: 8) {
            avatarView()

            Text("\(member.name) \(member.surname)")
                .font(.figtree(size: 14))
                .foregroundColor(Color.neutralBlack)

            Spacer()

            if member.monthDonation != 0 {
                donationMarkerView()
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.neutralMediumGray)
        }
        .frame(height: 72)
        .padding(.horizontal, 16)
    }

    private func donationMarkerView() -> some View {
        HStack(spacing: 4) {
            Image("crown")
                .font(.system(size: 12, weight: .regular))
//                .foregroundColor(.neutralMediumGray)
                .padding(.vertical, 8)

            Text("$\(member.monthDonation.description)")
                .font(.figtree(size: 14))
                .foregroundColor(Color.highlightGreen)
        }
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.buttonBackground)
        )
    }

    private func avatarView() -> some View {
        Group {
            if let avatar = member.avatar {
                Text("T")
            } else {
                ZStack {
                    Circle()
                        .fill(Color.brandSecondary)
                        .frame(width: 40, height: 40)

                    Text(member.initials)
                        .font(.figtree(size: 14))
                        .foregroundColor(Color.highlightGreen)
                }
            }
        }
    }

}

//#Preview {
//    MemberLineView()
//}
