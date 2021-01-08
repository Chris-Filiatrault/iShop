//
//  UserDefaultsManager.swift
//  iShop
//
//  Created by Chris Filiatrault on 8/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI


/// UserDefaults are saved this way, as changes to a toggle switch (in settings) are saved immediately.
/// Usage: @ObservedObject var userDefaultsManager = UserDefaultsManager()

class UserDefaultsManager: ObservableObject {
   
   @Published var useCategories: Bool = UserDefaults.standard.bool(forKey: "syncUseCategories") {
      didSet { UserDefaults.standard.set(self.useCategories, forKey: "syncUseCategories") }
   }
   
   @Published var keepScreenOn: Bool = UserDefaults.standard.bool(forKey: "syncKeepScreenOn") {
      didSet { UserDefaults.standard.set(self.keepScreenOn, forKey: "syncKeepScreenOn") }
   }
   
   @Published var useDarkMode: Bool = UserDefaults.standard.bool(forKey: "syncUseDarkMode") {
      didSet {
         UserDefaults.standard.set(self.useDarkMode, forKey: "syncUseDarkMode")
      }
   }
   
   
}


//struct ToggleModel {
//    var isDark: Bool = true {
//        didSet {
//         SceneDelegate().window?.overrideUserInterfaceStyle = isDark ? .dark : .light
//        }
//    }
//}
