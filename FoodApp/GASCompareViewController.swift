//
//  GASCompareViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-28.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit
//import Diagram

class GASCompareViewController: UIViewController {

    @IBOutlet weak var diagram: Diagram!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        diagram.update()
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
