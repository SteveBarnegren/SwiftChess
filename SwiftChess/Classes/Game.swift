//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Game {
    
    open var board = Board()
    open var playerOne: Player!
    open var playerTwo: Player!
    
    public init(){
        
        self.playerOne = Player(color: .white, game: self)
        self.playerTwo = Player(color: .black, game: self)
        
    }
    
    
}
