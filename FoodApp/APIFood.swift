//
//  Food.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-21.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class APIFood {
    
    private var _data : [String:Any]
    private(set) var data : [String:Any] {
        get {
            return _data
        }
        set(value) {
            _data = value
        }
    }
    
    var name : String {
        return data["name"] as! String
    }
    var number : Int {
        return Int(data["number"] as! Float)
    }
    var details : [String:Any]? {
        if let detailData = data["nutrientValues"] as? [String:Any] {
            return detailData
        } else {
            return nil
        }
    }
    var detailsRequestSent : Bool = false
    
    var isFavourite : Bool {
        return UserData.favouritesIDs.contains(number)
    }
    
    // OBS! Annat tillvägagångsätt med Float?
    // Bör samtliga värden vara optionals ifall något inte finns?
    
    // Ska det vara energyKj eller energyKcal ?
    var energy : Float {
        return details!["energyKcal"] as! Float
    }
    var protein : Float {
        return details!["protein"] as! Float
    }
    var salt : Float {
        return details!["salt"] as! Float
    }
    var water : Float {
        return details!["water"] as! Float
    }
    
    init (data: [String:Any]) {
        _data = data
    }
    
    func toggleFavouriteStatus() {
        if !isFavourite {
            UserData.addAsFavourite(food: self)
        } else {
            UserData.removeAsFavourite(food: self)
        }
    }
    
    /* FRÅGA ERIK OM FÖLJANDE
    //
    func getDetails (closure: @escaping (Bool, @escaping () -> Void) -> Void) {
        if !detailsRequestSent {
            detailsRequestSent = true
            //print("getItemDetails for: \(number) (\(name))")
            closure(true) {
                APIParser.getItemDetails(number: self.number) {
                    output in
                    self.details = output["nutrientValues"] as? [String:Any]
                }
            }
        }
    }*/
    
    func getDetails (closure: @escaping () -> Void) {
        if !detailsRequestSent {
            detailsRequestSent = true
            //print("getItemDetails for: \(number) (\(name))")
            getItem(number: self.number) {
                newData in
                self.data = newData
                closure()
            }
        }
    }
    
}
