//
//  SplashViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/17/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit
import AVKit

class SplashViewController: UIViewController {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnInMemory: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        SoundUtility.shared.stopMusic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (SoundUtility.shared.isPlayingMusic() == false) {
            let date = Date()
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            if month == 10 {
                SoundUtility.shared.startMusic(file: .halloween)
            } else if month == 12 {
                SoundUtility.shared.startMusic(file: .christmas)
            } else {
                SoundUtility.shared.startMusic(file: .baby)
            }
            
        }
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [btnPlay, btnAbout, btnInMemory]
    }

    @IBAction func onInMemoryButtonPressed(_ sender: Any) {
        
        guard let path = Bundle.main.path(forResource: "trebek", ofType: "mp4") else {
            return
        }
        
        if SoundUtility.shared.isPlayingMusic() {
            SoundUtility.shared.stopMusic()
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url:url)
        let controller = AVPlayerViewController()
        controller.player = player
        present(controller, animated: true) {
            player.play()
        }
    }
}
