//
//  Restaurant.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/7/19.
//

import Foundation
import UIKit

struct Restaurant {
    var uuid: UUID
    var name: String
    var photos: Array<UIImage>
    var score: Int//評分
    var address: String?
    var phoneNumber: String?
    var website: String?
    var businessHours: Array<Date>?//營業時間
    var closed: String?//公休
    var remark: String?//備註
    var businessHourString: String? {
        var businessHourString: String?
        var formattedStrings = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let businessHours = businessHours,
           !(businessHours.isEmpty){
            for date in businessHours {
                formattedStrings.append(dateFormatter.string(from: date))
            }
            if formattedStrings.count >= 2{
                businessHourString = "\(formattedStrings[0]) - \(formattedStrings[1])"
            }
            if formattedStrings.count == 4{
                businessHourString! += "，\(formattedStrings[2]) - \(formattedStrings[3])"
            }
        }
        
        return businessHourString
    }
    
    // MARK: - FileManager
    /*
    
    //檔案位置
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //create, update, delete Restaurant
    static func saveToFile(restaurants: [Self]) throws {
        let propertyEncoder = PropertyListEncoder()
        let data = try propertyEncoder.encode(restaurants)
        let url = Self.documentsDirectory.appendingPathComponent("restaurant")
        try data.write(to: url)
    }
    
    //create, update, delete photo
    static func savePhotoToFile(foodPhotos: [UIImage]?, photoNames: [String]?, deletePhotoNames: [String]?) throws {
        if let deletePhotoNames = deletePhotoNames {
            for deletePhotoName in deletePhotoNames {
                let url = Self.documentsDirectory.appendingPathComponent(deletePhotoName)
                try FileManager.default.removeItem(at: url)
            }
        }
        if let photoNames = photoNames,
           let foodPhotos = foodPhotos{
            for (i, foodPhoto) in foodPhotos.enumerated() {
                if let data = foodPhoto.pngData() {
                    print("[savePhotoToFile]存擋")
                    let url = Self.documentsDirectory.appendingPathComponent(photoNames[i])
                    try data.write(to: url)
                }
            }
        }
    }
    
    //read Restaurant
    static func readRestaurantsFromFile() -> [Self]? {
        let propertyDecoder = PropertyListDecoder()
        let url = Restaurant.documentsDirectory.appendingPathComponent("restaurant")
        if let data = try? Data(contentsOf: url),
           let restaurants = try? propertyDecoder.decode([Self].self, from: data){
            return restaurants
        }else{
            return nil
        }
    }
    
    //read image
    static func readPhotoFromFile(photoNames: [String]) -> [UIImage] {
        var foodPhotoImages = [UIImage]()
        for photoName in photoNames {
            let url = Self.documentsDirectory.appendingPathComponent(photoName)
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data){
                foodPhotoImages.append(image)
            }
        }
        return foodPhotoImages
    }
 */
    
    
}
