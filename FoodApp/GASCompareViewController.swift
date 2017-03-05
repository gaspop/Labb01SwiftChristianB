//
//  GASCompareViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-28.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import GraphKit

func setButtonImage(button: UIButton, image: String, color: UIColor) {
    let newImage = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
    button.setImage(newImage, for: .normal)
    button.tintColor = color
}

class GASCompareTableViewCell : UITableViewCell {
    
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var buttonColor: UIButton!
    
    var food : APIFood!
    
}

class GASCompareViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buttonEnergy: UIButton!
    @IBOutlet weak var buttonAlcohol: UIButton!
    @IBOutlet weak var buttonSalt: UIButton!
    @IBOutlet weak var buttonWater: UIButton!
    @IBOutlet weak var buttonHealthyness: UIButton!
    
    @IBOutlet weak var chartView: UIView!
    
    var chart : GASFoodChart!
    var selected : [APIFood] = []
    
    var tupleEnergy, tupleAlcohol, tupleSalt, tupleWater, tupleHealthyness : (UIButton, String)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tupleEnergy = (buttonEnergy, "energyIcon")
        tupleAlcohol = (buttonAlcohol, "alcoholIcon")
        tupleSalt = (buttonSalt, "saltIcon")
        tupleWater = (buttonWater, "waterIcon")
        tupleHealthyness = (buttonHealthyness, "healthIcon")

        chart = GASFoodChart(frame: chartView.frame)
        chart.data = selected
        chart.dataSource = chart
        chart.colors = [UIColor.yellow,
                        UIColor.orange,
                        UIColor.red,
                        UIColor.purple,
                        UIColor.blue,
                        UIColor.green]
        
        chartView.addSubview(chart)
        
        selectEnergy(buttonEnergy)
    }
    
    @IBAction func selectEnergy(_ sender: UIButton) {
        deselectButtons()
        setButtonImage(button: tupleEnergy.0, image: tupleEnergy.1, color: UIColor.white)
        chart.returnValue = { return NSNumber(integerLiteral: Int($0.energy)) }
        chart.maxValue = 1000.0
        chart.draw()
    }
    
    @IBAction func selectAlcohol(_ sender: UIButton) {
        deselectButtons()
        setButtonImage(button: tupleAlcohol.0, image: tupleAlcohol.1, color: UIColor.white)
        chart.returnValue = { return NSNumber(floatLiteral: Double($0.alcohol)) }
        chart.maxValue = 100.0
        chart.draw()
    }
    
    @IBAction func selectSalt(_ sender: UIButton) {
        deselectButtons()
        setButtonImage(button: tupleSalt.0, image: tupleSalt.1, color: UIColor.white)
        chart.returnValue = { return NSNumber(floatLiteral: Double($0.salt)) }
        chart.maxValue = 100.0
        chart.draw()
    }
    
    @IBAction func selectWater(_ sender: UIButton) {
        deselectButtons()
        setButtonImage(button: tupleWater.0, image: tupleWater.1, color: UIColor.white)
        chart.returnValue = { return NSNumber(floatLiteral: Double($0.water)) }
        chart.maxValue = 100.0
        chart.draw()
    }
    
    @IBAction func selectHealthyness(_ sender: UIButton) {
        deselectButtons()
        setButtonImage(button: tupleHealthyness.0, image: tupleHealthyness.1, color: UIColor.white)
        chart.returnValue = { return NSNumber(floatLiteral: Double($0.healthyness)) }
        chart.maxValue = 25.0
        chart.draw()
    }
    
    func deselectButtons() {
        let buttonImageTuples : [(UIButton,String)] = [
            tupleEnergy, tupleAlcohol, tupleSalt, tupleWater, tupleHealthyness
        ]
        
        for b in buttonImageTuples {
            setButtonImage(button: b.0, image: b.1, color: UIColor.gray)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selected.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASCompareTableViewCell
        
        cell.food = selected[indexPath.row]
        cell.labelName.text = cell.food.name
        setButtonImage(button: cell.buttonColor, image: "circleIcon", color: chart.colors[indexPath.row % chart.colors.count])
        
        return cell
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
