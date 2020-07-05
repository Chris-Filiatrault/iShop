//
//  EnvironmentObjects.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

// ADD THIS TO ANY VIEW TO MAKE GLOBAL VARIABLES AVAILABLE
//@EnvironmentObject var globalVariables: GlobalVariableClass

class GlobalVariableClass: ObservableObject {
 
   @Published var itemInTextfield: String = ""
   @Published var catalogueShown: Bool = false
   
   
//   @FetchRequest(entity: Category.entity(), sortDescriptors: [
//      NSSortDescriptor(keyPath: \Category.name, ascending: true)
//   ]) var categoriesFromFetchRequest: FetchedResults<Category>
//
   
   // === SETTINGS ===
   @Published var disableAutoCorrect: Bool = false
   
}

