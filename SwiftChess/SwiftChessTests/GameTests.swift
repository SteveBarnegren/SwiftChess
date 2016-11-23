//
//  GameTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftChess

class GameTests: XCTestCase {
    
    var game: Game!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        game = Game()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCurrentPlayerChangesAfterMoveTaken() {
        
        let firstPlayer = game.currentPlayer
        
        // White player move leftmost pawn
        try! game.currentPlayer.movePiece(fromLocation: BoardLocation(x: 0, y: 1),
                                          toLocation: BoardLocation(x: 0, y: 2))
        
        XCTAssert(game.currentPlayer !== firstPlayer)
        
    }
    
  
    
}
