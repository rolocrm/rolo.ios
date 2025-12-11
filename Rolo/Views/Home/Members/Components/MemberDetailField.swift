//
//  MemberDetailField.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/11/25.
//

import SwiftUI

struct MemberDetailField: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool

    let title: String
    let isSeparatorNeed: Bool
//    let memberDetailFieldType: MemberDetailFieldType

    var body: some View {
        HStack {
            Text(title)
                .font(.figtree(size: 16))
                .foregroundColor(.neutralDarkGray)

            TextField("", text: $text)
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
                .font(.figtreeMedium(size: 14))
                .foregroundColor(.neutralDarkGray)
                .focused($isFocused)
        }
        .frame(height: 52)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }

        if isSeparatorNeed {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.white)
        }
    }

    // TODO: - Finalize it
//    enum MemberDetailFieldType {
//        case text
//        case phone
//        case email
//    }
//
//    private func isValidEmail(_ value: String) -> Bool {
//        // [^@]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}
//        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
//        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
//        return predicate.evaluate(with: value)
//    }
//
//    private func isValidPhone(_ value: String) -> Bool {
//        let allowedCharacters = CharacterSet(charactersIn: "+0123456789 -()")
//        if value.unicodeScalars.contains(where: { !allowedCharacters.contains($0) }) {
//            return false
//        }
//
//        let digits = value.filter { $0.isNumber }
//        return (9...15).contains(digits.count)
//    }
}

//#Preview {
//    MemberDetailField()
//}
