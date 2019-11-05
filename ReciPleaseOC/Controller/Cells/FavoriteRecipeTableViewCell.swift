//
//  FavoriteRecipeTableViewCell.swift
//  ReciPleaseOC
//
//  Created by Bouziane Bey on 04/11/2019.
//  Copyright © 2019 Bouziane Bey. All rights reserved.
//

import UIKit

class FavoriteRecipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var favoriteRecipeTitle: UILabel!
    @IBOutlet weak var favoriteRecipeIngredients: UILabel!
    @IBOutlet weak var favoriteRecipeTime: UILabel!
    @IBOutlet weak var favoriteRecipeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
