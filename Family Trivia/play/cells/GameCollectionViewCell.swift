//
//  GameCollectionViewCell.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/14/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "gamecell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}
