//
//  GASTableViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-14.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import BEMCheckBox

class GASTableViewCell : UITableViewCell, BEMCheckBoxDelegate {
    
    @IBOutlet weak var buttonSelect: BEMCheckBox!
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    weak var table : GASTableViewController!
    var food : APIFood!
    
    @IBAction func pressButtonFavourite(_ sender: UIButton) {
        food.toggleFavouriteStatus()
        setButtonFavouriteStatus()
        if (table.tableMode == .Favourites) {
            table.updateFavouritesData()
        }
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        toggleSelectedStatus()
    }
    
    func toggleSelectedStatus() {
        let index = food.isInArray(table.selected)
        if index >= 0 {
            table.selected.remove(at: index)
        } else {
            if table.selected.count < table.maxSelected {
                table.selected.append(food)
            }
        }
        setButtonSelectedStatus()
        table.setButtonCompareStatus()
    }
    
    func setButtonFavouriteStatus() {
        if food.isFavourite {
            setButtonImage(button: buttonFavourite, image: "heartIcon", color: UIColor.red)
        } else {
            setButtonImage(button: buttonFavourite, image: "heartIcon", color: UIColor.lightGray)
        }
    }
    
    func setButtonSelectedStatus() {
        if food.isInArray(table.selected) >= 0 {
            buttonSelect.on = true
        } else {
            buttonSelect.on = false
        }
    }
    
}

//TODO: Ska SearchController gå efter API-resultatet eller ska den filtrera beroende på om det eller favorit-listan?

class GASTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchController : UISearchController!

    @IBOutlet weak var barButtonFavourites: UIBarButtonItem!
    @IBOutlet weak var barButtonSelected: UIBarButtonItem!
    @IBOutlet weak var barButtonCompare: UIBarButtonItem!
    
    var data : [APIFood] = []
    var searchData : [APIFood] = []
    var _favouritesData : [APIFood]?
    var favouritesData : [APIFood] {
        if _favouritesData == nil || (tableMode == .Favourites && previousTableMode != .Favourites) {
            _favouritesData = UserData.favourites
        }
        return _favouritesData!
    }
    var tableData : [APIFood] {
        switch tableMode {
        case .Normal:       return data
        case .Search:       return searchData
        case .Favourites:   return favouritesData
        }
    }
    var tableDataCount : Int {
        return tableData.count
    }
    
    var checkedRangeMin : Int = 0
    var checkedRangeMax : Int = 0
    var lastRowIndex : Int = 0
    let rowRange : Int = 20
    
    let maxSelected : Int = 6
    var selected : [APIFood] = []
    var isSelecting : Bool = false
    
    enum Mode {
        case Normal, Search, Favourites
    }
    
    var previousTableMode : Mode = Mode.Normal
    var _tableMode : Mode = Mode.Normal
    var tableMode : Mode {
        get {
            if isSearching {
                return Mode.Search
            } else {
                return _tableMode
            }
        }
        set(mode) {
            _tableMode = mode
        }
    }
    
    var isSearching : Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }
    
    func resetTableRange() {
        checkedRangeMin = 0
        checkedRangeMax = 0
        lastRowIndex = 0
    }
    
    func updateFavouritesData() {
        _favouritesData = UserData.favourites
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setButtonCompareStatus()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
        if tableMode == .Favourites {
            barButtonFavourites.isEnabled = false
        }
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased() {
            searchData = data.filter( { item in item.name.lowercased().contains(searchText) } )
        } else {
            searchData = []
        }
        resetTableRange()
        tableView.reloadData()
    }
        
    @IBAction func toggleShowFavourites(_ sender: UIBarButtonItem) {
        if tableMode == .Normal {
            tableMode = .Favourites
        } else {
            tableMode = .Normal
        }
        resetTableRange()
        tableView.reloadData()
    }

    @IBAction func toggleSelectItems(_ sender: UIBarButtonItem) {
        isSelecting = !isSelecting
        tableView.reloadData()
    }
    
    @IBAction func pressButtonCompare(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "compare", sender: sender)
    }
    
    func setButtonCompareStatus() {
        barButtonCompare.isEnabled = selected.count > 1
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASTableViewCell
        cell.table = self
        cell.buttonSelect.delegate = cell
        
        if (previousTableMode != tableMode) {
            resetTableRange()
        }
        
        cell.food = tableData[row]

        if row <= checkedRangeMin + 8 {
            checkedRangeMin = max(0, row - rowRange)
            requestDetailsWithRange(checkedRangeMin, row)
        }
        if row >= checkedRangeMax - 8 {
            checkedRangeMax = min(row + rowRange, tableDataCount - 1)
            requestDetailsWithRange(row, checkedRangeMax)
        }

        cell.labelText.text = cell.food.name
        if cell.food.details != nil {
            cell.labelValue.text = "\(Int(cell.food.energy)) kcal"
        } else {
            cell.labelValue.text = "-"
        }
    
        if isSelecting {
            cell.buttonFavourite.isHidden = true
            cell.buttonSelect.isHidden = false
            cell.setButtonSelectedStatus()
        } else {
            cell.buttonFavourite.isHidden = false
            cell.buttonSelect.isHidden = true
            cell.setButtonFavouriteStatus()
        }
        
        previousTableMode = tableMode
        
        return cell
    }
    
    func requestDetailsWithRange(_ from: Int, _ to: Int) {
        let fromSafe : Int = max(0, from)
        let toSafe : Int = min(to, tableDataCount - 1)
        
        for index in fromSafe...toSafe {
            tableData[index].getDetails() {
                finished in
                self.tableView.reloadData()
            }
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        
        if segue.identifier == "showDetails",
           let target = segue.destination as? GASDetailViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            target.food = tableData[row]
            target.selected = selected
        } else if segue.identifier == "compare",
            let target = segue.destination as? GASCompareViewController {
            target.selected = selected
        }

    }

}
