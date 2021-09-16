//
//  BusinessHoursData+CoreDataProperties.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/9/16.
//
//

import Foundation
import CoreData


extension BusinessHoursData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessHoursData> {
        return NSFetchRequest<BusinessHoursData>(entityName: "BusinessHoursData")
    }

    @NSManaged public var hour: Date?
    @NSManaged public var num: Int16
    @NSManaged public var belongto: RestaurantData?

}

extension BusinessHoursData : Identifiable {

}
