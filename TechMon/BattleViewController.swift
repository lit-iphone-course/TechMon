//
//  BattleViewController.swift
//  TechMon
//
//  Created by Owner on 2023/12/21.
//

import UIKit
import AVFoundation

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPBar: UIProgressView!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPBar: UIProgressView!
    
    var player: Charactor!
    var enemy: Charactor!
    var enemyAttackTimer: Timer!
    let bgmPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "bgm_battle")!.data)
    let victorySEPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "fanfare")!.data)
    let gameoverSEPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "gameover")!.data)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //プレイヤーと敵を設定
        player = Charactor(name: "勇者", 
                           imageName: "yusha",
                           currentHP: 100,
                           maxHP: 100,
                           currentMP: 0,
                           maxMP: 5,
                           normalAttackPower: 20,
                           specialAttackPower: 60,
                           normalAttackSEName: "attack_normal",
                           specialAttackSEName: "attack_special")
        enemy = Charactor(name: "ヴァンパイア",
                          imageName: "vampire",
                          currentHP: 300,
                          maxHP: 300,
                          currentMP: 0, 
                          maxMP: 0,
                          normalAttackPower: 10,
                          specialAttackPower: 0,
                          normalAttackSEName: "enemy_attack",
                          specialAttackSEName: "enemy_attack")
        
        //プレイヤーと敵の設定をUIに反映
        playerNameLabel.text = player.name
        playerImageView.image = player.image
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //敵の自動攻撃を設定
        enemyAttackTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true)
        
        //BGM
        bgmPlayer.currentTime = 0
        bgmPlayer.play()
    }
    
    @IBAction func normalAttack() {
        //攻撃
        attack(damage: player.normalAttackPower)
        
        //サウンドエフェクト
        player.playNormalAttackSE()
        
        //MPをチャージ
        player.currentMP = min(player.currentMP + 1, player.maxMP)
    }
    
    @IBAction func specialAttack() {
        if player.currentMP == player.maxMP {
            //特殊攻撃
            attack(damage: player.specialAttackPower)
            
            //サウンドエフェクト
            player.playSpecialAttackSE()
            
            //MPをリセット
            player.currentMP = 0
        }
    }
    
    func attack(damage: Int) {
        //敵にダメージを与える
        enemy.currentHP -= damage
        updateUI()
        
        //アニメーション
        damageAnimation(view: enemyImageView)
        
        //プレーヤーの勝利判定
        if enemy.isDefeated() {
            finishBattle(isVictory: true)
        }
    }
    
    @objc func enemyAttack() {
        //敵からダメージを受ける
        player.currentHP -= enemy.normalAttackPower
        updateUI()
        
        //アニメーションとサウンドエフェクト
        damageAnimation(view: playerImageView)
        enemy.playNormalAttackSE()
        
        //プレイヤーの敗北判定
        if player.isDefeated() {
            finishBattle(isVictory: false)
        }
    }
    
    func finishBattle(isVictory: Bool) {
        //タイマー、BGMを止める
        enemyAttackTimer.invalidate()
        bgmPlayer.stop()
        
        //アラートを表示
        var message: String = ""
        
        if isVictory {
            message = "勇者の勝利！！"
            victorySEPlayer.currentTime = 0
            victorySEPlayer.play()
        } else {
            message = "勇者の敗北…"
            gameoverSEPlayer.currentTime = 0
            gameoverSEPlayer.play()
        }
        
        let alert = UIAlertController(title: "バトル終了", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func updateUI() {
        //UIを更新
        playerHPBar.progress = Float(player.currentHP) / Float(player.maxHP)
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        enemyHPBar.progress = Float(enemy.currentHP) / Float(enemy.maxHP)
    }
    
    func damageAnimation(view: UIView) {
        //アニメーション
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .autoreverse], animations: {
            view.alpha = 0
            view.center.x -= 5
        }) { _ in
            view.alpha = 1.0
            view.center.x += 5
        }
    }
    
}
