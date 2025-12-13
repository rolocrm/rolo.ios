//
//  MemberDetailReligiousInfo.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct MemberDetailReligiousInfo: View {
    @State private var isOpen: Bool = false
    @State private var religious: Religious = .jewish
    @State private var jewishLineage: JewishLineage = .yisroel
    @State private var hewbrewName: String = ""
    @State private var fatherHebrewName: String = ""
    @State private var motherHebrewName: String = ""

    enum Religious: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case jewish = "Jewish"
        case gentile = "Gentile"
    }

    enum JewishLineage: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case cohen = "Cohen"
        case levi = "Levi"
        case yisroel = "Yisroel"
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
                .zIndex(1)
            
            if isOpen {
                VStack(spacing: 0) {
                    RoloPicker(items: Religious.allCases, selection: $religious) { item, isSelected in
                        Text(item.rawValue)
                            .font(.figtree(size: 14))
                    }
                    .frame(height: 84)

                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 0) {
                        MemberDetailFieldRow(text: $hewbrewName, title: "Hewbrew name", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $fatherHebrewName, title: "Father Hebrew name", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $motherHebrewName, title: "Mother Hebrew name", isSeparatorNeed: true)
                    }

                    RoloPicker(items: JewishLineage.allCases, selection: $jewishLineage) { item, isSelected in
                        Text(item.rawValue)
                            .font(.figtree(size: 14))
                    }
                    .frame(height: 84)
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
                Text("Religious Info")
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
