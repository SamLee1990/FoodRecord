//
//  AddModifyTableViewController.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/7/26.
//

import UIKit
import PhotosUI

class AddModifyTableViewController: UITableViewController {
    
    @IBOutlet var photoBarButtonItems: [UIBarButtonItem]!
    @IBOutlet weak var photoButtonView: UIView!
    @IBOutlet var photoButtons: [UIButton]!
    @IBOutlet weak var foodPhotoCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet var businessHoursDatePickers: [UIDatePicker]!
    @IBOutlet var datePickerControlSwitchs: [UISwitch]!
    @IBOutlet weak var closedTimeTextField: UITextField!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: AddModifyTableViewControllerDelegate?

    var restaurant: Restaurant!
    var actionType: ActionType!//動作類型
    var foodPhotoImages = [UIImage]()//照片
    
    let photoLimit = 20//上傳照片數量上限
    var oldFoodPhotoNames: Array<String>?//舊照片名稱
    var score = 0//評分
    let starUIImage = UIImage(systemName: "star")
    let starFillUIImage = UIImage(systemName: "star.fill")
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //設定手勢點空白處收鍵盤
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardForTap))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        //設定pageControl背景樣式
        pageControl.backgroundStyle = .prominent
        //barButtonItem預設隱藏
        for barButton in photoBarButtonItems {
            barButton.tintColor = UIColor.clear
        }
        //模式判斷
        if actionType == .Add {
            title = "新增"
        } else {
            title = "修改"
            updateModeInit()
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //設定collectionViewCell大小
        configureCollectionViewCellSize()
    }
    
    
    func updateModeInit() {
        nameTextField.text = restaurant.name
        oldFoodPhotoNames = restaurant.photoNames
        score = restaurant.score
        switch score {
        case 0:
            for starButton in starButtons {
                starButton.setImage(starUIImage, for: .normal)
            }
        case 1:
            starButtons[0].setImage(starFillUIImage, for: .normal)
            for starButton in starButtons[1...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
        case 2:
            for starButton in starButtons[0...1] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            for starButton in starButtons[2...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
        case 3:
            for starButton in starButtons[0...2] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            for starButton in starButtons[3...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
        case 4:
            for starButton in starButtons[0...3] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            starButtons[4].setImage(starUIImage, for: .normal)
        case 5:
            for starButton in starButtons {
                starButton.setImage(starFillUIImage, for: .normal)
            }
        default:
            break
        }
        addressTextView.text = restaurant.address
        phoneTextField.text = restaurant.phoneNumber
        websiteTextField.text = restaurant.website
        setBusinessHours(businessHoursArray: restaurant.businessHours)
        closedTimeTextField.text = restaurant.closed
        remarkTextView.text = restaurant.remark
    }
    
    //從相簿選照片
    @IBAction func choosePhoto(_ sender: Any) {
        guard photoCountCheck(count: foodPhotoImages.count) else {
            return
        }
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = photoLimit - foodPhotoImages.count
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    //拍照
    @IBAction func takePhoto(_ sender: Any) {
        guard photoCountCheck(count: foodPhotoImages.count) else {
            return
        }
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    //照片數量檢查
    func photoCountCheck(count: Int) -> Bool {
        if count < photoLimit{
            return true
        }else{
            let controller = UIAlertController(title: "照片已到達上限", message: "最多選取\(photoLimit)張照片", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(actionOk)
            present(controller, animated: true, completion: nil)
            return false
        }
    }
    
    //照片換頁
    @IBAction func changePage(_ sender: UIPageControl) {
        let point = CGPoint(x: foodPhotoCollectionView.bounds.width * CGFloat(sender.currentPage), y: 0)
        foodPhotoCollectionView.setContentOffset(point, animated: true)
    }

    //取消選取照片
    @IBAction func deletePhoto(_ sender: UIButton) {
        foodPhotoImages.remove(at: sender.tag)
        let indexPath = IndexPath(item: sender.tag, section: 0)
        foodPhotoCollectionView.deleteItems(at: [indexPath])
    }
    
    //評分
    @IBAction func score(_ sender: UIButton) {
        switch sender {
        case starButtons[0]:
            sender.setImage(starFillUIImage, for: .normal)
            for starButton in starButtons[1...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
            score = 1
        case starButtons[1]:
            for starButton in starButtons[0...1] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            for starButton in starButtons[2...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
            score = 2
        case starButtons[2]:
            for starButton in starButtons[0...2] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            for starButton in starButtons[3...4] {
                starButton.setImage(starUIImage, for: .normal)
            }
            score = 3
        case starButtons[3]:
            for starButton in starButtons[0...3] {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            starButtons[4].setImage(starUIImage, for: .normal)
            score = 4
        case starButtons[4]:
            for starButton in starButtons {
                starButton.setImage(starFillUIImage, for: .normal)
            }
            score = 5
        default:
            break
        }
    }
    
    
    @IBAction func switchForBusinessHoursOne(_ sender: UISwitch) {
        if sender.isOn {
            businessHoursDatePickers[0].isEnabled = true
            businessHoursDatePickers[1].isEnabled = true
        }else{
            businessHoursDatePickers[0].isEnabled = false
            businessHoursDatePickers[1].isEnabled = false
        }
    }
    
    
    @IBAction func switchForBusinessHoursTwo(_ sender: UISwitch) {
        if sender.isOn {
            businessHoursDatePickers[2].isEnabled = true
            businessHoursDatePickers[3].isEnabled = true
        }else{
            businessHoursDatePickers[2].isEnabled = false
            businessHoursDatePickers[3].isEnabled = false
        }
    }
    
    //pageControl圓點連動
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == foodPhotoCollectionView {
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    }
    
    //BusinessHours資料儲存
    func getBusinessHours() -> Array<Date> {
        var businessHoursArray = [Date]()
        let switchValueOne = datePickerControlSwitchs[0].isOn
        let switchValueTwo = datePickerControlSwitchs[1].isOn
        
        if switchValueOne, !switchValueTwo{
            for datePicker in businessHoursDatePickers[0...1] {
                businessHoursArray.append(datePicker.date)
            }
        }else if switchValueOne, switchValueTwo{
            for datePicker in businessHoursDatePickers{
                businessHoursArray.append(datePicker.date)
            }
        }else if !switchValueOne, switchValueTwo{
            for datePicker in businessHoursDatePickers[2...3] {
                businessHoursArray.append(datePicker.date)
            }
        }
        return businessHoursArray
    }
    
    //BusinessHours畫面設定
    func setBusinessHours(businessHoursArray: Array<Date>?) {
        guard let businessHoursArray = businessHoursArray,
              !businessHoursArray.isEmpty else {
            for datePickerControlSwitch in datePickerControlSwitchs {
                datePickerControlSwitch.isOn = false
            }
            for businessHours in businessHoursDatePickers {
                businessHours.isEnabled = false
            }
            return
        }
        let count = businessHoursArray.count
        datePickerControlSwitchs[0].isOn = true
        for businessHours in businessHoursDatePickers[0...1] {
            businessHours.isEnabled = true
        }
        for businessHours in businessHoursDatePickers[2...3] {
            businessHours.isEnabled = false
        }
        if count == 4 {
            datePickerControlSwitchs[1].isOn = true
            for businessHours in businessHoursDatePickers {
                businessHours.isEnabled = true
            }
        }
        for (i, businessHours) in businessHoursArray.enumerated() {
            businessHoursDatePickers[i].date = businessHours
        }
    }
    
    //按return收鍵盤
    @IBAction func dismissKeyboard(_ sender: Any) {
    }
    
    //手勢點空白處收鍵盤
    @objc func dismissKeyboardForTap(){
        self.view.endEditing(true)
    }
    
    //按下儲存
    @IBAction func buttonPressed(_ sender: Any) {
        //收鍵盤
        view.endEditing(true)
        guard nameTextField.text?.isEmpty == false else {
            let controller = UIAlertController(title: "請輸入餐廳名稱", message: "餐廳名稱為必須輸入", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return
        }
        
        let name = nameTextField.text ?? ""
        let address = addressTextView.text
        let phoneNumber = phoneTextField.text
        let websiteURL = websiteTextField.text
        let businessHours = getBusinessHours()
        let closedTime = closedTimeTextField.text
        let remark = remarkTextView.text
        var newFoodPhotoNames = [String]()
        for _ in foodPhotoImages {
            newFoodPhotoNames.append(UUID().uuidString)
        }
        
        restaurant = Restaurant(name: name, photoNames: newFoodPhotoNames, score: score, area: nil, address: address, phoneNumber: phoneNumber, website: websiteURL, businessHours: businessHours, closed: closedTime, remark: remark)
        
        activityIndicatorView.startAnimating()
        self.view.window?.isUserInteractionEnabled = false
        delegate?.update(restaurant: restaurant, foodPhotos: foodPhotoImages)
        
        let queue = DispatchQueue(label: "com.savephoto.sam")
        queue.async { [self] in
            do {
                try Restaurant.savePhotoToFile(foodPhotos: foodPhotoImages, photoNames: restaurant.photoNames, deletePhotoNames: oldFoodPhotoNames)
            } catch {
                print("照片儲存失敗！")
                DispatchQueue.main.async {
                    let controller = UIAlertController(title: "⚠️照片存擋失敗！", message: nil, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    controller.addAction(okAction)
                    present(controller, animated: true, completion: nil)
                }
            }
            DispatchQueue.main.async {
                activityIndicatorView.stopAnimating()
                self.view.window?.isUserInteractionEnabled = true
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func unwindToBigPhoto(_ unwindSegue: UIStoryboardSegue) {
        if let sourceViewController = unwindSegue.source as? BigPhotoViewController,
           let item = sourceViewController.item{
            let indexPath = IndexPath(item: item, section: 0)
            foodPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            pageControl.currentPage = item
        }
        
        // Use data from the view controller which initiated the unwind segue
    }
    
    // MARK: - Table view data source

    //設定section footer 文字
//    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        if section == 0 {
//            if foodPhotoImages.isEmpty {
//                return "共0張"
//            }else{
//                return "共\(foodPhotoImages.count)張"
//            }
//        }else{
//            return ""
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0, !(foodPhotoImages.isEmpty) {
//            if foodPhotoImages.isEmpty {
//                return 5
//            }else{
//                return 13
//            }
//        }else{
//            return 5
//        }
//    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentBigPhoto" {
            let controller = segue.destination as? BigPhotoViewController
            controller?.photos = foodPhotoImages
            controller?.item = sender as? Int
        }
    }
    

}

//Collection
extension AddModifyTableViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = foodPhotoImages.count
            
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count > 1)
        
        if count == 0 {
            photoButtonView.isHidden = false
            for barButton in photoBarButtonItems {
                barButton.tintColor = UIColor.clear
                barButton.isEnabled = false
            }
        }else{
            photoButtonView.isHidden = true
            for barButton in photoBarButtonItems {
                barButton.tintColor = nil
                barButton.isEnabled = true
            }
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FoodPhotoCollectionViewCell.self)", for: indexPath) as? FoodPhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setButtonCorner()
        cell.deletePhotoButton.tag = indexPath.item
        cell.foodPhotoImageView.image = foodPhotoImages[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if foodPhotoImages.isEmpty == false {
            performSegue(withIdentifier: "presentBigPhoto", sender: indexPath.item)
        }
    }
    
    //collectionViewCell大小設定
    func configureCollectionViewCellSize() {
        let flowLayout = foodPhotoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = foodPhotoCollectionView.bounds.width
        let height = foodPhotoCollectionView.bounds.height
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
    }
    
}

//選照片相關
extension AddModifyTableViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let itemProviders = results.map(\.itemProvider)
        
        for itemProvider in itemProviders where itemProvider.canLoadObject(ofClass: UIImage.self) {
            //此動作在背景執行
            itemProvider.loadObject(ofClass: UIImage.self) { [self] image, error in
                //切回main thread
                DispatchQueue.main.async { [self] in
                    guard let image = image as? UIImage else {return}
                    let fixImage = image.fixOrientation()
                    foodPhotoImages.append(fixImage)
                    //更新collection content
                    let indexPath = IndexPath(item: foodPhotoImages.count - 1, section: 0)
                    foodPhotoCollectionView.insertItems(at: [indexPath])
                    //scrolling到最後加入的item
                    foodPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                    pageControl.currentPage = pageControl.numberOfPages - 1
//                    var content = tableView.footerView(forSection: 0)?.defaultContentConfiguration()
//                    content?.secondaryText = "共\(foodPhotoImages.count)張"
//                    tableView.footerView(forSection: 0)?.contentConfiguration = content
                }

            }
            
        }
        
    }
    
}

//拍照相關
extension AddModifyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
            let fixImage = image.fixOrientation()
            foodPhotoImages.append(fixImage)
            let indexPath = IndexPath(item: foodPhotoImages.count - 1, section: 0)
            foodPhotoCollectionView.insertItems(at: [indexPath])
            foodPhotoCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            pageControl.currentPage = pageControl.numberOfPages - 1
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
    
}

//textView return dismissKeyBoard
extension AddModifyTableViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//delegate
protocol AddModifyTableViewControllerDelegate {
    func update(restaurant: Restaurant, foodPhotos: [UIImage])
}

enum ActionType {
    case Add
    case Update
}

extension UIImage {
    //修復圖片旋轉
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
         
        var transform = CGAffineTransform.identity
         
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
             
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
             
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
             
        default:
            break
        }
         
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        default:
            break
        }
         
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
         
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
             
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
         
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
         
        return img
    }
}
