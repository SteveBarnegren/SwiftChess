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
    open var whitePlayer: Player!
    open var blackPlayer: Player!
    open var currentPlayer: Player!

    public init(){
        
        self.whitePlayer = Player(color: .white, game: self)
        self.blackPlayer = Player(color: .black, game: self)
        self.currentPlayer = self.whitePlayer
        
    }
    
    
}
