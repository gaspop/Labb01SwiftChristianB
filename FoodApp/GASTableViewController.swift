//
//  GASTableViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-14.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASTableViewCell : UITableViewCell {
    
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    var food : Food!
    
}

class GASTableViewController: UITableViewController, UISearchResultsUpdating {

    var searchController : UISearchController!
    
    var data : [Food] = []
    var searchData : [Food] = []
    var dataCount : Int {
        if tableMode == Mode.Normal {
            return data.count
        } else if tableMode == Mode.Search {
            return searchData.count
        } else {
            return 0
        }
    }
    
    var sentRequests : Int = 0
    var checkedRangeMin : Int = 0
    var checkedRangeMax : Int = 0
    var lastRowIndex : Int = 0
    let rowRange : Int = 20

    enum Mode {
        case Normal, Search
    }
    
    var previousTableMode : Mode = Mode.Normal
    
    var tableMode : Mode {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                return Mode.Normal
            }
        } else {
            return Mode.Normal
        }
        return Mode.Search
    }
    
    func resetTableRange() {
        checkedRangeMin = 0
        checkedRangeMax = 0
        lastRowIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASTableViewCell
        
        if (previousTableMode != tableMode) {
            resetTableRange()
        }
        
        if tableMode == Mode.Normal {
            cell.food = data[row]
        } else if tableMode == Mode.Search {
            cell.food = searchData[row]
        }
        
        if row <= checkedRangeMin {
            checkedRangeMin = max(0, row - rowRange)
            requestDetailsWithRange(checkedRangeMin, row)
            print("up range")
        }
        if row >= checkedRangeMax {
            checkedRangeMax = min(row + rowRange, dataCount - 1)
            requestDetailsWithRange(row, checkedRangeMax)
            print("down range")
        }
        /*if indexPath.row >= lastRowIndex {
            print("lastRowIndex Before: \(lastRowIndex)  vs. \(indexPath.row + rowRange)" )
            requestDetailsWithRange(lastRowIndex, lastRowIndex + rowRange)
            lastRowIndex = min(lastRowIndex + rowRange, data.count - 1)
            print("lastRowIndex After: \(lastRowIndex)  vs. \(indexPath.row + rowRange)" )
        }*/

        cell.labelText.text = cell.food.name
        if cell.food.details != nil {
            cell.labelValue.text = "\(cell.food.protein)"
        } else {
            cell.labelValue.text = "-"
            /*self.data[indexPath.row].getDetails() {
                self.tableView.reloadData()
            }*/
        }
        
        previousTableMode = tableMode
        
        return cell
    }
    
    func requestDetailsWithRange(_ from: Int, _ to: Int) {
        let fromSafe : Int = max(0, from)
        let toSafe : Int = min(to, dataCount - 1)
        var fromData : [Food] = tableMode == Mode.Normal ? data : searchData
        
        for index in fromSafe...toSafe {
            fromData[index].getDetails() {
                param in
                /*if let requestSent = b as Bool? {
                    self.sentRequests += 1
                }*/
                /*if param.0 {
                    param.1()
                }*/
                if (index == toSafe) {
                    self.tableView.reloadData()
                }
            }
        }
        print("requestDetailWithRange: \(fromSafe) to \(toSafe)")
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
        
        if segue.identifier == "detailSegue",
           let target = segue.destination as? GASDetailViewController,
           let row = tableView.indexPathForSelectedRow?.row {
            target.input = data[row].name
        }

    }

}
