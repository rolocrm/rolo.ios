//
//  MemberDetailSocialMedia.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct SocialMediaLink: Identifiable, Equatable {
    let id = UUID()
    var linkText: String
}

struct MemberDetailSocialMedia: View {
    @State private var isOpen: Bool = false
    @State private var newLinkString: String = ""

    @State private var linkArray: [SocialMediaLink] = [
        .init(linkText: "instagram.com/stanley.jordan"),
        .init(linkText: "linkedin.com/stanley.jordan"),
        .init(linkText: "instagram.com/stanley.jordan"),
        .init(linkText: "linkedin.com/stanley.jordan_linkedin.com/stanley.jordan")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            header
                .zIndex(1)
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach($linkArray) { link in
                        VStack(spacing: 0) {
                            GridRow {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(.white)
                                    .gridCellColumns(2)
                            }

                            HStack(spacing: 0) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.errorRed)
                                    .onTapGesture {
                                        linkArray.removeAll(where: { $0.id == link.id })
                                    }

                                TextField(
                                    text: link.linkText,
                                    prompt: Text("Add link")
                                        .font(.figtree(size: 16))
                                        .foregroundColor(.neutralMediumGray),
                                    axis: .vertical,
                                    label: { }
                                )
                                .font(.figtree(size: 16))
                                .foregroundColor(.neutralBlack)
                                .padding(.leading, 8)
                                .lineLimit(5)
                                .fixedSize(horizontal: false, vertical: true)

                                Spacer(minLength: 0)
                            }
                            .frame(minHeight: 52)

                            GridRow {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(.white)
                                    .gridCellColumns(2)
                            }
                        }
                    }

                    HStack(spacing: 0) {
//                        TextField("awadw", text: $newLinkString)
//                            .textInputAutocapitalization(.never)
//                            .disableAutocorrection(true)
//                            .font(.figtreeMedium(size: 16))
//                            .foregroundColor(.neutralBlack)
////                            .focused($isFocused)

                        TextField(
                            text: $newLinkString,
                            prompt: Text("Add link")
                                .font(.figtreeMedium(size: 16))
                                .foregroundColor(.neutralMediumGray),
                            label: { }
                        )
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                        Spacer(minLength: 0)

                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.highlightGreen)
                            .onTapGesture {
                                linkArray.append(SocialMediaLink(linkText: newLinkString))
                                newLinkString = ""
                            }
                    }
                    .frame(height: 52)

                }
                .padding(.top, 52)
                .zIndex(0)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .clipped()
        .padding(.horizontal, 18)
    }
    
    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.28)) {
                isOpen.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                Text("Social Media")
                    .font(.figtree(size: 16))
                    .foregroundColor(.neutralBlack)
                
                Spacer(minLength: 0)
                
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.neutralBlack)
                    .transaction { $0.animation = nil }
                //                    .rotationEffect(.degrees(isOpen ? 180 : 0))
            }
            .frame(height: 52)
            .background(Color.neutralLightGray)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
}
