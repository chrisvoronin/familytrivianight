//
//  QuestionViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit
import AVKit

protocol QuestionViewControllerDelegate {
    func onQuestionAnswered(question:Question, scores:[String:Int], indexPath:IndexPath)
}

class QuestionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imageQuestion: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var hintAnswer: UILabel!
    @IBOutlet weak var hintQuestion: UILabel!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    var questionIndexPath:IndexPath!
    var delegate:QuestionViewControllerDelegate!
    var game:LiveGame!
    var question:Question!
    var answerScores:[String:Int] = [:] // player name, score added
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelHeader.text = "Question"
        self.labelText.text = question.question
        self.hintAnswer.isHidden = true
        self.teamsCollectionView.isHidden = true
        self.teamsCollectionView.collectionViewLayout = CollectionFlowGrid(rows: 1, columns: 5)
        
        if question.flags == 4 {
            playButton.isHidden = false
            labelText.isHidden = true
            imageQuestion.isHidden = true
        } else if question.flags == 1 {
            playButton.isHidden = true
            labelText.isHidden = true
            imageQuestion.isHidden = false
            if let imageName = question.custom1 {
                imageQuestion.image = UIImage(named: imageName)
                labelHeader.text = question.question
            }
        } else {
            playButton.isHidden = true
            labelText.isHidden = false
            imageQuestion.isHidden = true
        }
        
        let nib = UINib(nibName: "PlayerScoreEditCollectionViewCell", bundle: nil)
        self.teamsCollectionView.register(nib, forCellWithReuseIdentifier: PlayerScoreEditCollectionViewCell.reuseIdentifier)
        
        // next
        let nextRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onNext))
        nextRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)
                                           ,NSNumber(value: UIPress.PressType.select.rawValue)]
        self.view.addGestureRecognizer(nextRecognizer)

        // back
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBack))
        backRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(backRecognizer)
    }
    
    // MARK: Button presses
    
    @IBAction func playButtonPressed(_ sender: Any) {
        
        let fileName = question.custom1!
        guard let path = Bundle.main.path(forResource: fileName, ofType: "mp4") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url:url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
//               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
    
    @objc
    func playerDidFinishPlaying(notification: Notification) {
        print("Video Finished")
        dismiss(animated: true, completion: nil)
    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onNext() {
        
        if (self.question.state == .Answered) {
            return
        }
        
        self.question.state = .Answered
        self.labelHeader.text = "Answer"
        self.imageQuestion.isHidden = true
        self.labelText.isHidden = false
        self.labelText.text = question.answer
        
        self.labelText.minimumScaleFactor = 0.1
        
        self.hintAnswer.isHidden = false
        self.hintQuestion.isHidden = true
        self.teamsCollectionView.isHidden = false
        self.setNeedsFocusUpdate()
        self.updateFocusIfNeeded()
    }
    
    @objc func onBack() {
        
        // now dismiss
        if (self.presentingViewController != nil) {
            self.presentingViewController!.dismiss(animated: true) {
                if (self.question.state == .Answered) {
                    self.delegate.onQuestionAnswered(question: self.question, scores: self.answerScores, indexPath: self.questionIndexPath)
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true, completion: {
                if (self.question.state == .Answered) {
                    self.delegate.onQuestionAnswered(question: self.question, scores: self.answerScores, indexPath: self.questionIndexPath)
                }

            })
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayerScoreEditCollectionViewCell.reuseIdentifier, for: indexPath) as! PlayerScoreEditCollectionViewCell
        
        let player = game.players[indexPath.row]
        let playerIndexString = String(indexPath.row)
        
        var scoreAddition = 0
        if let score = answerScores[playerIndexString] {
            scoreAddition = score
        }
        
        // set targets for button plus and minus.
        cell.buttonMinus.isHidden = scoreAddition < 0
        cell.buttonPlus.isHidden = scoreAddition > 0
        cell.buttonMinus.tag = indexPath.row
        cell.buttonPlus.tag = indexPath.row
        cell.buttonMinus.addTarget(self, action: #selector(onMinusPressed(sender:)), for: .primaryActionTriggered)
        cell.buttonPlus.addTarget(self, action: #selector(onPlusPressed(sender:)), for: .primaryActionTriggered)
        cell.label.text = "\(player.name)\r\n\(scoreAddition)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @objc func onPlusPressed(sender:UIButton) {
        let playerIndexString = String(sender.tag)
        if let _ = self.answerScores[playerIndexString] {
            self.answerScores.removeValue(forKey: playerIndexString)
        } else {
            self.answerScores[playerIndexString] = self.question.value
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.teamsCollectionView.reloadItems(at: [indexPath])
    }
    
    @objc func onMinusPressed(sender:UIButton) {
        let playerIndexString = String(sender.tag)
        if let _ = self.answerScores[playerIndexString] {
            self.answerScores.removeValue(forKey: playerIndexString)
        } else {
            self.answerScores[playerIndexString] = self.question.value * -1
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.teamsCollectionView.reloadItems(at: [indexPath])
    }

}
