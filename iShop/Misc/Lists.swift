////
////  Lists.swift
////  iShop
////
////  Created by Chris Filiatrault on 25/7/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//import SwiftUI
//
//struct Lists: View {
//   @EnvironmentObject var globalVariables: GlobalVariableClass
//   
//   var listFetchRequest: FetchRequest<ListOfItems>
//   
//   init(sortListAlphabetically: Bool) {
//      listFetchRequest = FetchRequest<ListOfItems>(entity: ListOfItems.entity(), sortDescriptors: [
//         NSSortDescriptor(key: "name", ascending: sortListAlphabetically, selector: #selector(NSString.caseInsensitiveCompare(_:)))
//      ], predicate: NSPredicate(format: "name != %@", "Default-4BB59BCD-CCDA-4AC2-BC9E-EA193AE31B5D"))
//   }
//   
//   var body: some View {
//      VStack {
//         
//      List {
//         ForEach(listFetchRequest.wrappedValue, id: \.self) { list in
//            Text(list.wrappedName)
//         }
//      }
//         Button(action: {
//            sortAlphabetically.toggle()
//         }) {
//            Text("Change order")
//         }
//      }
//    }
//}
