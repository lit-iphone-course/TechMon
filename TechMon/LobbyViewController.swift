//
//  LobbyViewController.swift
//  TechMon
//
//  Created by Owner on 2023/12/21.
//

import UIKit
import AVFoundation

class LobbyViewController: UIViewController {
    
    let bgmPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "bgm_lobby")!.data)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bgmPlayer.currentTime = 0
        bgmPlayer.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        bgmPlayer.stop()
    }

}
