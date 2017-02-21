//
//  Food.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-21.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class Food {
    
    let name : String
    let number : Int
    var details : [String:Any]?
    var protein : Float {
        return details?["protein"] as! Float
    }
    var salt : Float {
        return details?["salt"] as! Float
    }
    var water : Float {
        return details?["water"] as! Float
    }
    
    init (data: [String:Any]) {
        print("New Food with data:\n\(data)")
        if let name = data["name"] as? String {
            self.name = name
        } else {
            name = ""
        }
        
        if let number = data["number"] as? Float {
            self.number = Int(number)
        } else {
            number = 0
        }
    }
    
    func getDetails (closure: @escaping () -> Void) {
        APIParser.getItemDetails(number: number) {
            output in
            self.details = output["nutrientValues"] as? [String:Any]
            closure()
        }
    }
    
}
