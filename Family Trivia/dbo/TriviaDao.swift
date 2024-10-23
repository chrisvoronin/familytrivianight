//
//  TriviaDao.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit
import FMDB

class TriviaDao: NSObject {
    //Bundle.main.resourceURL?.appendingPathComponent("trivia.sqlite")
    let database:FMDatabase = FMDatabase(url: Bundle.main.url(forResource: "trivia", withExtension: "sqlite"))
    
    func setVersion(_ version:Int) {
        guard database.open() else {
            print("Unable to open database")
            return
        }
        database.userVersion = UInt32(version)
        database.close()
    }
    
    func getVersion() -> Int {
        guard database.open() else {
            print("Unable to open database")
            return 0
        }
        let version = Int(database.userVersion)
        database.close()
        return version
    }
    
    func getAllCategories() -> [SearchCategory] {
        
        var results:[SearchCategory] = []
        
        guard database.open() else {
            print("Unable to open database")
            return results
        }
        
        do {
            let rs = try database.executeQuery("select * from Categories", values: nil)
            while rs.next() {
                
                let categoryId = rs.long(forColumn: "categoryId")
                let name = rs.string(forColumn: "name")!
                let icon = rs.string(forColumn: "icon")!
                let flags = rs.long(forColumn: "flags")
                
                let model = SearchCategory(categoryId: categoryId, title: name)
                model.icon = icon
                model.flags = flags
                results.append(model)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return results
    }
    
    func getGameForId(gameId: Int) -> Board? {
        
        var board:Board? = nil
        
        guard database.open() else {
            print("Unable to open database")
            return nil
        }
        
        do {
            let rs = try database.executeQuery("select * from Games where gameId = ?", values: [gameId])
            while rs.next() {
                board = boardFrom(rs)
                
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return board
    }
    
    private func boardFrom(_ rs:FMResultSet) -> Board {
        
        let gameId = rs.long(forColumn: "gameId")
        let categoryId = rs.long(forColumn: "categoryId")
        let name = rs.string(forColumn: "name")!
        let icon = rs.string(forColumn: "icon")!
        let difficulty = rs.long(forColumn: "difficulty")
        let flags = rs.long(forColumn: "flags")
        let description = rs.string(forColumn: "description")
        let createdDate = rs.date(forColumn: "createdDate")
        
        let model = Board()
        model.icon = icon
        model.name = name
        model.gameId = gameId
        model.categoryId = categoryId
        model.flags = flags
        model.difficulty = difficulty
        model.boardDescription = description ?? ""
        model.createdDate = createdDate
        return model
    }
    
    func getGamesWithFlag(flag:Int) -> [Board] {
        
        var results:[Board] = []
        
        guard database.open() else {
            print("Unable to open database")
            return results
        }
        
        do {
            let rs = try database.executeQuery("select * from Games where flags = ?", values: [flag])
            while rs.next() {
                let model = boardFrom(rs)
                results.append(model)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return results
    }
    
    func getAllGames() -> [Board] {
        
        var results:[Board] = []
        
        guard database.open() else {
            print("Unable to open database")
            return results
        }
        
        do {
            let rs = try database.executeQuery("select * from Games where flags != 66 order by gameId desc", values: nil)
            while rs.next() {
                let model = boardFrom(rs)
                results.append(model)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return results
    }
    
    func getQuestionGroups(gameId:Int) -> [QuestionGroup] {
        
        var results:[QuestionGroup] = []
        
        guard database.open() else {
            print("Unable to open database")
            return results
        }
        
        do {
            let rs = try database.executeQuery("select * from QuestionGroups where gameId = ? order by groupId asc", values: [gameId])
            while rs.next() {
                
                let groupId = rs.long(forColumn: "groupId")
                let gameId = rs.long(forColumn: "gameId")
                let name = rs.string(forColumn: "name")!
                
                let model = QuestionGroup()
                model.groupId = groupId
                model.gameId = gameId
                model.name = name
                results.append(model)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return results
    }
    
    func createGame(_ board:Board) -> Bool {
        
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        database.beginTransaction()
        
        let gameId = insertBoard(board, openDB: false)
        if (gameId == 0) {
            database.rollback()
            database.close()
            return false
        } else {
            board.gameId = gameId
        }
        
        for group in board.groups {
            // assign game id, it's used by insert.
            group.gameId = gameId
            let result = insertQuestionGroup(group, openDB: false)
            if (result == false) {
                database.rollback()
                database.close()
                return false
            }
            
            for question in group.questions {
                // assign game id, it's used by insert.
                question.gameId = gameId
                let result = insertQuestion(question, openDB: false)
                if (result == false) {
                    database.rollback()
                    database.close()
                    return false
                }
            }
        }
        
        database.commit()
        database.close()
        
        return true
    }
    
    func updateGroup(_ group:QuestionGroup) -> Bool {
        
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        let result = database.executeUpdate("update QuestionGroups set name = ? where groupId = ? and gameId = ?", withArgumentsIn: [group.name, group.groupId, group.gameId])
        
        database.close()
        
        return result
        
    }
    
    func updateQuestion(_ question:Question) -> Bool {
        
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        let result = database.executeUpdate("update Questions set question = ?, answer = ?, value = ? where questionId = ? and groupId = ? and gameId = ?", withArgumentsIn: [question.question, question.answer, question.value, question.questionId, question.groupId, question.gameId])
        
        database.close()
        
        return result
    }
    
    func getQuestions(gameId:Int) -> [Question] {
        
        var results:[Question] = []
        
        guard database.open() else {
            print("Unable to open database")
            return results
        }
        
        do {
            let rs = try database.executeQuery("select * from Questions where gameId = ? order by questionId asc, groupId asc", values: [gameId])
            while rs.next() {
                
                let questionId = rs.long(forColumn: "questionId")
                let groupId = rs.long(forColumn: "groupId")
                let gameId = rs.long(forColumn: "gameId")
                let flags = rs.long(forColumn: "flags")
                let value = rs.long(forColumn: "value")
                
                let question = rs.string(forColumn: "question")!
                let answer = rs.string(forColumn: "answer")!
                let image = rs.string(forColumn: "image")
                let custom1 = rs.string(forColumn: "custom1")
                let custom2 = rs.string(forColumn: "custom2")
                let custom3 = rs.string(forColumn: "custom3")
                
                let model = Question()
                model.questionId = questionId
                model.groupId = groupId
                model.gameId = gameId
                model.flags = flags
                model.value = value
                
                model.question = question
                model.answer = answer
                model.image = image
                model.custom1 = custom1
                model.custom2 = custom2
                model.custom3 = custom3

                results.append(model)
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }
        
        database.close()
        
        return results
    }
    
    // MARK: Inserts
    
    func insertQuestion(_ question:Question, openDB:Bool) -> Bool {
        
        if (openDB) {
            guard database.open() else {
                print("Unable to open database")
                return false
            }
        }
        
        let result = database.executeUpdate("insert into Questions (questionId, groupId, gameId, flags, value, question, answer, image, custom1, custom2, custom3) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [question.questionId, question.groupId, question.gameId, question.flags, question.value, question.question, question.answer, question.image ?? "", question.custom1 ?? "", question.custom2 ?? "", question.custom3 ?? ""])
        
        if (openDB) {
            database.close()
        }
        
        return result
    }
    
    func insertQuestionGroup(_ group:QuestionGroup, openDB:Bool) -> Bool {
        
        if (openDB) {
            guard database.open() else {
                print("Unable to open database")
                return false
            }
        }
        
        let result = database.executeUpdate("insert into QuestionGroups (groupId, gameId, name) values(?, ?, ?)", withArgumentsIn: [group.groupId, group.gameId, group.name])
        
        if (openDB) {
            database.close()
        }
        
        return result
    }
    
    @discardableResult
    func updateBoard(_ board:Board) -> Bool {
        guard database.open() else {
            print("Unable to open database")
            return false
        }
        
        let result = database.executeUpdate("update Games set name = ?, icon = ?, description = ? where gameId = ?", withArgumentsIn: [board.name, board.icon, board.boardDescription, board.gameId])
        
        database.close()
        
        return result
        
    }
    
    func deleteBoard(boardId: Int) {
        
        guard database.open() else {
            print("Unable to open database")
            return
        }
        
        database.executeUpdate("delete from Games where gameId = ?; delete from QuestionGroups where gameId = ?; delete from Questions where gameId = ?;", withArgumentsIn: [boardId,boardId,boardId])
        
        database.close()
    }
    
    func insertBoard(_ board:Board, openDB:Bool) -> Int {
        
        if (openDB) {
            guard database.open() else {
                print("Unable to open database")
                return 0
            }
        }
        
        let createdOn = board.createdDate!.timeIntervalSince1970
        let result = database.executeUpdate("insert into Games (categoryId, name, icon, description, difficulty, flags, createdDate) values(?, ?, ?, ?, ?, ?, ?)", withArgumentsIn: [board.categoryId, board.name, board.icon, board.boardDescription, board.difficulty, board.flags, createdOn])
        
        var lastRowId:Int = 0
        if (result) {
            lastRowId = Int(database.lastInsertRowId)
        }
        
        if (openDB) {
            database.close()
        }
        
        return lastRowId
    }
    
}
