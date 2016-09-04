//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public class Game {
    
    public var board = Board()
    public var playerOne: Player!
    public var playerTwo: Player!
    
    public init(){
        
        self.playerOne = Player(color: .white, game: self)
        self.playerTwo = Player(color: .black, game: self)
        
    }
    
    
}
