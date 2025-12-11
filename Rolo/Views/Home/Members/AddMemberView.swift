//
//  AddMemberView.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/10/25.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    var memberDetailID: UUID
    @State private var member: Member

    init(memberDetailID: UUID) {
        self.memberDetailID = memberDetailID
//        _member = State(initialValue: Member(name: "", surname: "", nickname: "", email: "", role: ""))
        _member = State(initialValue: Member.createEmpty())
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 32) {

                VStack(spacing: 0) {
                    headerSection()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.neutralLightGray)
                }

                avatarView()

                VStack(spacing: 8) {
                    mainMemberInfoSection()
                    contactsMemberInfoSection()
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationBarBackButtonHidden()
        }
    }

    // MARK: - avatarView
    private func avatarView() -> some View {
        Group {
            VStack(spacing: 8) {
                if let avatar = member.avatar {
                    Image("emptyAvatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 136, height: 136)
                } else {
                    if member.initials.isEmpty {
                        Image("emptyAvatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 136, height: 136)
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color.brandSecondary)
                                .frame(width: 136, height: 136)

                            Text(member.initials)
                                .font(.figtreeMedium(size: 40))
                                .foregroundColor(Color.highlightGreen)
                        }
                    }
                }

                Text("Add image")
                    .font(.figtreeMedium(size: 12))
                    .foregroundColor(.primaryGreen)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.neutralLightGray)
                    )
            }
        }
    }

    // MARK: - mainMemberInfoSection
    private func mainMemberInfoSection() -> some View {
        VStack(spacing: 0) {
            MemberDetailField(text: $member.name, title: "First name", isSeparatorNeed: true)
            MemberDetailField(text: $member.surname, title: "Last name", isSeparatorNeed: true)
            MemberDetailField(text: $member.nickname, title: "Nickname", isSeparatorNeed: false)
        }
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.neutralLightGray)
        )
    }

    // MARK: - contactsMemberInfoSection
    private func contactsMemberInfoSection() -> some View {
        VStack(spacing: 0) {
            MemberDetailField(text: $member.phone, title: "Phone", isSeparatorNeed: true)
            MemberDetailField(text: $member.email, title: "Email", isSeparatorNeed: false)
        }
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.neutralLightGray)
        )
    }

    // MARK: - headerSection
    private func headerSection() -> some View {
        HStack(spacing: 0) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.neutralBlack)
            })

            Spacer(minLength: 0)

            Text("Add members")
                .font(.figtree(size: 14))
                .foregroundColor(Color.neutralBlack)

            Spacer(minLength: 0)

            Button(action: {
//                print("Add member")
//                memberDeatilId = UUID()
//                showAddMemberScreen = true
            }, label: {
                Text("Add")
                    .font(.figtree(size: 14))
                    .foregroundColor(Color.highlightGreen)
            })
        }
        .frame(height: 56)
    }

}

#Preview {
    AddMemberView(memberDetailID: UUID())
}
