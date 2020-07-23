//
//  InitDate+CoreDataProperties.swift
//  iShop
//
//  Created by Chris Filiatrault on 23/7/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//
//

import Foundation
import CoreData


extension InitDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InitDate> {
        return NSFetchRequest<InitDate>(entityName: "InitDate")
    }

    @NSManaged public var initDate: Date?

}
