//
//  GameMaker.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class GameMaker: NSObject {
    
    public func makeGame(board:Board, numPlayers:Int) -> LiveGame {
        
        // build teams
        var players:[Player] = []
        for index in 1...numPlayers {
            let player = Player(name: "Team \(index)")
            players.append(player)
        }
        
        // fill in details
        if (board.isMyGame) {
            for group in board.groups {
                for question in group.questions {
                    question.state = .New
                }
            }
        } else {
            TriviaDataController.shared.fillGameCategoriesAndQuestions(game: board)
        }
        
        // return results
        return LiveGame(board: board, players: players)
    }
    
    public func copyBoard(board:Board) -> Board {
        let copy = Board()
        copy.gameId = board.gameId
        copy.name = board.name
        copy.boardDescription = board.boardDescription
        copy.createdDate = board.createdDate
        copy.icon = board.icon
        copy.categoryId = board.categoryId
        copy.difficulty = board.difficulty
        copy.flags = board.flags
        
        copy.groups.append(contentsOf: board.groups)
        return copy
    }
    
    public func initNewGameBoard(name:String, gameId:Int) -> Board {
        
        let board = Board()
        board.gameId = gameId
        board.name = name
        board.boardDescription = ""
        board.createdDate = Date()
        board.icon = "play"
        board.categoryId = 0
        board.difficulty = 0
        board.flags = Board.flagUserCreated
        
        for groupId in 0...4 {
            let group = QuestionGroup()
            group.gameId = gameId
            group.groupId = groupId
            group.name = "Trivia \(groupId)"
            board.groups.append(group)
            
            for questionId in 0...4 {
                let question = Question()
                question.gameId = gameId
                question.questionId = questionId
                question.groupId = groupId
                question.value = (questionId+1) * 100
                group.questions.append(question)
            }
        }
        
        return board
    }
    
    public func initQuestionStateForEditingIn(_ board:Board) {
        
        for group in board.groups {
            for question in group.questions {
                
                if (question.question.count > 0
                    && question.answer.count > 0) {
                    question.state = .Answered
                } else {
                    question.state = .New
                }
            }
        }
    }
    
}
