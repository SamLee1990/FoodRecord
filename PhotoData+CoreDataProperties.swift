//
//  PhotoData+CoreDataProperties.swift
//  FoodRecord
//
//  Created by ζδΈζ on 2021/9/16.
//
//

import Foundation
import CoreData


extension PhotoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoData> {
        return NSFetchRequest<PhotoData>(entityName: "PhotoData")
    }

    @NSManaged public var num: Int16
    @NSManaged public var photo: Data?
    @NSManaged public var belongto: RestaurantData?

}

extension PhotoData : Identifiable {

}
