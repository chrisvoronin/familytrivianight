//
//  Player.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class Player {

    var name:String
    var score:Int
    
    required init(name:String) {
        self.name = name
        self.score = 0
    }
    
    convenience init(name:String, score:Int) {
        self.init(name: name)
        self.score = score
    }
}
