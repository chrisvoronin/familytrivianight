//
//  AlertUtility.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/23/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class AlertUtility: NSObject {
    
    static func showAlert(from:UIViewController, title:String?, message:String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        from.present(alert, animated: true, completion: nil)
    }
}
