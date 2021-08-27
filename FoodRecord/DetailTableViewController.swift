//
//  DetailTableViewController.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/8/19.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var foodPhotoCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var websiteUrlLabel: UILabel!
    @IBOutlet weak var businessHourLabel: UILabel!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    
    var delegate: DetailTableViewControllerDelegate?
    
    var restaurant: Restaurant!
    var photoImages: Array<UIImage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodPhotoCollectionView.delegate = self
        foodPhotoCollectionView.dataSource = self
        setupRestaurantInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionViewCell()
    }
    
    func setupRestaurantInfo() {
        title = restaurant.name
        addressLabel.text = restaurant.address
        phoneNumberLabel.text = restaurant.phoneNumber
        websiteUrlLabel.text = restaurant.website
        businessHourLabel.text = restaurant.businessHourString
        closedLabel.text = restaurant.closed
        remarkLabel.text = restaurant.remark
        
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
    
    func setupCollectionViewCell() {
        let flowLayout = foodPhotoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        
        let width = foodPhotoCollectionView.bounds.width
        let height = foodPhotoCollectionView.bounds.height
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
    }
    
    @IBAction func changePhotoByPageControl(_ sender: UIPageControl) {
        let point = CGPoint(x: foodPhotoCollectionView.bounds.width * CGFloat(sender.currentPage), y: 0)
        foodPhotoCollectionView.setContentOffset(point, animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == foodPhotoCollectionView {
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
    @IBAction func alertActionSheet(_ sender: Any) {
        let controller  = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "修改", style: .default) { alertAction in
            self.pushUpdateViewController()
        }
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { alertAction in
            self.deleteRestaurant()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(updateAction)
        controller.addAction(deleteAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func pushUpdateViewController() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "AddModifyTableViewController") as? AddModifyTableViewController else { return }
        controller.delegate = self
        controller.actionType = .Update
        controller.restaurant = restaurant
        controller.foodPhotoImages = photoImages
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func deleteRestaurant() {
        let controller = UIAlertController(title: "確定要刪除「\(restaurant.name)」？", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "確定刪除", style: .destructive) { [self] alertAction in
            delegate?.deleteRow()
            try? Restaurant.savePhotoToFile(foodPhotos: nil, photoNames: nil, deletePhotoNames: restaurant.photoNames)
            navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(yesAction)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:
            doAction(label: addressLabel)
        case 3:
            doAction(label: phoneNumberLabel)
        case 4:
            doAction(label: websiteUrlLabel)
        default:
            break
        }
        
    }
    
    func doAction(label: UILabel) {
        guard let infoText = label.text else { return }
        guard infoText.isEmpty == false else { return }
        var doAction: UIAlertAction
        
        let controller = UIAlertController(title: infoText, message: nil, preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "複製", style: .default) { alertAction in
            print("複製到剪貼簿")
            UIPasteboard.general.string = infoText
        }
        
        switch label {
        case addressLabel:
            doAction = UIAlertAction(title: "前往地圖", style: .default) { alertAction in
                print("打開地圖app")
                if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                    if let urlString = "comgooglemaps://?q=\(infoText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let url = URL(string: urlString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("url無效")
                    }
                } else {
                    print("Can't use comgooglemaps://")
                    //開啟app store google map 商品頁面
                    let appStoreGoogleMapURL = URL(string: "itms-apps://itunes.apple.com/app/id585027354")!
                    UIApplication.shared.open(appStoreGoogleMapURL, options: [:], completionHandler: nil)
                }
            }
        case phoneNumberLabel:
            doAction = UIAlertAction(title: "撥打電話給店家", style: .default) { alertAction in
                print("撥電話")
                guard let url = URL(string: "tel://\(infoText)") else {
                    print("url無效")
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Can't use tel://")
                }
            }
        case websiteUrlLabel:
            doAction = UIAlertAction(title: "開啟網頁", style: .default) { alertAction in
                print("開啟網頁")
                guard let urlString = infoText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let url = URL(string: "https://\(urlString)") else {
                    print("url無效")
                    return
                }
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Can't use https://")
                }
            }
        default:
            doAction = UIAlertAction()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(copyAction)
        controller.addAction(doAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func unwindToBigPhoto(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? BigPhotoViewController,
           let item = sourceViewController.item{
            let indexPath = IndexPath(item: item, section: 0)
            foodPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            pageControl.currentPage = item
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentBigPhoto" {
            let controller = segue.destination as? BigPhotoViewController
            controller?.photos = photoImages
            controller?.item = sender as? Int
        }
    }
    
    
}

extension DetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = photoImages.count
        pageControl.numberOfPages = count
        if count == 0{
            return 1
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPhotoCollectionViewCell", for: indexPath) as? DetailPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        if !(photoImages.isEmpty) {
            cell.photoImageView.image = photoImages[indexPath.item]
            cell.photoImageView.contentMode = .scaleAspectFill
        }else{
            cell.photoImageView.image = UIImage(systemName: "questionmark.diamond")
            cell.photoImageView.contentMode = .center
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if photoImages.isEmpty == false{
            performSegue(withIdentifier: "presentBigPhoto", sender: indexPath.item)
        }
    }
    
    
}

extension DetailTableViewController: AddModifyTableViewControllerDelegate{
    
    func update(restaurant: Restaurant, foodPhotos: [UIImage]) {
        self.restaurant = restaurant
        self.photoImages = foodPhotos
        setupRestaurantInfo()
        tableView.reloadData()
        foodPhotoCollectionView.reloadData()
        let indextPath = IndexPath(item: 0, section: 0)
        foodPhotoCollectionView.scrollToItem(at: indextPath, at: .left, animated: false)
        pageControl.currentPage = 0
        delegate?.updateRow(restaurant: restaurant, foodPhotos: photoImages)
    }
    
}

//delegate
protocol DetailTableViewControllerDelegate {
    func updateRow(restaurant: Restaurant, foodPhotos: [UIImage])
    func deleteRow()
}
