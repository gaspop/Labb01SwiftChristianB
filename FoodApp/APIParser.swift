//
//  GASApiParser.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-20.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

class APIParser {

    static let baseURL : String = "http://www.matapi.se/foodstuff"
    static let jsonOptions = JSONSerialization.ReadingOptions()
    
    static func contactAPI(query: String, closure:@escaping (Data) -> Void) {
        
        if let urlString = ("\(baseURL)\(query)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) {
                (data: Data?, response: URLResponse?, error: Error?) in
                
                if let unwrappedData = data {
                    closure(unwrappedData)
                } else {
                    print("Kunde inte hämta data.")
                }
            }
            task.resume()
            
        }
        
    }
    
    static func getDataOfType<T>(query: String, closure: @escaping(T) -> Void) {
        contactAPI(query: query) {
            do {
                if let result = try JSONSerialization.jsonObject(with: $0, options: jsonOptions) as?  T {
                    DispatchQueue.main.async {
                        closure(result)
                    }
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    
    static func getSearchResult(word: String, closure: @escaping([[String:Any]]) -> Void) {
        getDataOfType(query: "?query=\(word)", closure: closure)
    }
    
    static func getItemDetails(number: Int, closure: @escaping([String:Any]) -> Void) {
        print("getItemDetails for: \(number)")
        getDataOfType(query: "/\(number)", closure: closure)
    }

    /*
    static func getSearchResult2(word: String, closure: @escaping([[String:Any]]) -> Void) {
        getGeneralSearchResult(word: word, closure: closure)
    }
    
    static func getDetailResult2(word: String, closure: @escaping([String:Any]) -> Void) {
        getGeneralSearchResult(word: word, closure: closure)
    }
    
    static func getGeneralSearchResult<T>(word: String, closure: @escaping(T) -> Void) {
        getDataFromAPI(query: "?query=\(word)") {
            do {
                if let result = try JSONSerialization.jsonObject(with: $0, options: jsonOptions) as?  T {
                    DispatchQueue.main.async {
                        //print("getSearchResult(word: \(word))  Results: \(result.count)")
                        //print((result))
                        closure(result)
                    }
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    */
    
    static func getNameFromData(_ data: [String:Any]) -> String {
        if let name = data["name"] as? String {
                return name
        } else {
            return "-"
        }
    }
    
    static func getNumberFromData(_ data: [String:Any]) -> Float {
        if let number = data["number"] as? Float {
            return number
        } else {
            return 0
        }
    }
    
}
