//
//  GASDetailViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-14.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASDetailTableViewCell : UITableViewCell {
    
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var labelValue : UILabel!
    
    func setLabels(name: String, value: String) {
        labelName.text = name
        labelValue.text = value
    }
    
}

class GASDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageCamera: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textInformation: UITextView!
    @IBOutlet weak var textValues: UITextView!
    
    @IBOutlet weak var buttonFavourite: UIButton!
    @IBOutlet weak var buttonPhoto: UIButton!
    @IBOutlet weak var buttonCompare: UIButton!
    
    
    var selected : [APIFood] = []
    var food : APIFood!
    
    let imageDirectory = "/FoodApp/"
    var imageName : String {
        return "food\(food.number).png"
    }
    var imagePath : String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let documentsDirectory = paths.first {
            return documentsDirectory.appending("/\(imageName)")
        } else {
            fatalError("No documents directory.")
        }
    }
    
    @IBAction func compare(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "compare", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayFoodImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = food.name
        tableView.reloadData()
        
        setButtonFavouriteStatus()
        setButtonCompareStatus()
        
        let image = UIImage(named: "cameraIcon")?.withRenderingMode(.alwaysTemplate)
        imageCamera.image = image
        imageCamera.tintColor = UIColor.gray
    }
    
    @IBAction func pressButtonFavourite(_ sender: UIButton) {
        food.toggleFavouriteStatus()
        setButtonFavouriteStatus()
    }
    
    @IBAction func pressButtonPhoto(_ sender: UIButton) {
        selectImage()
    }
    
    @IBAction func pressButtonCompare(_ sender: UIButton) {
        performSegue(withIdentifier: "compare", sender: sender)
    }
    
    
    func setButtonFavouriteStatus() {
        if food.isFavourite {
            setButtonImage(button: buttonFavourite, image: "heartIcon", color: UIColor.red)
        } else {
            setButtonImage(button: buttonFavourite, image: "heartIcon", color: UIColor.white)
        }
    }
    
    func setButtonCompareStatus() {
        var canCompare = true
        if selected.count == 1 && food.isInArray(selected) >= 0 {
            canCompare = false
        } else if selected.count == 6 && food.isInArray(selected) < 0 {
            canCompare = false
        } else if selected.count == 0 {
            canCompare = false
        }
        
        if canCompare {
            buttonCompare.isEnabled = true
            setButtonImage(button: buttonCompare, image: "scalesIcon", color: UIColor.white)
        } else {
            buttonCompare.isEnabled = false
            setButtonImage(button: buttonCompare, image: "scalesIcon", color: UIColor.gray)
        }
    }
    
    func displayFoodImage() {
        if let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
        } else {
            // Failed
        }
    }

    func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        } else {
            fatalError("No source type.")
        }
        
        present(picker,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                let url = URL(fileURLWithPath: imagePath)
                try data.write(to: url)
            }
            catch {
                // Failed
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if food.details != nil {
            return 5
        } else {
            return 0
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASDetailTableViewCell
        
        switch indexPath.row {
            
        case 0: cell.setLabels(name: APIFood.keyEnergy, value: "\(Int(food.energy))")
        case 1: cell.setLabels(name: APIFood.keyAlcohol, value: "\(food.alcohol)")
        case 2: cell.setLabels(name: APIFood.keySalt, value: "\(food.salt)")
        case 3: cell.setLabels(name: APIFood.keyWater, value: "\(food.water)")
        case 4: cell.setLabels(name: APIFood.keyHealth, value: "\(food.healthyness)")
            
        default: cell.setLabels(name: "", value: "")
            
        }
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "compare",
           let target = segue.destination as? GASCompareViewController {
            if food.isInArray(selected) >= 0 {
                target.selected = selected
            } else {
                var insertedSelected = selected
                insertedSelected.insert(food, at: 0)
                target.selected = insertedSelected
            }
        }
        
    }
    

}
