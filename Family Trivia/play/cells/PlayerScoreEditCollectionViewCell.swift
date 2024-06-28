//
//  PlayerScoreEditCollectionViewCell.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class PlayerScoreEditCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "playerScoreEdit"
    
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var label: UILabel!
}
