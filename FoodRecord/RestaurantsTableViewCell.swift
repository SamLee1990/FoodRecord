//
//  RestaurantsTableViewCell.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/7/19.
//

import UIKit

class RestaurantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var optionsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        phoneLabel.text = restaurant.phoneNumber
        timeLabel.text = restaurant.businessHourString
        closedLabel.text = restaurant.closed
        
        let score = restaurant.score
        
        switch score {
        case 1:
            starImageViews[0].image = UIImage(systemName: "star.fill")
            for i in 1...4 {
                starImageViews[i].image = UIImage(systemName: "star")
            }
        case 2:
            for i in 0...1 {
                starImageViews[i].image = UIImage(systemName: "star.fill")
            }
            for i in 2...4 {
                starImageViews[i].image = UIImage(systemName: "star")
            }
        case 3:
            for i in 0...2 {
                starImageViews[i].image = UIImage(systemName: "star.fill")
            }
            for i in 3...4 {
                starImageViews[i].image = UIImage(systemName: "star")
            }
        case 4:
            for i in 0...3 {
                starImageViews[i].image = UIImage(systemName: "star.fill")
            }
            starImageViews[4].image = UIImage(systemName: "star")
        case 5:
            for i in 0...4 {
                starImageViews[i].image = UIImage(systemName: "star.fill")
            }
        default:
            break
        }
    }
    

}
