//
//  ViewController.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 09/04/2016.
//  Copyright (c) 2016 Steve Barnegren. All rights reserved.
//

import UIKit
import SwiftChess

class MenuViewController: UIViewController {
    
    // MARK: - Actions
    
    @IBAction func playerVsAIButtonPressed(_ sender: UIButton) {
        
        let whitePlayer = Human(color: .white)
        let blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: .hard))
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        startGame(game: game)
    }
    
    @IBAction func playerVsPlayerButtonPressed(_ sender: UIButton) {
        
        let whitePlayer = Human(color: .white)
        let blackPlayer = Human(color: .black)
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        startGame(game: game)
    }
    
    @IBAction func AIvsAIButtonPressed(_ sender: UIButton) {
        
        let whitePlayer = AIPlayer(color: .white, configuration: AIConfiguration(difficulty: .hard))
        let blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: .hard))
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
        startGame(game: game)
    }
    
    func startGame(game: Game) {
        
        let gameViewController = GameViewController.gameViewController(game: game)
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }

}
