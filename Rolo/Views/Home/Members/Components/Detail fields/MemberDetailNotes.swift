//
//  MemberDetailNotes.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct MemberNote: Identifiable, Equatable {
    let id = UUID()
    var title: String = ""
    var noteText: String
}

struct MemberDetailNotes: View {
    @State private var isOpen: Bool = true
    @State private var newNoteString: String = ""

    @State private var notesArray: [MemberNote] = [
        .init(title: "Test Title", noteText: "This is a test note"),
        .init(title: "Test Title", noteText: "This is a test note"),
        .init(title: "Test Title", noteText: "This is a test note"),
        .init(title: "Test Title", noteText: "This is a test note This is a test note This is a test note This is a test note")
    ]

    var body: some View {
        ZStack(alignment: .top) {
            header
                .zIndex(1)
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach($notesArray.indices, id: \.self) { index in
                        let note = $notesArray[index]

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
                                        notesArray.removeAll { $0.id == note.id }
                                    }

                                VStack(alignment: .leading, spacing: 0) {
                                    TextField(
                                        text: note.title,
                                        prompt: Text("Add note")
                                            .font(.figtree(size: 16))
                                            .foregroundColor(.neutralMediumGray),
                                        axis: .vertical,
                                        label: { }
                                    )
                                    .font(.figtree(size: 16))
                                    .foregroundColor(.neutralBlack)
                                    .lineLimit(5)
                                    .fixedSize(horizontal: false, vertical: true)

                                    GridRow {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(.white)
                                            .gridCellColumns(2)
                                    }
                                    .padding(.vertical, 8)

                                    TextField(
                                        text: note.noteText,
                                        prompt: Text("Add note")
                                            .font(.figtree(size: 16))
                                            .foregroundColor(.neutralMediumGray),
                                        axis: .vertical,
                                        label: { }
                                    )
                                    .font(.figtree(size: 16))
                                    .foregroundColor(.neutralMediumGray)
                                    .lineLimit(5)
                                    .fixedSize(horizontal: false, vertical: true)
                                }
                                .padding(.leading, 8)

                                Spacer(minLength: 0)
                            }
                            .padding(.vertical, 16)
//                            .frame(minHeight: 52)

//                            if index < notesArray.count - 1 {
                                GridRow {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(.white)
                                        .gridCellColumns(2)
                                }
//                            }
                        }
                    }

                    HStack(spacing: 0) {
                        TextField(
                            text: $newNoteString,
                            prompt: Text("Add note")
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
                                notesArray.append(MemberNote(title: "", noteText: newNoteString))
                                newNoteString = ""
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
                Text("Notes")
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
