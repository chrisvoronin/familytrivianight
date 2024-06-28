//
//  GameNameViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/23/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol GameNameViewControllerDelegate {
    func onGameUpdated(_ board:Board)
}

class GameNameViewController: UIViewController {

    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
        
    var board:Board!
    var delegate:GameNameViewControllerDelegate!
    
    static func createNew(_ board:Board, delegate:GameNameViewControllerDelegate) -> GameNameViewController {
        
        let vc = UIStoryboard(name: "CreateGame", bundle: nil).instantiateViewController(withIdentifier: "name") as! GameNameViewController
        vc.board = board
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtTitle.text = board.name
        txtDescription.text = board.boardDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func titleChanged(_ sender: UITextField) {
        //answer
        board.name = sender.text!
        MyGamesDao().setGame(board)
        self.delegate.onGameUpdated(board)
    }
    
    @IBAction func descriptionChanged(_ sender: UITextField) {
        board.boardDescription = sender.text!
        self.delegate.onGameUpdated(board)
    }

}
