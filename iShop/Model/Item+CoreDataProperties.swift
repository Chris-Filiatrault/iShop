//
//  Item+CoreDataProperties.swift
//  iShop
//
//  Created by Chris Filiatrault on 31/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

// NEW
//import Foundation
//import CoreData
//
//
//extension Item {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
//        return NSFetchRequest<Item>(entityName: "Item")
//    }
//
//    @NSManaged public var addedToAList: Bool
//    @NSManaged public var dateAdded: Date?
//    @NSManaged public var markedOff: Bool
//    @NSManaged public var name: String?
//    @NSManaged public var quantity: Int32
//    @NSManaged public var id: UUID?
//    @NSManaged public var origin: ListOfItems?
//    @NSManaged public var originName: String?
//    @NSManaged public var categoryOrigin: Category?
//
//}




// OLD
import SwiftUI
import Foundation
import CoreData


extension Item {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
      return NSFetchRequest<Item>(entityName: "Item")
   }
   
   @NSManaged public var addedToAList: Bool // Toggles Green plus in catalogue
   @NSManaged public var dateAdded: Date?
   @NSManaged public var markedOff: Bool // Toggles tick image in a list
   @NSManaged public var name: String?
   @NSManaged public var quantity: Int32
   @NSManaged public var id: UUID?
   @NSManaged public var origin: ListOfItems?
   @NSManaged public var originName: String?
   @NSManaged public var categoryOrigin: Category?
   
   // Added these properties to Item, so the String value from name can be easily accessed.
   public var wrappedName: String {
      name ?? "Unknown item"
   }
   
   public var wrappedDate: Date {
      dateAdded ?? Date()
   }
   
   public var markedOffWrapped: Bool {
      markedOff
   }
   
   public var wrappedOriginName: String {
      origin?.name ?? ""
   }
   
   public var wrappedID: UUID {
      id ?? UUID()
   }
   
}
   
   
// Appears that I don't need to unwrap markedOff and quantity as was done for name above, as the properties aren't optionals.
//   public var wrappedMarkedOff: Bool {
//      markedOff ?? false
//   }
//
//   public var wrappedQuantity: Double {
//      quantity ?? 0
//   }
   
