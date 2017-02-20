//
//  GASFoodParser.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-20.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class FoodParser {

    let baseURL : String = "http://www.matapi.se/foodstuff?query="
    var lastError : String = ""
    var data : [[String:Any]]?
    
    // Fråga Erik: Kan man få en funktion att returnera ett Async block
    func searchFor(word: String, action: @escaping() -> ()) {
    
        if let urlString = ("\(baseURL)\(word)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request) {
                (unwrappedData: Data?, response: URLResponse?, error: Error?) in
                
                if let data = unwrappedData {
                    let jsonOptions = JSONSerialization.ReadingOptions()
                    do {
                        if let food = try JSONSerialization.jsonObject(with: data, options: jsonOptions) as? [[String:Any]] {
                            self.data = food
                            DispatchQueue.main.async {
                                action()
                            }
                        }
                    }
                    catch let error {
                        print(error)
                    }
                } else {
                    self.lastError = "Kunde inte hämta data."
                }
            }
            task.resume()
            
        }
    }
    
    func dataNameAtIndex(_ index: Int) -> String {
        if let food = self.data,
           let name = food[index]["name"] as? String {
                return name
        } else {
            return "-"
        }
    }
    
    func dataNumberAtIndex(_ index: Int) -> Float {
        if let food = self.data,
            let number = food[index]["number"] as? Float {
            return number
        } else {
            return 0.0
        }
    }
    
}
