//
//  CollectionFlowGrid.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/14/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class CollectionFlowGrid: UICollectionViewFlowLayout {

    var rows:Int!
    var columns:Int!
    var spacing = CGFloat(2.0)
    
    var customItemSize:CGSize?
    
    convenience init(rows:Int, columns:Int) {
        self.init()
        self.rows = rows
        self.columns = columns
        self.minimumLineSpacing = spacing
        self.minimumInteritemSpacing = spacing
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top:0,left:0,bottom:0,right:0)
    }
    
    override var itemSize: CGSize {
        
        get {
            
            if (customItemSize == nil) {
                
                let itemWidth:CGFloat = (self.collectionView!.frame.size.width - (spacing * CGFloat(columns-1))) / CGFloat(columns)
                let itemHeight:CGFloat = (self.collectionView!.frame.size.height - (spacing * CGFloat(rows-1))) / CGFloat(rows)
                customItemSize = CGSize(width: itemWidth, height: itemHeight)
            }
            return customItemSize!
            
        }
        set {
            //customItemSize = newValue
        }
        
    }
    
    
}
