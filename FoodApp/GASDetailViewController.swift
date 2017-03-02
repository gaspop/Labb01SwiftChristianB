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
    
}

class GASDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textInformation: UITextView!
    @IBOutlet weak var textValues: UITextView!
    
    var selected : [APIFood] = []
    
    //weak var tableView : GASTableViewController?
    
    var food : APIFood!
    //var input : String?
    var foodAsTableData : [(String,String)] = []
    
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
    
    func convertFoodToTableData() {
        if food.details != nil {
            foodAsTableData.append((APIFood.keyEnergy.0,"\(Int(food.energy))"))
            foodAsTableData.append((APIFood.keyProtein.0,"\(food.protein)"))
            foodAsTableData.append((APIFood.keySalt.0,"\(food.salt)"))
            foodAsTableData.append((APIFood.keyWater.0,"\(food.water)"))
            foodAsTableData.append((APIFood.keyHealth,"\(food.healthyness)"))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayFoodImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = food.name
        convertFoodToTableData()
        tableView.reloadData()
        //displayFoodDetails()
        // Do any additional setup after loading the view.
        
        //detailTableView.add
    }
    
    func displayFoodImage() {
        if let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
        } else {
            NSLog("Failed to load image from: \(imagePath)")
        }
    }
    
    func displayFoodDetails() {
        if food.details != nil {
            textInformation.text = "Energivärde:\n\nProtein:\nSalt:\nVatten:"
            textValues.text = "\(Int(food.energy))\n\n\(food.protein)\n\(food.salt)\n\(food.water)"
        } else {
            textInformation.text = ""
            textValues.text = ""
            food.getDetails {
                print("Food item missing details; retrieving...")
                self.displayFoodDetails()
            }
        }
    }

    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        print("Blepp")
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
        // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                let url = URL(fileURLWithPath: imagePath)
                try data.write(to: url)
                NSLog("Done writing image data to file: \(imagePath)")
            }
            catch let error {
                NSLog("Failed to save data: \(error)")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
        return foodAsTableData.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GASDetailTableViewCell
        
        cell.labelName.text = foodAsTableData[indexPath.row].0
        cell.labelValue.text = foodAsTableData[indexPath.row].1
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // Default is 1 if not implemented
        return 1
    }
    
    /*
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Blepp"
     // fixed font style. use custom view (UILabel) if you want something different
    }
    */
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "compare",
           let target = segue.destination as? GASCompareViewController {
            target.data.append(food)
            target.data.append(contentsOf: selected.filter( { f in f.number != food.number } ) )
        }
        
    }
    

}
