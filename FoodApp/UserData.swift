//
//  UserData.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-24.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

private let keyFavouritesIDs = "favouritesIDs"
private let keyFavourites = "favourites"
private let keyColor = "color"

private let keySearchWord = "searchWord"

class UserData {
    
    static var lastSearchWord : String {
        get {
            let defaults = UserDefaults()
            if let data = defaults.object(forKey: keySearchWord) as? String {
                return data
            } else {
                return ""
            }
        }
        set(word) {
            let defaults = UserDefaults()
            defaults.set(word, forKey: keySearchWord)
            defaults.synchronize()
        }
    }

    
    static var favouritesIDs : [Int] {
        let defaults = UserDefaults()
        if let data = defaults.object(forKey: keyFavouritesIDs) as? [Int] {
            return data
        } else {
            return []
        }
    }
    
    static var favourites : [APIFood] {
        let data : [[String:Any]] = favouritesAsDictionaries
        var newData : [APIFood] = []
        for item in data {
            newData.append(APIFood(data: item))
        }
        return newData
    }
    
    private static var favouritesAsDictionaries : [[String:Any]] {
        let defaults = UserDefaults()
        if let data = defaults.object(forKey: keyFavourites) as? [[String:Any]] {
            return data
        } else {
            return []
        }
    }
    
    static func addAsFavourite(food: APIFood) {
        let defaults = UserDefaults()
        var newFavouritesData = favouritesAsDictionaries
        newFavouritesData.append(food.data)
        defaults.set(newFavouritesData, forKey: keyFavourites)
        
        var newFavouritesIDs = favouritesIDs
        newFavouritesIDs.append(food.number)
        defaults.set(newFavouritesIDs, forKey: keyFavouritesIDs)
        
        defaults.synchronize()
    }
    
    static func removeAsFavourite(food: APIFood) {
        let defaults = UserDefaults()
        var newFavouritesData = favouritesAsDictionaries
        newFavouritesData = newFavouritesData.filter( { Int($0["number"] as! Float) != food.number} )
        defaults.set(newFavouritesData, forKey: keyFavourites)
        
        var newFavouritesIDs = favouritesIDs
        print("ID Old:\n\(newFavouritesIDs)")
        newFavouritesIDs = newFavouritesIDs.filter( { $0 != food.number } )
        print("ID New:\n\(newFavouritesIDs)")
        defaults.set(newFavouritesIDs, forKey: keyFavouritesIDs)
        
        defaults.synchronize()
    }
    
}
