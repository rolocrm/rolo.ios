//
//  MemberDetailAddress.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct MemberDetailAddress: View {
    @State private var isOpen: Bool = false
    @State private var addressLine1: String = ""
    @State private var addressLine2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zipCode: String = ""
    @State private var country: String = ""

    var body: some View {
        ZStack(alignment: .top) {
            header
                .zIndex(1)
            
            if isOpen {
                VStack(spacing: 0) {
                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 0) {
                        MemberDetailFieldRow(text: $addressLine1, title: "Address line 1", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $addressLine2, title: "Address line 2", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $city, title: "City", isSeparatorNeed: true)

                        MemberDetailFieldRow(text: $state, title: "State", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $country, title: "Country", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $zipCode, title: "Zip Code", isSeparatorNeed: false)
                    }
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
                Text("Address")
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
