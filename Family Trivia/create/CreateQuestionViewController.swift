//
//  CreateQuestionViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/19/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol CreateQuestionViewControllerDelegate {
    func onQuestionUpdated(_ question:Question, ip:IndexPath)
}

class CreateQuestionViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtQuestion: UITextField!
    @IBOutlet weak var txtAnswer: UITextField!
    
    @IBOutlet weak var score100: UIButton!
    @IBOutlet weak var score200: UIButton!
    @IBOutlet weak var score300: UIButton!
    @IBOutlet weak var score400: UIButton!
    @IBOutlet weak var score500: UIButton!
    @IBOutlet weak var score1: UIButton!
    
    var question:Question!
    var indexPath:IndexPath!
    var delegate:CreateQuestionViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.txtAnswer.text = question.answer
        self.txtQuestion.text = question.question
        setSelectedForScore(score: question.value)
    }
    
    @IBAction func answerChanged(_ sender: UITextField) {
        //answer
        question.answer = sender.text!
        self.delegate.onQuestionUpdated(question, ip: indexPath)
    }
    
    @IBAction func questionChanged(_ sender: UITextField) {
        question.question = sender.text!
        self.delegate.onQuestionUpdated(question, ip: indexPath)
    }
    
    
    @IBAction func onScoreSelected(_ sender: UIButton) {
        
        let score = sender.tag
        setSelectedForScore(score: score)
        question.value = score
        self.delegate.onQuestionUpdated(question, ip: indexPath)
    }
    
    private func setSelectedForScore(score:Int) {
        score100.isSelected = score == score100.tag
        score200.isSelected = score == score200.tag
        score300.isSelected = score == score300.tag
        score400.isSelected = score == score400.tag
        score500.isSelected = score == score500.tag
        score1.isSelected = score == score1.tag
    }

}
