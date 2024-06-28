//
//  GameV2ViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 6/27/21.
//  Copyright © 2021 Chris Voronin. All rights reserved.
//

import UIKit

class GameV2ViewController: UIViewController {

    @IBOutlet weak var collectionTitles: UICollectionView!
    @IBOutlet weak var stackQuestions: UIStackView!
    @IBOutlet weak var collectionTeams: UICollectionView!
    
    var numPlayers:Int!
    var board:Board!
    
    private var lastAnsweredIndexPath:IndexPath?
    private var titlesDS:GameTitlesDataSource!
    private var teamsDS:GameTitlesDataSource!
    private var game:LiveGame!
    
    private var lastAnsweredIndex:Int?
    private let yesFocus = UIColor.imageFromColor(color: UIColor.FamilyTrivia.title) ?? UIImage(named: "screen_off")!
    private let notFocus = UIColor.imageFromColor(color: UIColor.FamilyTrivia.tvColor) ?? UIImage(named: "screen")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.game = GameMaker().makeGame(board: board, numPlayers: numPlayers)
        
        self.collectionTitles.collectionViewLayout = CollectionFlowGrid(rows: 1, columns: 5)
        self.collectionTeams.collectionViewLayout = CollectionFlowGrid(rows: 1, columns: 5)
        
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        self.collectionTitles.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        self.collectionTeams.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)

        titlesDS = GameTitlesDataSource(titles: self.game.board.getTitles())
        teamsDS = GameTitlesDataSource(titles: self.game.getPlayerLabels())
        
        self.collectionTitles.dataSource = titlesDS
        self.collectionTitles.delegate = titlesDS
        
        self.collectionTeams.dataSource = teamsDS
        self.collectionTeams.delegate = teamsDS
        
        setupButtons()
    }
    
    func setupButtons() {
        
        for i in 1...25 {
            if let button = stackQuestions.viewWithTag(i) as? UIButton {
                let index = i - 1
                let groupId = index / 5
                let questionId = index % 5
                let question = self.board.groups[groupId].questions[questionId]
                if (question.state == .New) {
                    button.isEnabled = true
                    let buttonTitle = "\(question.value)"
                    button.setTitle(buttonTitle, for: .normal)
                    button.setTitleColor(UIColor.white, for: .normal)
                    button.setTitleColor(UIColor.white, for: .focused)
                    button.layer.cornerRadius = 8
                    button.clipsToBounds = true
                    button.setBackgroundImage(notFocus, for: .normal)
                    button.setBackgroundImage(yesFocus, for: .focused)
                } else {
                    button.isEnabled = false
                    button.setTitle("", for: .normal)
                    button.setBackgroundImage(nil, for: .normal)
                }
            }
        }
    }
    
    @IBAction func onQuestionSelected(_ sender: UIButton) {
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        let index = indexPath.row - 1
        let groupId = index / 5
        let questionId = index % 5
        let question = self.board.groups[groupId].questions[questionId]
        
        let vc:QuestionViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "question") as! QuestionViewController
        vc.question = question
        vc.game = self.game
        vc.questionIndexPath = indexPath
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func areAllQuestionsAnswered() -> Bool {
        
        for group in board.groups {
            for question in group.questions {
                if (question.state == .New) {
                    return false
                }
            }
        }
        
        return true
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        var indexes = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
        if let last = lastAnsweredIndex {
            let parts = indexes.split(separator: last).reversed()
            indexes = Array(parts.joined())
        }
        var array:[UIFocusEnvironment] = []
        for tag in indexes {
            if let button = stackQuestions.viewWithTag(tag) as? UIButton, button.isEnabled {
                array.append(button)
            }
        }
        return array
    }
    
    func goToVictory() {
        let vc:VictoryViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "victory") as! VictoryViewController
        vc.game = self.game
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: Question Answered Delegate

extension GameV2ViewController: QuestionViewControllerDelegate {
    
    func onQuestionAnswered(question:Question, scores:[String:Int], indexPath:IndexPath) {
        
        // update players model
        for score in scores {
            let index = Int(score.key)!
            self.game.players[index].score += score.value
        }
        self.teamsDS.titles = self.game.getPlayerLabels()
        self.collectionTeams.reloadData()
        
        // update question model and UI.
        question.state = .Answered
        let tag = indexPath.row
        lastAnsweredIndex = tag
        if let button = stackQuestions.viewWithTag(tag) as? UIButton {
            button.isEnabled = false
            button.setTitle("", for: .normal)
            button.setBackgroundImage(nil, for: .normal)
        }
        // update focus
        lastAnsweredIndexPath = indexPath
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
        
        if (areAllQuestionsAnswered() == true) {
            goToVictory()
        }
    }
    
}

