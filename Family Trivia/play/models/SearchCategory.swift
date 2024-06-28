//
//  SearchCategory.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class SearchCategory {

    var categoryId:Int
    var title:String
    var icon:String!
    var flags:Int!
    var games:[Board] = []
    
    init(categoryId:Int, title:String) {
        self.categoryId = categoryId
        self.title = title
    }
}
