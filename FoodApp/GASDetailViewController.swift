//
//  GASDetailViewController.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-14.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import UIKit

class GASDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textInformation: UITextView!
    @IBOutlet weak var textValues: UITextView!
    
    weak var tableView : GASTableViewController?
    
    var food : APIFood!
    var input : String?
    
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
        //tableView?.isSelecting = true
        //navigationController!.popViewController(animated: true)
        //dismiss(animated: true)
        //print("Blep")
        performSegue(withIdentifier: "compare", sender: sender)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        displayFoodImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelName.text = food.name
        displayFoodDetails()
        // Do any additional setup after loading the view.
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        var target = segue.destination as! GASTableViewController
        target = self.tableView!
        target.isSelecting = true
        */
    }
    

}
