//
//  SoundUtility.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/17/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit
import AVFoundation

class SoundUtility: NSObject {

    enum MusicFile: Int {
        case eighties = 1
        case victory = 2
        case baby = 3
        case halloween = 4
        case christmas = 5
    }
    
    static let shared:SoundUtility = SoundUtility()
    var player:AVAudioPlayer?
    
    // prevent initializations.
    private override init() {
        super.init()
    }
    
    public func isPlayingMusic() -> Bool {
        
        if (player == nil) {
            return false
        }
        return player!.isPlaying
    }
    
    public func startMusic(file:MusicFile) {
        
        // stop previous player.
        self.stopMusic()
        
        let fileName = getFileNameFrom(file: file)
        
        if let sound = NSDataAsset(name: fileName) {
            do {
                
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default)
                try! AVAudioSession.sharedInstance().setActive(true)
                try player = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileType.mp3.rawValue)
                player!.numberOfLoops = -1
                player!.play()
            } catch {
                print("error initializing AVAudioPlayer for file \(file) and fileName \(fileName)")
            }
        }
    }
    
    public func fadeOut() {
        
        if (player == nil) {
            return
        }
        
        player!.setVolume(0, fadeDuration: 3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.stopMusic()
        }
    }
    
    public func stopMusic() {
        if (player != nil) {
            player!.stop()
            player = nil
        }
    }
    
    private func getFileNameFrom(file:MusicFile) -> String {
        
        switch file {
        case .eighties:
            return "theme_80s"
        case .victory:
            return "theme_victory_80s"
        case .baby:
            return "theme_baby"
        case .halloween:
            return "witchbrew"
        case .christmas:
            return "jinglebells"
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
