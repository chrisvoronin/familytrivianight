//
//  CreateGameTilesViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/18/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol CreateGameTilesViewControllerDelegate {
    func onGameQuestionsUpdated(_ board:Board)
}

class CreateGameTilesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CreateQuestionViewControllerDelegate, ButtonTilesCollectionDSDelegate, EditTitleViewControllerDelegate {
    
    @IBOutlet weak var collectionViewTitles: UICollectionView!
    @IBOutlet weak var collectionViewQuestions: UICollectionView!
    
    var numPlayers:Int!
    var board:Board!
    var delegate:CreateGameTilesViewControllerDelegate!
    
    private var lastAnsweredIndexPath:IndexPath?
    private var titlesDS:ButtonTilesCollectionDS!
    
    static func createNew(_ board:Board, delegate:CreateGameTilesViewControllerDelegate) -> CreateGameTilesViewController {
        
        let vc = UIStoryboard(name: "CreateGame", bundle: nil).instantiateViewController(withIdentifier: "game") as! CreateGameTilesViewController
        vc.board = board
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewTitles.collectionViewLayout = CollectionFlowGrid(rows: 1, columns: 5)
        self.collectionViewQuestions.collectionViewLayout = CollectionFlowGrid(rows: 5, columns: 5)
        
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        let nib2 = UINib(nibName: ButtonCollectionViewCell.nibName, bundle: nil)
        self.collectionViewTitles.register(nib2, forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
        self.collectionViewQuestions.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        titlesDS = ButtonTilesCollectionDS()
        titlesDS.titles = board.getTitles()
        titlesDS.delegate = self
        
        self.collectionViewTitles.dataSource = titlesDS
        self.collectionViewTitles.delegate = titlesDS
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gamecell", for: indexPath) as! GameCollectionViewCell
        
        let groupId = indexPath.row % 5
        let questionId = indexPath.row / 5
        
        let question = self.board.groups[groupId].questions[questionId]
        
        if (question.state == .New) {
            cell.label.text = "Incomplete"
        } else {
            cell.label.text = "\(question.value)"
        }
        
        cell.imageView.adjustsImageWhenAncestorFocused = true
        cell.imageView.clipsToBounds = false
        cell.imageView.contentMode = .scaleToFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let groupId = indexPath.row % 5
        let questionId = indexPath.row / 5
        let question = self.board.groups[groupId].questions[questionId]
        
        let vc = UIStoryboard(name: "CreateGame", bundle: nil).instantiateViewController(withIdentifier: "question") as! CreateQuestionViewController
        vc.question = question
        vc.indexPath = indexPath
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        // nothing for now. otherwie we can use previous and nextfocusedindexpath to update background colors, etc...
        
        if (context.previouslyFocusedIndexPath != nil) {
            let indexPath = context.previouslyFocusedIndexPath!
            let cell = collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
            cell.imageView.image = UIImage(named: "screen")
        }
        
        if (context.nextFocusedIndexPath != nil) {
            let indexPath = context.nextFocusedIndexPath!
            let cell = collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
            cell.imageView.image = UIImage(named: "screen_off")
        }
    }
    
    // MARK: question delegation
    
    func onQuestionUpdated(_ question:Question, ip:IndexPath) {
        
        if (question.question.count > 0
            && question.answer.count > 0) {
            question.state = .Answered
        } else {
            question.state = .New
        }
        
        self.collectionViewQuestions.reloadItems(at: [ip])
        MyGamesDao().setGame(board)
        self.delegate.onGameQuestionsUpdated(board)
    }
    
    // MARK: Group Title delegate
    
    func onTitleSelected(at:IndexPath) {
        let vc = UIStoryboard(name: "CreateGame", bundle: nil).instantiateViewController(withIdentifier: "edittitle") as! EditTitleViewController
        vc.text = self.board.groups[at.row].name
        vc.indexPath = at
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onTitleChanged(title: String, indexPath: IndexPath) {
        let group = self.board.groups[indexPath.row]
        group.name = title
        self.titlesDS.titles = board.getTitles()
        self.collectionViewTitles.reloadItems(at: [indexPath])
        MyGamesDao().setGame(board)
        self.delegate.onGameQuestionsUpdated(board)
        
    }
    
}
