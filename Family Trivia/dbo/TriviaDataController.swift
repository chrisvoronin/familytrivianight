//
//  TriviaDataController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class TriviaDataController: NSObject {

    static let shared = TriviaDataController()
    
    private let dao = TriviaDao()
    
    func getCategoriesWithGames() -> [SearchCategory] {
        
        let catList:[SearchCategory] = dao.getAllCategories()
        let boards:[Board] = dao.getAllGames()

        // create index map
        var catIndexDict:[Int:Int] = [:]
        for (index, category) in catList.enumerated() {
            catIndexDict[category.categoryId] = index
        }
        
        // iterate using index map to avoid nested loops
        for board in boards {
            if (board.flags != Board.flagUserCreated) {
                let index = catIndexDict[board.categoryId]!
                catList[index].games.append(board)
            }
        }
        
        return catList
    }
    
    func getGame(forId: Int) -> Board? {
        return dao.getGameForId(gameId: forId)
    }
    
    func getUserCreatedGames() -> [Board] {
        return dao.getGamesWithFlag(flag: Board.flagUserCreated)
    }
    
    func fillGameCategoriesAndQuestions(game:Board) {
        
        let groups = dao.getQuestionGroups(gameId: game.gameId)
        let questionList = dao.getQuestions(gameId: game.gameId)
        
        game.groups = groups
        
        // they should be sorted in right order here.
        for question in questionList {
            game.groups[question.groupId].questions.append(question)
        }
    }
    
//    func updateGame(_ board:Board) {
//        dao.updateBoard(board)
//    }
//
//    func deleteGame(forId: Int) {
//        dao.deleteBoard(boardId: forId)
//    }
//
//    @discardableResult
//    func createGame(_ board:Board) -> Bool {
//        let result = dao.createGame(board)
//        return result
//    }
//
//    @discardableResult
//    func updateGroup(_ group:QuestionGroup) -> Bool {
//        return dao.updateGroup(group)
//    }
//
//    @discardableResult
//    func updateQuestion(_ question:Question) -> Bool {
//        return dao.updateQuestion(question)
//    }
}
