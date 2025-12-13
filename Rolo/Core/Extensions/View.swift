//
//  View.swift
//  Rolo
//
//  Created by Roman Sundurov on 12/12/25.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder
    func applyIf(_ condition: Bool, _ modifier: (Self) -> some View) -> some View {
        if condition {
            modifier(self)
        } else {
            self
        }
    }
}
