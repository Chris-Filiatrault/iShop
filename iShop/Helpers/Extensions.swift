//
//  Extensions.swift
//  iShop
//
//  Created by Chris Filiatrault on 26/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import UIKit


// Dismiss keyboard
// UIApplication.shared.endEditing() to use it when needed
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



// Get user's device model as a string
// https://stackoverflow.com/questions/11197509/how-to-get-device-make-and-model-on-ios/11197770#11197770

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
