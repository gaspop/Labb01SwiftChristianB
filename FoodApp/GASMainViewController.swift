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
    
    var searchFieldOrigin : CGPoint {
        return CGPoint(x: self.viewSearchWrapper.center.x,
                       y: self.viewLogoContainer.frame.height
                          + (self.viewSearchContainer.frame.height / 2))
    }
    var searchFieldGap : Float = 0.0
    
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
        
        //var y = UIKeyboardFrameBeginUserInfoKey
    }
    

    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text {
            UserData.lastSearchWord = text
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        //viewSearchWrapper.center = searchFieldOrigin
        print("Reset searchField position.")
        /*resetSearchField()
        if (textSearchField.isEditing) {
            positionSearchField()
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserData.favouritesIDs.count > 0 {
            barButtonFavourites.isEnabled = true
        } else {
            barButtonFavourites.isEnabled = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFieldGap = Float(labelSearchFeedback.center.y) - Float(viewSearchWrapper.center.y)
        textSearchField.text = UserData.lastSearchWord
        // Do any additional setup after loading the view.
        
        if let navBarItems = navigationItem.rightBarButtonItems {
            var urk = navBarItems
            print("GNAPP \(urk)")
            urk.removeAll()
            print("BLEP \(urk)")
        }
    }
    
    func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                viewSearchWrapper.center = CGPoint(x: viewSearchWrapper.center.x,
                                                   y: (viewBackground.frame.height - keyboardSize.height) / 2)
                labelSearchFeedback.center = CGPoint(x: labelSearchFeedback.center.x,
                                                     y: viewSearchWrapper.center.y + CGFloat(searchFieldGap))
            } else {
                // no UIKeyboardFrameBeginUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        viewSearchWrapper.center = CGPoint(x: viewSearchWrapper.center.x,
                                           y: viewLogoContainer.frame.height
                                              + (viewSearchContainer.frame.height / 2))
        labelSearchFeedback.center = CGPoint(x: labelSearchFeedback.center.x,
                                             y: viewSearchWrapper.center.y + CGFloat(searchFieldGap))
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
