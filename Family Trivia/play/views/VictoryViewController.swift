//
//  VictoryViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/16/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class VictoryViewController: UIViewController {

    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var game:LiveGame!
    private var teamsDS:GameTitlesDataSource!
    private var celebrationView:JRMFloatingAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        teamsDS = GameTitlesDataSource(titles: self.game.getPlayerLabels())
        let winners = calculateWinners()
        teamsDS.highlightIndex = winners

        collectionView.collectionViewLayout = CollectionFlowGrid(rows: 1, columns: 5)
        let nib = UINib(nibName: "GameCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        self.collectionView.dataSource = teamsDS
        self.collectionView.delegate = teamsDS
        
        if (winners.count > 1) {
            self.labelHeader.text = "Congratulations Winners!"
        } else {
            self.labelHeader.text = "Congratulations!"
        }
        
        createAnimation()
        
        // next
        let nextRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBack))
        nextRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)
            ,NSNumber(value: UIPress.PressType.select.rawValue)]
        self.view.addGestureRecognizer(nextRecognizer)
        
        // back
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onBack))
        backRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(backRecognizer)
        
    }
    
    @objc func onBack() {
        
        SoundUtility.shared.stopMusic()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func createAnimation() {
        
        let x = self.view.frame.size.width / 2
        let y = self.view.frame.size.height + 100
        let point:CGPoint = CGPoint(x: x, y: y)
        celebrationView = JRMFloatingAnimationView(starting: point)
        celebrationView.startingPointWidth = self.view.frame.size.width
        celebrationView.animationWidth = 100
        celebrationView.maxFloatObjectSize = 100
        celebrationView.minFloatObjectSize = 100
        celebrationView.animationDuration = 5
        celebrationView.maxAnimationHeight = celebrationView.maxAnimationHeight - 64
        celebrationView.minAnimationHeight = celebrationView.maxAnimationHeight
        celebrationView.removeOnCompletion = true
        
        //    self.floatingView.imageViewAnimationCompleted = ^void(UIImageView *imageView) {
        //        imageView.image = [UIImage imageNamed:@"blueballoon"];
        //    };
        
        //let array = ["orangeballoon", "blueballoon", "redballoon"]
        //let index = Int.random(in: 0...2)
        //let imageName = array[index]
        let imageName = "redballoon"
        let image = UIImage(named: imageName)
        celebrationView.add(image)
        self.view.addSubview(celebrationView)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.celebrationView.animate()
        }
    }
    
    private func calculateWinners() -> [IndexPath] {
        
        // first calc high score
        var highScore = game.players[0].score
        for team in game.players {
            let score = team.score
            if score > highScore {
                highScore = score
            }
        }
        
        var indexes:[IndexPath] = []
        for (index, team) in game.players.enumerated() {
            let score = team.score
            if score == highScore {
                let ip = IndexPath(row: index, section: 0)
                indexes.append(ip)
            }
        }
        
        return indexes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (SoundUtility.shared.isPlayingMusic() == false) {
            SoundUtility.shared.startMusic(file: .victory)
        }
    }

}
