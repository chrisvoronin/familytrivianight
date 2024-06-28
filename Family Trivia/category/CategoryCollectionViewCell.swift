//
//  CategoryCollectionViewCell.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    public static let reuseIdentifier = "category"
    
    @IBOutlet weak var premiumIcon: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
}
