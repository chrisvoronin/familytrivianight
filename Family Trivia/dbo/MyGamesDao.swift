//
//  MyGamesDao.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/31/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class MyGamesDao: NSObject {

    public static let maxGameId = 10
    
    func buildKey(_ gameId:Int) -> String {
        return "game\(gameId)"
    }
    
    func getAllGames() -> [Board] {
        var results:[Board] = []
        for i in 1...MyGamesDao.maxGameId {
            let board = getGame(i)
            if board != nil {
                results.append(board!)
            }
        }
        return results
    }
    
    func getGame(_ gameId: Int) -> Board? {
        let key = buildKey(gameId)
        let store = NSUbiquitousKeyValueStore.default
        if let dict = store.dictionary(forKey: key) {
            return dictToBoard(dict)
        }
        return nil
    }
    
    func removeGame(_ gameId: Int) {
        let key = buildKey(gameId)
        let store = NSUbiquitousKeyValueStore.default
        store.removeObject(forKey: key)
        store.synchronize()
    }
    
    @discardableResult
    func setGame(_ board:Board) -> Bool {
        let key = buildKey(board.gameId)
        let dict = boardToDict(board)
        let store = NSUbiquitousKeyValueStore.default
        store.set(dict, forKey: key)
        let result = store.synchronize()
        return result
    }
    
    // MARK: To dictionary
    
    func boardToDict(_ board:Board) -> [String:Any] {
        
        var dict:[String:Any] = [:]
        dict["name"] = board.name
        dict["gameId"] = board.gameId
        dict["boardDescription"] = board.boardDescription
        dict["createdDate"] = board.createdDate
        dict["icon"] = board.icon
        dict["flags"] = board.flags
        dict["categoryId"] = board.categoryId
        dict["difficulty"] = board.difficulty
        
        var groupArray:[[String:Any]] = []
        for group in board.groups {
            let gDict = groupToDict(group)
            groupArray.append(gDict)
        }
        dict["groups"] = groupArray
        
        return dict
    }
    
    func groupToDict(_ group:QuestionGroup) -> [String:Any] {
        
        var gDict:[String:Any] = [:]
        gDict["groupId"] = group.groupId
        gDict["gameId"] = group.gameId
        gDict["name"] = group.name
        
        var qArray:[[String:Any]] = []
        for question in group.questions {
            let qDict = self.questionToDict(question)
            qArray.append(qDict)
        }
        gDict["questions"] = qArray
        
        return gDict
    }
    
    func questionToDict(_ question:Question) -> [String:Any] {
        
        var qDict:[String:Any] = [:]
        qDict["questionId"] = question.questionId
        qDict["gameId"] = question.gameId
        qDict["groupId"] = question.groupId
        qDict["flags"] = question.flags
        qDict["value"] = question.value
        qDict["question"] = question.question
        qDict["answer"] = question.answer
        qDict["image"] = question.image ?? ""
        qDict["custom1"] = question.custom1 ?? ""
        qDict["custom2"] = question.custom2 ?? ""
        qDict["custom3"] = question.custom3 ?? ""
        return qDict
    }
    
    // MARK: From Dictionary
    
    func dictToBoard(_ dict:[String:Any]) -> Board {
        
        let board = Board()
        board.gameId = dict["gameId"] as! Int
        board.name = dict["name"] as! String
        board.boardDescription = dict["boardDescription"] as! String
        board.createdDate = dict["boardDescription"] as? Date
        board.icon = dict["icon"] as! String
        board.flags = dict["flags"] as! Int
        board.categoryId = dict["categoryId"] as! Int
        board.difficulty = dict["difficulty"] as! Int
        
        let gArray = dict["groups"] as! [[String:Any]]
        for gDict in gArray {
            let group = dictToGroup(gDict)
            board.groups.append(group)
        }
        return board
    }
    
    func dictToGroup(_ dict:[String:Any]) -> QuestionGroup {
        let group = QuestionGroup()
        group.groupId = dict["groupId"] as! Int
        group.gameId = dict["gameId"] as! Int
        group.name = dict["name"] as! String
        group.questions = []
        let qArray = dict["questions"] as! [[String:Any]]
        for qDict in qArray {
            let question = dictToQuestion(qDict)
            group.questions.append(question)
        }
        return group
    }
    
    func dictToQuestion(_ dict:[String:Any]) -> Question {
        
        let question = Question()
        question.questionId = dict["questionId"] as! Int
        question.gameId = dict["gameId"] as! Int
        question.groupId = dict["groupId"] as! Int
        question.flags = dict["flags"] as! Int
        question.value = dict["value"] as! Int
        question.question = dict["question"] as! String
        question.answer = dict["answer"] as! String
        question.image = dict["image"] as? String
        question.custom1 = dict["custom1"] as? String
        question.custom2 = dict["custom2"] as? String
        question.custom3 = dict["custom3"] as? String
        return question
    }
    
}
