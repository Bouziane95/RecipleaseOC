//
//  ApiModel.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 30/10/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation


class ApiModel{
    
    let apiKey = "48239141c2c8b5ceb8a13bfb7731b1c0"
    let appId = "5584b270"
    
    func fetchResult(_ ingredients: [Ingredients], completion: @escaping (Recipe?) -> Void){
        
        var searchQuery = ""
        for ingredient in ingredients{
            searchQuery.append(ingredient.name!)
            searchQuery.append(",")
        }
        //searchQuery.removeLast()
        let urlRecipe = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(appId)&app_key=\(apiKey)&from=0&to=10"
        let url = URL(string: urlRecipe)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {completion(nil); return}
            do{
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(jsonObject)
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let recipe = try decoder.decode(Recipe.self, from: jsonData)
                completion(recipe)
            } catch{
                print(error)
                completion(nil)
            }
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
