//
//  GASMainViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-16.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASMainViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewLogoContainer: UIView!
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var viewSearchWrapper: UIView!
    @IBOutlet weak var textSearchField: UITextField!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var barButtonFavourites: UIBarButtonItem!
    
    @IBOutlet weak var labelSearchFeedback: UILabel!
    
    var searchResult : [APIFood] = []
    
    
    @IBAction func pressSearch(_ sender: UIButton) {
        search()
        //performSegue(withIdentifier: "tableViewSegue", sender: sender)
    }
    
    func resetSearchField() {
        self.viewSearchWrapper.center = CGPoint(x: self.viewSearchWrapper.center.x,
                                                y: self.viewLogoContainer.frame.height
                                                + (self.viewSearchContainer.frame.height / 2))
    }
    
    func positionSearchField() {
        self.viewSearchWrapper.center = CGPoint(x: self.viewSearchWrapper.center.x,
                                                y: self.viewLogoContainer.frame.height / 2)
    }
    
    @IBAction func textSearch(_ sender: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.positionSearchField()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        resetSearchField()
        if (textSearchField.isEditing) {
            positionSearchField()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.favouritesIDs.count > 0 {
            barButtonFavourites.isEnabled = true
        } else {
            barButtonFavourites.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func search() {
        if let word = textSearchField.text,
           word.characters.count > 0 {
            getSearchResult(word: word) {
                result in
                self.searchResult = []
                for item in result {
                    self.searchResult.append(APIFood(data: item))
                }
                if self.searchResult.count > 0 {
                    print("Search result count: \(self.searchResult.count)")
                    self.labelSearchFeedback.text = ""
                    self.performSegue(withIdentifier: "showSearchResult", sender: nil)
                } else {
                    self.labelSearchFeedback.text = "Inget resultat."
                }
            }
        } else {
            labelSearchFeedback.text = "Inget att söka efter."
        }
    }
    
    /*
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "tableViewSegue" {
            print("FLORF")
        }
    }*/

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showSearchResult",
            let target = segue.destination as? GASTableViewController {
            target.data = searchResult
        } else if segue.identifier == "showFavourites",
            let target = segue.destination as? GASTableViewController {
            target.data = []
            target.tableMode = .Favourites
        }
    }

}
