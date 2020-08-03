
// Old version
import Foundation
import CoreData


extension ListOfItems {
   
   @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfItems> {
      return NSFetchRequest<ListOfItems>(entityName: "ListOfItems")
   }
   
   @NSManaged public var dateAdded: Date?
   @NSManaged public var name: String?
   @NSManaged public var id: UUID?
   @NSManaged public var index: Int64
   @NSManaged public var items: NSSet?
   @NSManaged public var position: Int32
   
   /*
    NSSet (above) is the old objective C style set, which can't be used with ForEach loops, as we don't know the order of the items. Also core data hasn't restricted this property to just instances of items (could contain various other things as well). So we need to:
    
    1: convert it from an NSSet, to a set of type Item
    2: convert that set of type Item to an array so the elements (item objects) can be ordered
    3: sort that array, so a ForEach can read the values properly.
    
    Note that sorting a set in Swift, automatically returns an array, so 2 and 3 happen at the same time.
    To sort, we need to provide a closure telling swift HOW to sort them (because it's a custom datatype, swift can't just figure it out on it's own).
    These steps are done below in the computed property called itemArray
    */
   
   
   // Added this property to List, so the String values from name (above) can be easily accessed.
   public var wrappedName: String {
      name ?? "Unknown list"
   }
   
   public var itemArray: [Item] {
      let set = items as? Set<Item> ?? []
      return set.sorted {
         $0.wrappedName.lowercased() < $1.wrappedName.lowercased()
      }
   }
   

   
   public var nameArray: [String] {
      var names: [String] = []
      let set = items as? Set<Item> ?? []
      let itemArray = set.sorted {
         $0.wrappedName.lowercased() < $1.wrappedName.lowercased()
      }
      for item in itemArray {
         names.append(item.wrappedName)
      }
      return names
   }
   
   
}

// MARK: Generated accessors for items
extension ListOfItems {
   
   @objc(addItemsObject:)
   @NSManaged public func addToItems(_ value: Item)
   
   @objc(removeItemsObject:)
   @NSManaged public func removeFromItems(_ value: Item)
   
   @objc(addItems:)
   @NSManaged public func addToItems(_ values: NSSet)
   
   @objc(removeItems:)
   @NSManaged public func removeFromItems(_ values: NSSet)
   
}



//
//  ListOfItems+CoreDataProperties.swift
//  iShop
//
//  Created by Chris Filiatrault on 31/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

//import Foundation
//import CoreData
//
//
//extension ListOfItems {
//
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListOfItems> {
//        return NSFetchRequest<ListOfItems>(entityName: "ListOfItems")
//    }
//
//    @NSManaged public var dateAdded: Date?
//    @NSManaged public var id: UUID?
//    @NSManaged public var name: String?
//    @NSManaged public var items: NSSet?
//
//}
//
//// MARK: Generated accessors for items
//extension ListOfItems {
//
//    @objc(addItemsObject:)
//    @NSManaged public func addToItems(_ value: Item)
//
//    @objc(removeItemsObject:)
//    @NSManaged public func removeFromItems(_ value: Item)
//
//    @objc(addItems:)
//    @NSManaged public func addToItems(_ values: NSSet)
//
//    @objc(removeItems:)
//    @NSManaged public func removeFromItems(_ values: NSSet)
//
//}


