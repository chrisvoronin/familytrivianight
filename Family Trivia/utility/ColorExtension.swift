//
//  ColorExtension.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/29/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

extension UIColor {
    
    struct FamilyTrivia {
        static let title = UIColor(named:"titleColor")!
        static let background = UIColor(named:"backgroundColor")!
        static let tvColor = UIColor(named: "tvColor")!
    }
    
    static func imageFromColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
