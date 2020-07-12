//
//  ChooseCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 12/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

struct ChooseCategory: View {
   @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
   @FetchRequest(entity: Category.entity(), sortDescriptors: [
      NSSortDescriptor(keyPath: \Category.name, ascending: true)
   ]) var categories: FetchedResults<Category>
   
   var thisItem: Item
   @Binding var newItemCategory: Category
   
   
   
    var body: some View {
      
      VStack {
         List {
         
            Button(action: {
               print("Pressed")
            }) {
               Text("Button")
            }
            
         ForEach(self.categories, id: \.self) { category in
            Button(action: {
            changeCategory1(thisItem: self.thisItem,
                            oldCategory: self.thisItem.categoryOrigin!,
                            newCategory: category)
               self.newItemCategory = category
               self.presentationMode.wrappedValue.dismiss()
            }) {
               HStack {
                  
            Text(category.wrappedName)
               .foregroundColor(category.wrappedName == self.thisItem.categoryOrigin!.wrappedName ? .blue : .black)

               if category.wrappedName == self.thisItem.categoryOrigin!.wrappedName {
                  Spacer()
                  Image(systemName: "checkmark")
                     .imageScale(.medium)
               }
               }
            }
         }
      }
    }
   }
}


