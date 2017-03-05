//
//  GASMainViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-16.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASMainViewController: UIViewController {

    @IBOutlet weak var barButtonFavourites: UIBarButtonItem!
    
    @IBOutlet weak var imageFalling1: UIImageView!
    @IBOutlet weak var imageFalling2: UIImageView!
    @IBOutlet weak var imageFalling3: UIImageView!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewLogoContainer: UIView!
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var viewSearchWrapper: UIView!
    @IBOutlet weak var textSearchField: UITextField!
    @IBOutlet weak var buttonSearch: UIButton!
    
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    
    var searchResult : [APIFood] = []
    
    var searchFieldGap : Float = 0.0
    
    var messageTimer = Timer()
    var messageIsShowing : Bool = false
    var messageIsMoving : Bool = false
    let messageMoveTime : Double = 0.5
    let messageAppearanceTime : Double = 3.0
    
    @IBAction func pressSearch(_ sender: UIButton) {
        search()
    }

    @IBAction func searchTextChanged(_ sender: UITextField) {
        if let text = sender.text {
            UserData.lastSearchWord = text
        }
    }
    
    func getRandomFallingPoint() -> CGPoint {
        let x : Int = Int(arc4random_uniform(UInt32(view.frame.width)))
        let y : Int = -64 - Int(arc4random_uniform(UInt32(32)))
        return CGPoint(x: x, y: y)
    }
    
    func getRandomGravityMagnitude() -> CGFloat {
        return CGFloat(Float(Float(arc4random_uniform(3)+1) / 10.0))
    }
    
    func getRandomTimeInterval() -> TimeInterval {
        return TimeInterval(4.0 + Float(arc4random_uniform(2)))
    }
    
    func setRandomImage(_ view: UIImageView) {
        var imageName = ""
        let rnd = arc4random_uniform(3)
        switch rnd {
        case 0: imageName = "foodApple"
        case 1: imageName = "foodBanana"
        case 2: imageName = "foodFish"
        default: imageName = "foodApple"
        }
        
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        view.image = image
    }
    
    func rotateFallingObject(_ view: UIImageView) {
        view.transform = CGAffineTransform(rotationAngle: 0)
        UIView.animate(withDuration: getRandomTimeInterval()) {
            view.transform = CGAffineTransform(rotationAngle: 3.14)
        }
    }
    
    func setupFallingObjects() {
        let dynamic1 = UIDynamicAnimator(referenceView: view)
        let dynamic2 = UIDynamicAnimator(referenceView: view)
        let dynamic3 = UIDynamicAnimator(referenceView: view)
        let gravity1 = UIGravityBehavior(items: [imageFalling1])
        let gravity2 = UIGravityBehavior(items: [imageFalling2])
        let gravity3 = UIGravityBehavior(items: [imageFalling3])
        let tupleFalling1 = (dynamic1, gravity1, imageFalling1)
        let tupleFalling2 = (dynamic2, gravity2, imageFalling2)
        let tupleFalling3 = (dynamic3, gravity3, imageFalling3)
        let tupleGravity = [tupleFalling1, tupleFalling2, tupleFalling3]
        for tuple in tupleGravity {
            tuple.2.center = getRandomFallingPoint()
            tuple.1.magnitude = getRandomGravityMagnitude()
            tuple.0.addBehavior(tuple.1)
            Timer.scheduledTimer(withTimeInterval: getRandomTimeInterval(), repeats: true) {
                finished in
                tuple.0.removeBehavior(tuple.1)
                tuple.2.center = self.getRandomFallingPoint()
                self.rotateFallingObject(tuple.2)
                self.setRandomImage(tuple.2)
                tuple.0.addBehavior(tuple.1)
            }
        }
        
    }
    
    func alignMessage() {
        viewMessage.frame = viewSearchWrapper.frame
        labelMessage.frame = viewMessage.frame
        viewMessage.center = CGPoint(x: viewSearchWrapper.center.x,
                                     y: viewMessage.center.y)
        labelMessage.center = CGPoint(x: labelMessage.frame.width / 2, y: labelMessage.frame.height / 2)
    }
    
    func positionMessage() {
        viewMessage.center = CGPoint(x: viewMessage.center.x,
                                     y: viewSearchWrapper.center.y + CGFloat(searchFieldGap))
    }
    
    func showMessage(_ message: String) {
        labelMessage.text = message
        viewMessage.isHidden = false
        messageIsShowing = true
        if messageTimer.isValid {
            messageTimer.invalidate()
        }
        if !messageIsMoving {
            messageIsMoving = true
            UIView.animate(withDuration: messageMoveTime, animations: {
                self.viewMessage.alpha = 1.0
                self.positionMessage()
            }) { finished in
                self.messageIsMoving = false
                self.messageTimer = Timer.scheduledTimer(withTimeInterval: self.messageAppearanceTime, repeats: false) {
                    finished in
                    self.hideMessage()
                }
            }
        }
    }
    
    func hideMessage() {
        messageIsMoving = true
        UIView.animate(withDuration: messageMoveTime, animations: {
            self.viewMessage.center = CGPoint(x: self.viewMessage.center.x,
                                              y: self.viewBackground.frame.height + self.viewMessage.frame.height)
            self.viewMessage.alpha = 0.0
        }) { finished in
            self.messageIsMoving = false
            self.viewMessage.isHidden = true
            self.messageIsShowing = false
            self.labelMessage.text = ""
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        barButtonFavourites.isEnabled = UserData.favouritesIDs.count > 0

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFallingObjects()
        
        searchFieldGap = Float(viewSearchWrapper.frame.height) + 8.0
        textSearchField.text = UserData.lastSearchWord
        labelMessage.text = ""
        alignMessage()
        
        viewMessage.center = CGPoint(x: viewMessage.center.x,
                                     y: viewBackground.frame.height + viewMessage.frame.height)
        hideMessage()

    }
    
    func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                viewSearchWrapper.center = CGPoint(x: viewSearchWrapper.center.x,
                                                   y: (viewBackground.frame.height - keyboardSize.height) / 2)
                if messageIsShowing {
                    positionMessage()
                }
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
        if messageIsShowing {
            positionMessage()
        }
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
                    self.performSegue(withIdentifier: "showSearchResult", sender: nil)
                } else {
                   self.showMessage("Inget resultat.")
                }
            }
        } else {
            showMessage("Inget att söka efter.")
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
