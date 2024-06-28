//
//  CreateGameViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/14/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GameSummaryViewControllerDelegate {
    
    static func create() -> CreateGameViewController {
        let sb = UIStoryboard(name: "CreateGame", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! CreateGameViewController
        vc.title = "My Games"
        return vc
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let defaultTitle = "Create New Game"
    let defaultSubTitle = "You will be able to choose your own questions, answers and assign their point value."
    var rows:[RowModel] = []
    
    class RowModel {
        var title:String!
        var subTitle:String!
        var icon:String?
        var board:Board?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup defaults
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        // get users games.
        let boards = MyGamesDao().getAllGames()
        var dict:[Int:Board] = [:]
        for board in boards {
            dict[board.gameId] = board
        }
        
        for i in 1...MyGamesDao.maxGameId {
            let row = RowModel()
            if let board = dict[i] {
                row.title = board.name
                row.subTitle = board.boardDescription
                row.board = board
            } else {
                row.title = defaultTitle
                row.subTitle = defaultSubTitle
            }
            rows.append(row)
        }        
    }
    
    // MARK: Tableview
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.rows[indexPath.row]
        if (model.board == nil) {
            let gameId = indexPath.row + 1
            let board = GameMaker().initNewGameBoard(name: "My Game \(gameId)", gameId:gameId)
            MyGamesDao().setGame(board)
            model.board = board
            model.title = board.name
            model.subTitle = board.boardDescription
            self.tableView.reloadRows(at: [indexPath], with: .none)
            onBoardSelected(board)
        } else {
            onBoardSelected(model.board!)
        }
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if let indexPath = context.nextFocusedIndexPath {
            
            let cell = self.tableView.cellForRow(at: indexPath)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell?.textLabel?.textColor = UIColor.black
            cell?.detailTextLabel?.textColor = UIColor.black
            
            let model = self.rows[indexPath.row]
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.subTitle
        }
        
        if let prev = context.previouslyFocusedIndexPath {
            
            let cell = self.tableView.cellForRow(at: prev)
            cell?.textLabel?.textColor = UIColor.white
            cell?.detailTextLabel?.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // init cell
        var cellQue = tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cellQue == nil) {
            cellQue = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let cell = cellQue!
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        cell.imageView?.tintColor = UIColor.white
        cell.imageView?.contentMode = .scaleAspectFit
        // get data
        let row = self.rows[indexPath.row]
        
        // fill out cell
        if (row.board == nil) {
            cell.textLabel?.text = row.title
            cell.detailTextLabel?.text = row.subTitle
            cell.imageView?.image = UIImage(named: "pencil")
            return cell
        }
        
        let game = row.board!
        cell.textLabel?.text = game.name
        cell.detailTextLabel?.text = game.boardDescription
        cell.imageView?.image = UIImage(named: game.icon)
        
        
        return cell
    }
    
    // MARK: Selection
    
    func onBoardSelected(_ board:Board) {
        
        // existing game.
        // fill it out with questions and answers if needed.
        if (board.groups.count == 0) {
            TriviaDataController.shared.fillGameCategoriesAndQuestions(game: board)
        }
        
        // update for editing
        GameMaker().initQuestionStateForEditingIn(board)
        
        let vc = GameSummaryViewController.makeNew(board: board, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: GameSummaryViewControllerDelegate
    
    func onGameSummaryUpdated(_ board:Board) {
        let index = findIndexFor(gameId: board.gameId)
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func onGameSummaryDeleted(_ board:Board) {
        
        let gameId = board.gameId
        let index = findIndexFor(gameId: gameId)
        let indexPath = IndexPath(row: index, section: 0)
        let model = self.rows[index]
        model.board = nil
        model.title = defaultTitle
        model.subTitle = defaultSubTitle
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func findIndexFor(gameId: Int) -> Int {
        for (index, row) in self.rows.enumerated() {
            if (row.board != nil && row.board!.gameId == gameId) {
                return index
            }
        }
        return -1
    }
}
