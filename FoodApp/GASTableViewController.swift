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
    
}

class GASTableViewController: UITableViewController {

    let food = [["name": "Banan", "value": 30],
                ["name": "Hamburgare", "value": 60],
                ["name": "Toalettborste", "value": 25]
                ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return food.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASTableViewCell

        if let name = food[indexPath.row]["name"] as? String {
            cell.labelText.text = name
        }
        if let value = food[indexPath.row]["value"] as? Int {
            cell.labelValue.text = "\(value)"
        }
        return cell
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
            if let name = food[row]["name"] as? String {
                target.input = name
            }
        }
        
        /*
        if segue.identifier == "detailSegue" {
            if let target = segue.destination as? GASDetailViewController {
                if let row = tableView.indexPathForSelectedRow?.row {
                    if let name = food[row]["name"] as? String {
                        target.input = name
                    }
                }
            }
        }
         */
    }

}