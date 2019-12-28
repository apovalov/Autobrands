//
//  Nib.swift
//  Automobiles
//
//  Created by Macbook on 27.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import UIKit


extension UIView {
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self ), owner: nil, options: nil)![0] as! T
    }
}
