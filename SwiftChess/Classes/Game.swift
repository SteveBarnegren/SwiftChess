//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Game {
    
    open var board = Board(state: .newGame)
    open var currentPlayer: Player!
    open weak var delegate: GameDelegate?
    
    internal var whitePlayer: Player!
    internal var blackPlayer: Player!

    public init(){
        
        // Setup Players
        self.whitePlayer = Player(color: .white, game: self)
        self.whitePlayer.delegate = self
        self.blackPlayer = Player(color: .black, game: self)
        self.blackPlayer.delegate = self
        self.currentPlayer = self.whitePlayer
        
    }

    
}

extension Game : PlayerDelegate {

    func playerDidMakeMove(player: Player) {
        
        // This shouldn't happen, but we'll print a message in case it does
        if player !== currentPlayer {
            print("Warning - Wrong player took turn")
        }
        
        // Switch to the other player
        if player === whitePlayer {
            currentPlayer = blackPlayer
        }
        else{
            currentPlayer = whitePlayer
        }
        
        // Inform the delegate
        self.delegate?.gameDidChangeCurrentPlayer(game: self)
    }

}

public protocol GameDelegate: class {
    func gameDidChangeCurrentPlayer(game: Game)
}

