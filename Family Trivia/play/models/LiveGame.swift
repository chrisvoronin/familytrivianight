//
//  LiveGame.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/15/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class LiveGame {

    var board:Board
    var players:[Player]
    
    required init(board:Board, players:[Player]) {
        self.board = board
        self.players = players
    }
    
    func getPlayerLabels() -> [String] {
        
        var labels:[String] = []
        for player in self.players {
            let label = "\(player.name)\r\n\(player.score)"
            labels.append(label)
        }
        return labels
    }
}
