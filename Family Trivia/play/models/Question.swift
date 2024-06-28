//
//  Question.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

enum QuestionState: Int {
    case New = 0
    case Answered = 1
}

class Question {
    var questionId:Int = 0
    var gameId:Int = 0
    var groupId:Int = 0
    var flags:Int = 0
    var value:Int = 0
    var question:String = ""
    var answer:String = ""
    var image:String?
    var custom1:String?
    var custom2:String?
    var custom3:String?
    var state:QuestionState = .New
}
