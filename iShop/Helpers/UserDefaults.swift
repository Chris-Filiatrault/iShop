//
//  UserDefaultsManager.swift
//  iShop
//
//  Created by Chris Filiatrault on 8/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
   // add the following to any view using UserDefaultManager
   // @ObservedObject var userDefaultsManager = UserDefaultsManager()
   
   @Published var useCategories: Bool = UserDefaults.standard.bool(forKey: "syncUseCategories") {
      didSet { UserDefaults.standard.set(self.useCategories, forKey: "syncUseCategories") }
   }
   
   @Published var keepScreenOn: Bool = UserDefaults.standard.bool(forKey: "syncKeepScreenOn") {
      didSet { UserDefaults.standard.set(self.keepScreenOn, forKey: "syncKeepScreenOn") }
   }
   
}
