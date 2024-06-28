//
//  ButtonCollectionViewCell.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/20/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "buttonCell"
    public static let nibName = "ButtonCollectionViewCell"
    
    @IBOutlet weak var button: UIButton!
}
