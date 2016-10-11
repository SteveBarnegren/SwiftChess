//
//  PlayerTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 11/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftChess

class PlayerTests: XCTestCase {
    
     // MARK: - Setup / Tear Down
    let game = Game()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Tests
    
    func testPlayerCannotMovePieceToSameLocation() {
        let location = BoardLocation(index: 0)
        XCTAssert(game.whitePlayer.canMovePiece(fromLocation: location, toLocation: location) == false)
    }
    
    
}
