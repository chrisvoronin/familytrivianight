//
//  ChoosePlayersViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class ChoosePlayersViewController: UIViewController {

    var board:Board!
    
    static func createNew(_ board:Board) -> ChoosePlayersViewController {
        
        let vc = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "players") as! ChoosePlayersViewController
        vc.board = board
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onPlayerCountSelected(_ sender: UIButton) {
        
        // stop music
        SoundUtility.shared.fadeOut()
        
        // go to next screen.
        let count = sender.tag
        //let vc:GameViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "game") as! GameViewController
        let vc:GameV2ViewController = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "gamev2") as! GameV2ViewController
        vc.numPlayers = count
        vc.board = board
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
