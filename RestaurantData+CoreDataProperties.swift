//
//  RestaurantData+CoreDataProperties.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/9/16.
//
//

import Foundation
import CoreData


extension RestaurantData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantData> {
        return NSFetchRequest<RestaurantData>(entityName: "RestaurantData")
    }

    @NSManaged public var address: String?
    @NSManaged public var closeday: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var remark: String?
    @NSManaged public var score: Int16
    @NSManaged public var uuid: UUID?
    @NSManaged public var website: String?
    @NSManaged public var businesshours: NSSet?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for businesshours
extension RestaurantData {

    @objc(addBusinesshoursObject:)
    @NSManaged public func addToBusinesshours(_ value: BusinessHoursData)

    @objc(removeBusinesshoursObject:)
    @NSManaged public func removeFromBusinesshours(_ value: BusinessHoursData)

    @objc(addBusinesshours:)
    @NSManaged public func addToBusinesshours(_ values: NSSet)

    @objc(removeBusinesshours:)
    @NSManaged public func removeFromBusinesshours(_ values: NSSet)

}

// MARK: Generated accessors for photos
extension RestaurantData {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoData)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoData)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension RestaurantData : Identifiable {

}
