//
//  GameSummaryViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/29/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol GameSummaryViewControllerDelegate {
    func onGameSummaryUpdated(_ board:Board)
    func onGameSummaryDeleted(_ board:Board)
}

class GameSummaryViewController: UIViewController, GameNameViewControllerDelegate, CreateGameTilesViewControllerDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    
    var board:Board!
    var delegate:GameSummaryViewControllerDelegate!
    
    public static func makeNew(board:Board, delegate:GameSummaryViewControllerDelegate) -> GameSummaryViewController {
        let vc = UIStoryboard(name: "CreateGame", bundle: nil).instantiateViewController(withIdentifier: "summary") as! GameSummaryViewController
        vc.board = board
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }
    
    private func initializeUI() {
        lblTitle.text = board.name
        
        var description = board.boardDescription
        if (description.count == 0) {
            description = "Choose Rename to add Description."
        }
        lblSubTitle.text = description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: Date())
        lblCreated.text = "Created on \(dateString)"
        
        let answered = self.board.questionCount(forState: .Answered)
        if (answered < 25) {
            lblProgress.isHidden = false
            progressView.isHidden = false
            lblProgress.text = "\(answered)/25 Questions"
            progressView.progress = Float(answered) / 25.0
        } else {
            lblProgress.isHidden = true
            progressView.isHidden = true
        }
    }
    
    // MARK: Actions
    
    @IBAction func onPlay(_ sender: Any) {
        
        if (self.board.isComplete()) {
            // reason for getting new game
            // is because it resets question state
            // we use .Answered and .New also for editing state.
            let newBoard = GameMaker().copyBoard(board: self.board)
            newBoard.isMyGame = true
            let vc = ChoosePlayersViewController.createNew(newBoard)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let answered = self.board.questionCount(forState: .Answered)
            let title:String? = nil
            let message = "You have only \(answered)/25 questions completed. You need to finish making the game before it can be played."
            let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onRename(_ sender: Any) {
        let vc = GameNameViewController.createNew(board, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        let vc = CreateGameTilesViewController.createNew(self.board, delegate: self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        
        let vc = UIAlertController(title: "Delete Game", message: "Are you sure you want to delete this game? This action CANNOT be undone.", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            MyGamesDao().removeGame(self.board.gameId)
            self.delegate.onGameSummaryDeleted(self.board)
            self.navigationController?.popViewController(animated: true)
        }))
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: GameNameViewControllerDelegate
    func onGameUpdated(_ board:Board) {
        initializeUI()
        self.delegate.onGameSummaryUpdated(board)
    }
    
    // MARK: CreateGameTilesViewControllerDelegate
    func onGameQuestionsUpdated(_ board:Board) {
        initializeUI()
        self.delegate.onGameSummaryUpdated(board)
    }
    
}
