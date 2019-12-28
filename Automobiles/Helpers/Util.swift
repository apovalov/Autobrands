//
//  Util.swift
//  Automobiles
//
//  Created by Macbook on 28.12.2019.
//  Copyright © 2019 Valentin Shapovalov. All rights reserved.
//

import UIKit

class Util {
    
    ///Presenting `UIAlertController` on `UIViewController` with possible action processing
    class func addAlert(parent: UIViewController, title: String?, message: String?, successString: String = "Ок", success:@escaping ()->() = { }) {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

         alertController.addAction(UIAlertAction(title: successString, style: .default, handler: { (action) in
             success()
         }))
         parent.present(alertController, animated: true, completion: nil)
     }
}
