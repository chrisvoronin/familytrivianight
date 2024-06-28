//
//  CategoryRowCollectionDataSource.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol CategoryRowCollectionDelegate {
    func onCategorySelected(board:Board)
}

class CategoryRowCollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var data:[Board]
    var delegate:CategoryRowCollectionDelegate
    
    required init(data:[Board], delegate:CategoryRowCollectionDelegate) {
        self.data = data
        self.delegate = delegate
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.imageView.image = UIImage(named: model.icon)
        cell.imageView.adjustsImageWhenAncestorFocused = true
        cell.imageView.clipsToBounds = false
        cell.imageView.contentMode = .scaleToFill
        cell.label.text = model.name
        let isPremium = (model.flags == Board.flagPremium)
        cell.premiumIcon.isHidden = !isPremium
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let board = self.data[indexPath.row]
        self.delegate.onCategorySelected(board: board)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        return CGSize(width: height * 1.5, height: height)
    }
}

