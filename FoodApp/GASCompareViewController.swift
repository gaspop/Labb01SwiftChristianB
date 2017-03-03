//
//  GASCompareViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-28.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import GraphKit
import BEMCheckBox
//import Diagram

class GASCompareTableViewCell : UITableViewCell {
    
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var buttonSelect: BEMCheckBox!
    
    var food : APIFood!
    
}

class GASCompareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonEnergy: UIButton!
    @IBOutlet weak var buttonAlcohol: UIButton!
    @IBOutlet weak var buttonSalt: UIButton!
    @IBOutlet weak var buttonWater: UIButton!
    @IBOutlet weak var buttonHealthyness: UIButton!
    
    var tupleEnergy, tupleAlcohol, tupleSalt, tupleWater, tupleHealthyness : (UIButton, String)!
    
    @IBOutlet weak var chartView: UIView!
    
    var chart : GASFoodChart!
    var data : [APIFood] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tupleEnergy = (buttonEnergy, "energyIcon")
        tupleAlcohol = (buttonAlcohol, "alcoholIcon")
        tupleSalt = (buttonSalt, "saltIcon")
        tupleWater = (buttonWater, "waterIcon")
        tupleHealthyness = (buttonHealthyness, "healthIcon")
        
        deselectButtons()

        chart = GASFoodChart(frame: chartView.frame)
        chart.data = data
        chart.dataSource = chart
        
        chartView.addSubview(chart)
        chart.draw()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        chart.frame = chartView.frame
        chart.draw()
    }
    
    func deselectButtons() {
        let buttonImageTuples : [(UIButton,String)] = [
            tupleEnergy, tupleAlcohol, tupleSalt, tupleWater, tupleHealthyness
        ]
        
        for b in buttonImageTuples {
            let image = UIImage(named: b.1)?.withRenderingMode(.alwaysTemplate)
            b.0.setImage(image, for: .normal)
            b.0.tintColor = UIColor.darkGray
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
        // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
        //return foodAsTableData.count
        return data.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASCompareTableViewCell
        
        cell.food = data[indexPath.row]
        cell.labelName.text = cell.food.name
        //cell.labelValue.text = foodAsTableData[indexPath.row].1
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // Default is 1 if not implemented
        return 1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
