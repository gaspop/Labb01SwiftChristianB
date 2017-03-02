//
//  GASCompareViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-28.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
import GraphKit
//import Diagram

class GASCompareViewController: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    var chart1 : GASFoodChart!
    var data : [APIFood] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chart1 = GASFoodChart(frame: chartView.frame)
        chart1.data = data
        chart1.dataSource = chart1
        
        //chart1.marginBar = 0.0
        //chart1.barWidth = 10.0
        //chart1.barWidth = chart1.frame.width / CGFloat(chart1.numberOfBars() + 1)
        //chart1.barHeight = chart1.frame.height
        
        chartView.addSubview(chart1)
        chart1.draw()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        //
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
