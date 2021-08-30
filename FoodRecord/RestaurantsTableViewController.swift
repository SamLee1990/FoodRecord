//
//  RestaurantsTableViewController.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/7/19.
//

import UIKit

class RestaurantsTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    var restaurants = [Restaurant]()
    var restaurantPhotos = [UIImage]()
    var detailPhotos = [[UIImage]]()
    var rowForUpdateDelete: Int!
    
    lazy var filterRestaurants = restaurants
    lazy var filterRestaurantPhotos = restaurantPhotos
    lazy var filterDetailPhotos = detailPhotos
    var filterRows = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupRestaurantsInfo()

    }
    
    func setupSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupRestaurantsInfo() {
        //取得文字data
        if let restaurants = Restaurant.readRestaurantsFromFile(){
            self.restaurants = restaurants
        }
        //取得image
        for restaurant in restaurants {
            var detialPhoto = [UIImage]()
            for photoName in restaurant.photoNames {
                let url = Restaurant.documentsDirectory.appendingPathComponent(photoName)
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data){
                    detialPhoto.append(image)
                }
            }
            detailPhotos.append(detialPhoto)
        }
        restaurantPhotos = setRestaurantPhotos(detailPhotos: detailPhotos)
    }

    //設定此table畫面需要之圖片
    func setRestaurantPhotos(detailPhotos: [[UIImage]]) -> [UIImage] {
        var restaurantPhotos = [UIImage]()
        let defaultImage = UIImage(systemName: "questionmark.diamond")!
        for detailPhoto in detailPhotos {
            if detailPhoto.isEmpty {
                restaurantPhotos.append(defaultImage)
            }else{
                restaurantPhotos.append(detailPhoto[0])
            }
        }
        return restaurantPhotos
    }
    
    func filterInit() {
        filterRestaurants = restaurants
        filterRestaurantPhotos = restaurantPhotos
        filterDetailPhotos = detailPhotos
        filterRows.removeAll()
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
            cell.foodImageView.image = filterRestaurantPhotos[row]
            if filterRestaurantPhotos[row].isSymbolImage{
                cell.foodImageView.contentMode = .center
            }else{
                cell.foodImageView.contentMode = .scaleAspectFill
            }

            return cell
        }else{
            guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsEmptyCell", for: indexPath) as? RestaurantsEmptyTableViewCell else { return UITableViewCell() }
            
            return emptyCell
        }
    }
    
    //open add controller
    @IBSegueAction func showAddTableViewController(_ coder: NSCoder) -> AddModifyTableViewController? {
        let controller = AddModifyTableViewController(coder: coder)
        
        controller?.delegate = self
        controller?.actionType = .Add
        
        return controller
    }
    
    func saveErrorAlert() {
        let controller = UIAlertController(title: "⚠️資料存擋失敗！", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
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
        if let row = tableView.indexPathForSelectedRow?.row,
           let controller = segue.destination as? DetailTableViewController {
            let restaurant = filterRestaurants[row]
            controller.restaurant = restaurant
            controller.photoImages = filterDetailPhotos[row]
            rowForUpdateDelete = row
            controller.delegate = self
        }
        searchController.searchBar.resignFirstResponder()
    }
    
}

extension RestaurantsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, searchText.isEmpty == false {
            filterRestaurants.removeAll()
            filterRestaurantPhotos.removeAll()
            filterDetailPhotos.removeAll()
            filterRows.removeAll()
            for (i, restaurant) in restaurants.enumerated() {
                if restaurant.name.localizedStandardContains(searchText) {
                    filterRestaurants.append(restaurant)
                    filterRestaurantPhotos.append(restaurantPhotos[i])
                    filterDetailPhotos.append(detailPhotos[i])
                    filterRows.append(i)
                }
            }
        } else {
            filterInit()
        }
        tableView.reloadData()
    }
    
}

//for add
extension RestaurantsTableViewController: AddModifyTableViewControllerDelegate{
    
    func update(restaurant: Restaurant, foodPhotos: [UIImage]) {
        restaurants.insert(restaurant, at: 0)
        detailPhotos.insert(foodPhotos, at: 0)
        restaurantPhotos = setRestaurantPhotos(detailPhotos: detailPhotos)
        do {
            try Restaurant.saveToFile(restaurants: restaurants)
        } catch {
            print("資料存擋失敗!")
            saveErrorAlert()
        }
        filterInit()
        if searchController.isActive {
            searchController.isActive = false
        }else{
            tableView.reloadData()
        }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
}

//for update and delete
extension RestaurantsTableViewController: DetailTableViewControllerDelegate{
    
    func updateRow(restaurant: Restaurant, foodPhotos: [UIImage]) {
        var row: Int
        if filterRows.isEmpty {
            row = rowForUpdateDelete
        } else {
            row = filterRows[rowForUpdateDelete]
        }
        restaurants[row] = restaurant
        detailPhotos[row] = foodPhotos
        restaurantPhotos = setRestaurantPhotos(detailPhotos: detailPhotos)
        filterRestaurants[rowForUpdateDelete] = restaurant
        filterDetailPhotos[rowForUpdateDelete] = foodPhotos
        filterRestaurantPhotos = setRestaurantPhotos(detailPhotos: filterDetailPhotos)
        do {
            try Restaurant.saveToFile(restaurants: restaurants)
        } catch {
            print("資料存擋失敗!")
            saveErrorAlert()
        }
        let indexPath = IndexPath(row: rowForUpdateDelete, section: 0)
        tableView.reloadData()
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    func deleteRow() {
        var row: Int
        if filterRows.isEmpty {
            row = rowForUpdateDelete
        } else {
            row = filterRows[rowForUpdateDelete]
            filterRows.remove(at: rowForUpdateDelete)
        }
        restaurants.remove(at: row)
        detailPhotos.remove(at: row)
        restaurantPhotos = setRestaurantPhotos(detailPhotos: detailPhotos)
        filterRestaurants.remove(at: rowForUpdateDelete)
        filterDetailPhotos.remove(at: rowForUpdateDelete)
        filterRestaurantPhotos = setRestaurantPhotos(detailPhotos: filterDetailPhotos)
        do {
            try Restaurant.saveToFile(restaurants: restaurants)
        } catch  {
            print("資料存擋失敗!")
            saveErrorAlert()
        }
        if !filterRestaurants.isEmpty{
            let indexPath = IndexPath(row: rowForUpdateDelete, section: 0)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else{
            tableView.reloadData()
        }
    }
    
}
