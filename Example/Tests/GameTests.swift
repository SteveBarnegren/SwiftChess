//
//  GameTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class GameTests: XCTestCase {
    
    var whitePlayer: Human!
    var blackPlayer: Human!
    var game: Game!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        whitePlayer = Human(color: .white)
        blackPlayer = Human(color: .black)
        
        game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Game State Tests
    
    func testGameStateEquatableReturnsCorrectEquability() {
    
        // Match in progress
        XCTAssertTrue(Game.State.inProgress == Game.State.inProgress)

        // Match stale mate
        XCTAssertTrue(Game.State.staleMate(color: .white) == Game.State.staleMate(color: .white))
        XCTAssertTrue(Game.State.staleMate(color: .black) == Game.State.staleMate(color: .black))
        XCTAssertFalse(Game.State.staleMate(color: .white) == Game.State.staleMate(color: .black))
        XCTAssertFalse(Game.State.staleMate(color: .black) == Game.State.staleMate(color: .white))

        // Match won
        XCTAssertTrue(Game.State.won(color: .white) == Game.State.won(color: .white))
        XCTAssertTrue(Game.State.won(color: .black) == Game.State.won(color: .black))
        XCTAssertFalse(Game.State.won(color: .white) == Game.State.won(color: .black))
        XCTAssertFalse(Game.State.won(color: .black) == Game.State.won(color: .white))
        
        // Mismatches
        XCTAssertFalse(Game.State.inProgress == Game.State.won(color: .black))
        XCTAssertFalse(Game.State.inProgress == Game.State.staleMate(color: .white))
        XCTAssertFalse(Game.State.staleMate(color: .white) == Game.State.won(color: .white))

    }
    
    func testGameStartsInProgress() {
        XCTAssertTrue(game.state == Game.State.inProgress)
    }
    
    func testAfterMovesGameIsStillInProgressState() {
        
        // White player moves pawn
        do {
            try whitePlayer.movePiece(fromLocation: BoardLocation(x: 0, y: 1),
                                      toLocation: BoardLocation(x: 0, y: 2))
        } catch {
            XCTFail()
            return
        }
        
        // Black player moves pawn
        do {
            try blackPlayer.movePiece(fromLocation: BoardLocation(x: 7, y: 6),
                                      toLocation: BoardLocation(x: 7, y: 5))
        } catch {
            XCTFail()
            return
        }

        XCTAssertTrue(game.state == Game.State.inProgress)
    }
    
    func testStaleMateScenarioResultsInStaleMateState() {
        
        game = Game(firstPlayer: whitePlayer,
                    secondPlayer: blackPlayer,
                    board: Board.whiteInStaleMateScenario(),
                    colorToMove: .black)
        
        game.playerDidMakeMove(player: blackPlayer, boardOperations: [])
        
        XCTAssertTrue(game.state == Game.State.staleMate(color: .white))
    }
    
    func testCheckMateScenarioResultsInWonState() {
        
        game = Game(firstPlayer: whitePlayer,
                    secondPlayer: blackPlayer,
                    board: Board.whiteInCheckMateScenario(),
                    colorToMove: .black)
        
        game.playerDidMakeMove(player: blackPlayer, boardOperations: [])
        
        XCTAssertTrue(game.state == Game.State.won(color: .black))
    }
    
}
