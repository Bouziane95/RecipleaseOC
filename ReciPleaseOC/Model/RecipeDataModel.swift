//
//  RecipeDataModel.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 30/10/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
struct RecipeDataModel: Codable{
    let recipeName : String
    let imageRecipe : String
    let cookingTime : Float
    let ingredientLines : [String]
    
    enum CodingKeys: String, CodingKey{
        case recipeName = "label"
        case imageRecipe = "image"
        case cookingTime = "yield"
        case ingredientLines = "ingredientLines"
    }
}
