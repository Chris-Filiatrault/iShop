//
//  Extensions.swift
//  iShop
//
//  Created by Chris Filiatrault on 26/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI


// Dismiss keyboard
// UIApplication.shared.endEditing() to use it when needed
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

