//
//  ItemList.swift
//  iShop
//
//  Created by Chris Filiatrault on 13/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI
import CoreData

struct ItemList: View {
   
   @EnvironmentObject var globalVariables: GlobalVariableClass
   @ObservedObject var userDefaultsManager = UserDefaultsManager()
   @State var showMoreOptions: Bool = false
   @State var showRenameList: Bool = false
   
   var categoriesFetchRequest: FetchRequest<Category>
   var thisList: ListOfItems
   let uncategorised = uncategorisedCategory()
   let inBasket = inBasketCategory()
   
   init(listFromHomePage: ListOfItems) {
      
      thisList = listFromHomePage

      categoriesFetchRequest = FetchRequest<Category>(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ], predicate: NSPredicate(format: "name != %@", "Uncategorised"))
   }
   
   var body: some View {
      
      VStack(spacing: 0) {
         
         // ===Enter item textfield===
         TextField("Add item", text: self.$globalVariables.itemInTextfield, onEditingChanged: { changed in
            self.globalVariables.catalogueShown = true
         }, onCommit: {
            if self.globalVariables.itemInTextfield != "" {
               addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
               self.globalVariables.itemInTextfield = ""
            }
            self.globalVariables.itemInTextfield = ""
         })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color(.white))
            .padding(15)
            .padding(.top, 10)
            .disableAutocorrection(self.globalVariables.keyValStore.bool(forKey: "disableAutocorrect"))
            
         
         // ===List of items with categories===
         if globalVariables.catalogueShown == false {
            
            List {
               ForEach(categoriesFetchRequest.wrappedValue, id: \.self) { category in
                  ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: category)
               }
               ItemCategory(listFromHomePage: self.thisList, categoryFromItemList: uncategorised!)
               
               InBasket(listFromHomePage: self.thisList, categoryFromItemList: self.inBasket!)
            }.padding(.bottom)
            .sheet(isPresented: self.$showRenameList){
               RenameList(thisList: self.thisList, newListName: self.thisList.wrappedName, showingRenameListBinding: self.$showRenameList)
                  .environmentObject(self.globalVariables)
            }
         }
            
            // ===Catalogue===
         else if globalVariables.catalogueShown == true {
            Catalogue(passedInList: thisList, filter: globalVariables.itemInTextfield)
         }
      }
      .background(Color("listBackground").edgesIgnoringSafeArea(.all))
      .modifier(AdaptsToSoftwareKeyboard())
      .onDisappear() {
         self.globalVariables.itemInTextfield = ""
      }
      .onAppear() {
         self.globalVariables.catalogueShown = false
      }
      
      // ===Navigation bar===
      .navigationBarTitle(globalVariables.catalogueShown ? "Item History" : thisList.wrappedName)
      .navigationBarItems(trailing:
         HStack {
            if globalVariables.catalogueShown == false {
               // More options button
               Button(action: {
                  self.showMoreOptions.toggle()
               }) {
                  Image(systemName: "ellipsis.circle")
                     .imageScale(.large)
                     .foregroundColor(Color("navBarFont"))
                     .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
               }.padding(.vertical, 10)
                  .actionSheet(isPresented: self.$showMoreOptions) {
                     ActionSheet(title: Text("Options"), buttons: [
                        .destructive(Text("Delete All Items")) {
                           clearList(thisList: self.thisList)
                        },
                        .default(Text("Rename List")) {
                           self.showRenameList.toggle()
                        },
                        .default(Text("Uncheck All Items")) {
                           uncheckAllItems(thisList: self.thisList)
                        },
                     .cancel(Text("Cancel"))])
               }
            }
               
            // Done button
            else if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count == 0 {
               Button(action: {
                  withAnimation {
                     UIApplication.shared.endEditing()
                     self.globalVariables.catalogueShown = false
                  }
               }) {
                  Text("Done")
                     .font(.headline)
                     .foregroundColor(Color("navBarFont"))
               }
            }
               
            // Add button
            else if globalVariables.catalogueShown == true && globalVariables.itemInTextfield.count > 0 {
               Button(action: {
                  UIApplication.shared.endEditing()
                  if self.globalVariables.itemInTextfield != "" {
                     addNewItem(itemName: self.$globalVariables.itemInTextfield, listOrigin: self.thisList)
                     self.globalVariables.itemInTextfield = ""
                  }
                  self.globalVariables.itemInTextfield = ""
               }) {
                  Text("Add")
                     .font(.headline)
                     .foregroundColor(Color("navBarFont"))
               }
            }
      })
      
   }// End of body
}



