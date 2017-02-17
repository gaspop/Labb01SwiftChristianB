//
//  GASMainViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-16.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASMainViewController: UIViewController {

    @IBOutlet weak var viewSearchWrapper: UIView!
    @IBOutlet weak var viewLogoContainer: UIView!
    @IBOutlet weak var textSearchField: UITextField!
    
    func positionSearchField() {
        self.viewSearchWrapper.center = CGPoint(x: self.viewSearchWrapper.center.x,
                                                y: self.viewSearchWrapper.center.y
                                                    - self.viewSearchWrapper.center.y
                                                    - (self.viewLogoContainer.frame.height / 2))
    }
    
    @IBAction func textSearch(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) {
            //self.viewSearchWrapper.center = CGPoint(x: self.viewSearchWrapper.center.x, y: 50 - self.viewLogoContainer.frame.size.height)
            self.positionSearchField()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if (textSearchField.isEditing) {
            positionSearchField()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
