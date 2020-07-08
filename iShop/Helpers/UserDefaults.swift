//
//  UserDefaultsManager.swift
//  iShop
//
//  Created by Chris Filiatrault on 8/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    @Published var disableAutoCorrect: Bool = UserDefaults.standard.bool(forKey: "disableAutoCorrect") {
        didSet { UserDefaults.standard.set(self.disableAutoCorrect, forKey: "disableAutoCorrect") }
    }
}
