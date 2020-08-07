//
//  ListOfItems+CoreDataClass.swift
//  iShop
//
//  Created by Chris Filiatrault on 31/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ListOfItems)
public class ListOfItems: NSManagedObject, Identifiable {

}

extension ListOfItems {
   static func getListsFetchRequest() -> NSFetchRequest<ListOfItems> {
      let request: NSFetchRequest<ListOfItems> = ListOfItems.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
      return request
   }
}
