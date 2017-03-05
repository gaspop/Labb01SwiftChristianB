//
//  Food.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-21.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class APIFood {
    
    public static let keyName       = "Namn"
    public static let keyEnergy     = "Energivärde"
    public static let keyAlcohol    = "Alkohol"
    public static let keySalt       = "Salt"
    public static let keyWater      = "Vatten"
    public static let keyHealth     = "Nyttighetsvärde"
    
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
    
    var energy : Float {
        return details!["energyKcal"] as! Float
    }
    var alcohol : Float {
        return details!["alcohol"] as! Float
    }
    var salt : Float {
        return details!["salt"] as! Float
    }
    var water : Float {
        return details!["water"] as! Float
    }
    var healthyness : Float {
        return ((water + 1.0) / 10) / (salt + 1.0) * ((alcohol + 1.0) / 10)
    }
    
    init (data: [String:Any]) {
        _data = data
    }
    
    func getDetails (closure: @escaping () -> Void) {
        if !detailsRequestSent {
            detailsRequestSent = true
            getItem(number: self.number) {
                newData in
                self.data = newData
                closure()
            }
        }
    }
    
    func toggleFavouriteStatus() {
        if !isFavourite {
            UserData.addAsFavourite(food: self)
        } else {
            UserData.removeAsFavourite(food: self)
        }
    }
    
    func isInArray(_ array: [APIFood]) -> Int {
        for (i,f) in array.enumerated() {
            if self.number == f.number {
                return i
            }
        }
        return -1
    }
    
}
