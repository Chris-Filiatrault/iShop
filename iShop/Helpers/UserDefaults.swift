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
   
   
    @Published var disableAutoCorrect: Bool = UserDefaults.standard.bool(forKey: "syncDisableAutoCorrect") {
        didSet { UserDefaults.standard.set(self.disableAutoCorrect, forKey: "syncDisableAutoCorrect") }
    }
   
   @Published var useCategories: Bool = UserDefaults.standard.bool(forKey: "syncUseCategories") {
       didSet { UserDefaults.standard.set(self.useCategories, forKey: "syncUseCategories") }
   }

   
}
