//
//  ButtonTilesCollectionDS.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/20/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol ButtonTilesCollectionDSDelegate {
    func onTitleSelected(at:IndexPath)
}

class ButtonTilesCollectionDS: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var titles:[String] = []
    public var delegate:ButtonTilesCollectionDSDelegate!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as! ButtonCollectionViewCell
        
        let title = titles[indexPath.row]
        cell.button.setTitle(title, for: .normal)
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(onButtonClick(_:)), for: .primaryActionTriggered)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @objc func onButtonClick(_ button:UIButton) {
        
        let indexPath = IndexPath(row: button.tag, section: 0)
        delegate.onTitleSelected(at: indexPath)
    }

}
