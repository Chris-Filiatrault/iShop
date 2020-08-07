//
//  Category+CoreDataProperties.swift
//  iShop
//
//  Created by Chris Filiatrault on 31/5/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var itemsInCategory: NSSet?
    @NSManaged public var defaultCategory: Bool
    @NSManaged public var position: Int32
   
   
   public var wrappedName: String {
      name ?? "Unknown category"
   }
   
   
   public var itemsInCategoryArray: [Item] {
      let set = itemsInCategory as? Set<Item> ?? []
      return set.sorted {
         $0.wrappedName.lowercased() < $1.wrappedName.lowercased()
      }
   }
   
   public var wrappedItemsInCategory: Set<Item> {
      (itemsInCategory ?? []) as! Set<Item>
   }
   
   
   
   

}

// MARK: Generated accessors for itemsInCategory
extension Category {

    @objc(addItemsInCategoryObject:)
    @NSManaged public func addToItemsInCategory(_ value: Item)

    @objc(removeItemsInCategoryObject:)
    @NSManaged public func removeFromItemsInCategory(_ value: Item)

    @objc(addItemsInCategory:)
    @NSManaged public func addToItemsInCategory(_ values: NSSet)

    @objc(removeItemsInCategory:)
    @NSManaged public func removeFromItemsInCategory(_ values: NSSet)

}
