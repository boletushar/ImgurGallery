//
//  AlertError.swift
//  MHFA
//
//  Created by Tushar on 12/7/18.
//  Copyright © 2018 com.infosys. All rights reserved.
//

import Foundation
import UIKit

class AlertError {
    
    static func showMessage(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
