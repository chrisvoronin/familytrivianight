//
//  GameTitlesDataSource.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class GameTitlesDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var titles:[String]
    var highlightIndex:[IndexPath] = []
    
    required init(titles:[String]) {
        self.titles = titles
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as! GameCollectionViewCell
        cell.imageView.isHidden = true
        cell.label.text = self.titles[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.label.backgroundColor = UIColor.clear
        
        if (shouldHighlight(ip: indexPath)) {
            cell.label.textColor = UIColor.FamilyTrivia.title
        } else {
            cell.label.textColor = UIColor.white
        }
        
        return cell
    }
    
    func shouldHighlight(ip: IndexPath) -> Bool {
        for index in highlightIndex {
            if (index.row == ip.row && index.section == ip.section) {
                return true
            }
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}
