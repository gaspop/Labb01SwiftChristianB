//
//  GASApiParser.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-02-20.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import Foundation

//class APIParser {

let baseURL : String = "http://www.matapi.se/foodstuff"
let jsonOptions = JSONSerialization.ReadingOptions()

func contactAPI(query: String, closure:@escaping (Data) -> Void) {
    
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

func getDataOfType<T>(query: String, closure: @escaping(T) -> Void) {
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

func getSearchResult(word: String, closure: @escaping([[String:Any]]) -> Void) {
    getDataOfType(query: "?query=\(word)", closure: closure)
}

func getItem(number: Int, closure: @escaping([String:Any]) -> Void) {
    getDataOfType(query: "/\(number)", closure: closure)
}

//}
