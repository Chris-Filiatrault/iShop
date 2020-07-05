//
//  ItemCategory.swift
//  iShop
//
//  Created by Chris Filiatrault on 1/6/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
// 
import SwiftUI

struct ItemCategory: View {
   var thisList: ListOfItems
   var thisCategory: Category
   var fetchRequest: FetchRequest<Item>
   var thisCategoryHasItems: Bool {
      var numItems: Int = 0
      for item in thisCategory.itemsInCategoryArray {
         if item.addedToAList == true && thisList.itemArray.contains(item) {
            numItems += 1
         }
      }
      return numItems > 0
   }
   
   init(listFromHomePage: ListOfItems, categoryFromItemList: Category) {
      
      
      thisList = listFromHomePage
      thisCategory = categoryFromItemList
      
      let originPredicate = NSPredicate(format: "origin = %@", thisList)
      let inListPredicate = NSPredicate(format: "addedToAList == true")
      let categoryPredicate = NSPredicate(format: "categoryOrigin = %@", thisCategory)
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [originPredicate, inListPredicate, categoryPredicate])
   
      fetchRequest = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))
      ], predicate: compoundPredicate)
      
   }
   
   var body: some View {
        VStack(alignment: .leading) {
         
         if thisCategoryHasItems {
            ZStack(alignment: .leading) {
              
           Rectangle()
              .foregroundColor(Color("navBarFont"))
            
           Text(thisCategory.wrappedName)
              .font(.headline)
              .foregroundColor(Color("standardDarkBlue"))
              .padding(.vertical, 5)
               .padding(.horizontal)
              .multilineTextAlignment(.leading)
            }
         }
  
           
         ForEach(fetchRequest.wrappedValue, id: \.self) { item in
            ItemRow(thisList: self.thisList, thisItem: item, itemInListMarkedOff: item.markedOff, thisItemQuantity: item.quantity)
               .listRowBackground(Color("listRowBackground"))
               .padding(.horizontal)
         }
           Divider().hidden()
        }
    }
}

