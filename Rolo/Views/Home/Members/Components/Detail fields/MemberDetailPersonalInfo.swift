//
//  MemberDetailPersonalInfo.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct MemberDetailPersonalInfo: View {
    @State private var isOpen: Bool = false
    @State private var gender: Gender = .male
    @State private var occupation: String = ""
    @State private var children: String = ""
    @State private var maritalStatus: String = ""

    @State private var selectedDate: Date = .now
    @State private var showCalendar = false

    enum Gender: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        case male = "Male"
        case female = "Female"
    }

    var body: some View {
        ZStack(alignment: .top) {
            header
                .zIndex(1)
            
            if isOpen {
                VStack(spacing: 0) {
                    RoloPicker(items: Gender.allCases, selection: $gender) { item, isSelected in
                        Text(item.rawValue)
                            .font(.figtree(size: 14))
                    }
                    .frame(height: 84)

                    Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 0) {
                        MemberDetailFieldRow(text: $occupation, title: "Occupation", isSeparatorNeed: true)
                        dateOfBirth
                            .onTapGesture {
                                showCalendar = true
                            }
                        MemberDetailFieldRow(text: $maritalStatus, title: "Marital Status", isSeparatorNeed: true)
                        MemberDetailFieldRow(text: $children, title: "Children", isSeparatorNeed: true)
                    }
                }
                .padding(.top, 52)
                .zIndex(0)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .clipped()
        .padding(.horizontal, 18)
        .sheet(isPresented: $showCalendar) {
            CalendarSheet(selectedDate: $selectedDate)
        }
    }
    
    private var header: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.28)) {
                isOpen.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                Text("Personal info")
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
    
    @ViewBuilder
    private var dateOfBirth: some View {
        GridRow {
            Text("Date of birth")
                .font(.figtree(size: 16))
                .foregroundColor(.neutralDarkGray)
            
            HStack(spacing: 0) {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                Spacer(minLength: 0)
                Image("calendar")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.neutralBlack)
            }
        }
        .frame(height: 52)
        .background(Color.neutralLightGray)
        .contentShape(Rectangle())
        
        GridRow {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.white)
                .gridCellColumns(2)
        }
    }
    
}

private struct CalendarSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date

    var body: some View {
        NavigationStack {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            //            .navigationTitle("Calendar")
            .padding()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

//#Preview {
//    MemberDetailField()
//}
