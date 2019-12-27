//
//  File.swift
//  Automobiles
//
//  Created by Macbook on 26.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import UIKit

class CellsHeaderView: UIView {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var founderLabel: UILabel!
    @IBOutlet weak var sinceDateLabel: UILabel!
    
    
    //MARK: - Header customization with user data
    
    func set(with brand: Brand) {
        self.brandLabel.text = brand.brandName
        self.founderLabel.text = brand.founderNames.first
        self.sinceDateLabel.text = brand.foundationDate
    }
}
