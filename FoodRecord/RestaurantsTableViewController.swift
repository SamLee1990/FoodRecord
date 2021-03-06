//
//  RestaurantsTableViewController.swift
//  FoodRecord
//
//  Created by ζδΈζ on 2021/7/19.
//

import UIKit
import CoreData

class RestaurantsTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    //CoreData
    let app = UIApplication.shared.delegate as! AppDelegate
    lazy var context = app.persistentContainer.viewContext
    
    var restaurants = [Restaurant]()
    var rowForUpdateDelete: Int!
    
    lazy var filterRestaurants = restaurants
    var filterRows = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        registerForInsertUpdateDeleteNotification()
        //CoreData
        queryRestaurantData()
        
    }
    
    func setupSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(filterRestaurants.isEmpty){
            return filterRestaurants.count
        }else{
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !(filterRestaurants.isEmpty){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as? RestaurantsTableViewCell else { return UITableViewCell() }
            let row = indexPath.row
            cell.setInfo(with: filterRestaurants[row])

            return cell
        }else{
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsEmptyCell", for: indexPath) as? RestaurantsEmptyTableViewCell else { return UITableViewCell() }
            
            return emptyCell
        }
    }
    
    //open add controller
    @IBSegueAction func showAddTableViewController(_ coder: NSCoder) -> AddModifyTableViewController? {
        let controller = AddModifyTableViewController(coder: coder)
        
        controller?.app = app
        controller?.context = context
//        controller?.delegate = self
        controller?.actionType = .Add
        
        return controller
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchController.searchBar.resignFirstResponder()
        if let row = tableView.indexPathForSelectedRow?.row,
           let controller = segue.destination as? DetailTableViewController {
            let restaurant = filterRestaurants[row]
            controller.app = app
            controller.context = context
            controller.restaurant = restaurant
            rowForUpdateDelete = row
//            controller.delegate = self
        }
        
    }
    
}

//SearchController
extension RestaurantsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.isEmpty == false {
            filterRestaurants.removeAll()
            filterRows.removeAll()
            for (i, restaurant) in restaurants.enumerated() {
                if restaurant.name.localizedStandardContains(searchText) {
                    filterRestaurants.append(restaurant)
                    filterRows.append(i)
                }
            }
        } else {
            filterInit()
        }
        tableView.reloadData()
    }
    
    func filterInit() {
        filterRestaurants = restaurants
        filterRows.removeAll()
    }
    
}

//for insert update delete Notification
extension RestaurantsTableViewController {
    
    func registerForInsertUpdateDeleteNotification() {
        var name = NSNotification.Name("insertRestaurantNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(insertRow(_:)), name: name, object: nil)
        
        name = NSNotification.Name("updateRestaurantNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(updateRow(_:)), name: name, object: nil)
        
        name = NSNotification.Name("deleteRestaurantNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteRow(_:)), name: name, object: nil)
    }
    
    @objc func insertRow(_ notification: Notification) {
        guard let info = notification.userInfo,
        let restaurant = info["restaurant"] as? Restaurant else { return }
        
        restaurants.insert(restaurant, at: 0)
        filterInit()
        if searchController.isActive {
            searchController.isActive = false
        }else{
            tableView.reloadData()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    @objc func updateRow(_ notification: Notification) {
        guard let info = notification.userInfo,
        let restaurant = info["restaurant"] as? Restaurant else { return }
        
        var row: Int
        if filterRows.isEmpty {
            row = rowForUpdateDelete
        } else {
            row = filterRows[rowForUpdateDelete]
        }
        restaurants[row] = restaurant
        filterRestaurants[rowForUpdateDelete] = restaurant
        let indexPath = IndexPath(row: rowForUpdateDelete, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    @objc func deleteRow(_ notification: Notification) {
        var row: Int
        if filterRows.isEmpty {
            row = rowForUpdateDelete
        } else {
            row = filterRows[rowForUpdateDelete]
            filterRows.remove(at: rowForUpdateDelete)
        }
        restaurants.remove(at: row)
        filterRestaurants.remove(at: rowForUpdateDelete)
        if !filterRestaurants.isEmpty{
            let indexPath = IndexPath(row: rowForUpdateDelete, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else{
            tableView.reloadData()
        }
    }
    
}

//CoreData
extension RestaurantsTableViewController {
    
    //θ?ε CoreData ζζι€ε»³θ³ζ
    func queryRestaurantData() {
        do {
            let results = try context.fetch(RestaurantData.fetchRequest())
            for result in results {
                let uuid = result.uuid!
                let name = result.name!
                let score = Int(result.score)
                let address = result.address
                let phone = result.phone
                let website = result.website
                let closed = result.closeday
                let remark = result.remark
                var photos = Array<UIImage>()
                let sort = NSSortDescriptor(key: "num", ascending: true)
                let resultPhotos = result.photos?.sortedArray(using: [sort]) as! Array<PhotoData>
                if resultPhotos.count != 0 {
                    for photo in resultPhotos {
                        if let photoData = photo.photo,
                           let image = UIImage(data: photoData) {
                            photos.append(image)
                        }
                    }
                }
                var businessHours = Array<Date>()
                let resultBHours = result.businesshours?.sortedArray(using: [sort]) as! Array<BusinessHoursData>
                if resultBHours.count != 0 {
                    for hours in resultBHours {
                        if let hour = hours.hour {
                            businessHours.append(hour)
                        }
                    }
                }
                
                let restaurant = Restaurant(uuid: uuid, name: name, photos: photos, score: score, address: address, phoneNumber: phone, website: website, businessHours: businessHours, closed: closed, remark: remark)
                restaurants.append(restaurant)
            }
            restaurants.reverse()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /*
    //ζ°ε’ι€ε»³
    func insertRestaurantData(restaurant: Restaurant) {
        let resData = RestaurantData(context: context)
        resData.uuid = restaurant.uuid
        resData.name = restaurant.name
        resData.score = Int16(restaurant.score)
        resData.address = restaurant.address
        resData.phone = restaurant.phoneNumber
        resData.website = restaurant.website
        resData.closeday = restaurant.closed
        resData.remark = restaurant.remark
        //ζ°ε’η§ηθηζ₯­ζι
        if let bHours = restaurant.businessHours {
            for (i, bHour) in bHours.enumerated() {
                let bHoursData = BusinessHoursData(context: context)
                bHoursData.num = Int16(i)
                bHoursData.hour = bHour
                resData.addToBusinesshours(bHoursData)
            }
        }
        for (i, photo) in restaurant.photos.enumerated() {
            let photoData = PhotoData(context: context)
            photoData.num = Int16(i)
            photoData.photo = photo.jpegData(compressionQuality: 0.7)
            resData.addToPhotos(photoData)
        }
        app.saveContext()
        print("ζ°ε’ι€ε»³ \(restaurant.name) ζε")
    }
    
    //εͺι€ι€ε»³
    func deleteRestaurantData(uuid: UUID) {
        let fetchRequest: NSFetchRequest = RestaurantData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
                app.saveContext()
                print("εͺι€ι€ε»³ζε")
            }
        } catch {
            print(error)
        }
    }
    
    //ζ΄ζ°ι€ε»³
    func updateRestaurantData(restaurant: Restaurant) {
        let fetchRequest:NSFetchRequest = RestaurantData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", restaurant.uuid as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                result.name = restaurant.name
                result.score = Int16(restaurant.score)
                result.address = restaurant.address
                result.phone = restaurant.phoneNumber
                result.website = restaurant.website
                result.closeday = restaurant.closed
                result.remark = restaurant.remark
                //εͺι€η§ηθηζ₯­ζι
                for photo in result.photos as! Set<PhotoData> {
                    context.delete(photo)
                }
                for hours in result.businesshours as! Set<BusinessHoursData> {
                    context.delete(hours)
                }
                //ζ°ε’η§ηθηζ₯­ζι
                if let bHours = restaurant.businessHours {
                    for (i, bHour) in bHours.enumerated() {
                        let bHoursData = BusinessHoursData(context: context)
                        bHoursData.num = Int16(i)
                        bHoursData.hour = bHour
                        result.addToBusinesshours(bHoursData)
                    }
                }
                for (i, photo) in restaurant.photos.enumerated() {
                    let photoData = PhotoData(context: context)
                    photoData.num = Int16(i)
                    photoData.photo = photo.jpegData(compressionQuality: 0.7)
                    result.addToPhotos(photoData)
                }
                app.saveContext()
                print("ζ΄ζ°ι€ε»³ \(restaurant.name) ζε")
            }
        } catch {
            print(error)
        }
    }
 */
    
}
