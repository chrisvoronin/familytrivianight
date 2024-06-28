//
//  GameModel.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class Board {

    public static let flagForChildren:Int = 1
    public static let flagPremium:Int = 2
    public static let flagUserCreated:Int = 8
    
    var icon:String = ""
    var name:String = ""
    var boardDescription:String = ""
    var createdDate:Date?
    var gameId:Int = 0
    var difficulty:Int = 0
    var categoryId:Int = 0
    var flags:Int = 0
    var groups:[QuestionGroup] = []    
    var isMyGame = false
    
    func getTitles() -> [String] {
        
        var titles:[String] = []
        for group in groups {
            titles.append(group.name)
        }
        return titles
    }
    
    func isComplete() -> Bool {
        for group in self.groups {
            for question in group.questions {
                if (question.state == .New) {
                    return false
                }
            }
        }
        return true
    }
    
    func questionCount(forState:QuestionState) -> Int {
        var count = 0
        for group in self.groups {
            for question in group.questions {
                if (question.state == forState) {
                    count += 1
                }
            }
        }
        return count
    }
}
