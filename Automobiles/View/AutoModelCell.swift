//
//  AutoModelCell.swift
//  Automobiles
//
//  Created by Macbook on 26.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import UIKit

class AutoModelCell: UITableViewCell {
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    static let reuseId = "AutoModelCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    ///  Cell customization with user data
    func set(with model: Model!) {
        guard let model = model else { return }
        self.modelLabel.text = model.modelName
        self.dateLabel.text = model.releaseDate
    }
    
}
