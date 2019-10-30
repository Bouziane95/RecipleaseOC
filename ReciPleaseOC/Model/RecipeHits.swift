//
//  Recipe.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 30/10/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import Foundation
struct RecipeHits: Codable {
    let recipe : RecipeDataModel
    
    enum CodingKeys: String, CodingKey{
        case recipe
    }
}
