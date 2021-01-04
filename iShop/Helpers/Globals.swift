//
//  EnvironmentObjects.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import UIKit
import CoreData

// ADD THIS TO ANY STRUCT TO MAKE GLOBAL VARIABLES AVAILABLE
//@EnvironmentObject var globalVariables: GlobalVariableClass

class GlobalVariableClass: ObservableObject {
 
   
   @Published var itemInTextfield: String = ""
   @Published var catalogueShown: Bool = false
   @Published var isEditMode: EditMode = .inactive
   @State var restoreItemsFromInBasket: Bool = false
   @State var refreshingID = UUID()
   @State var onboardingShownFromSettings: Bool = false
   @State var showItemDetails: Bool = false
   let navBarColor: UIColor = UIColor(red: 5/255, green: 15/255, blue: 35/255, alpha: 0.9)
   let userIsOnMac = UIDevice.current.userInterfaceIdiom == .mac
   
   
   @State var testTextString: String = ""
}

