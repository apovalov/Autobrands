//
//  Models.swift
//  Automobiles
//
//  Created by Macbook on 26.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import Foundation

struct BrandContainer: Codable {
    var data: [Brand]
}

struct ModelContainer: Codable  {
    var data: [Model]
}

struct Brand: Codable {
    var id: String
    var brandName: String
    var founderNames: [String]
    var foundationDate: String
    var brandModels: [Model]! = []
    
    init(brand: Brand, models: [Model]) {
        self.id = brand.id
        self.brandName = brand.brandName
        self.founderNames = brand.founderNames
        self.foundationDate = brand.foundationDate
        
        let mods = models.filter{$0.brandId == brand.id}
        self.brandModels = mods
    }
}

struct Model: Codable {
    var brandId: String
    var modelName: String
    var releaseDate: String
}


