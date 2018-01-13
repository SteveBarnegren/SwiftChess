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
            try whitePlayer.movePiece(from: BoardLocation(x: 0, y: 1),
                                      to: BoardLocation(x: 0, y: 2))
        } catch {
            XCTFail("Expected to be able to move piece")
            return
        }
        
        // Black player moves pawn
        do {
            try blackPlayer.movePiece(from: BoardLocation(x: 7, y: 6),
                                      to: BoardLocation(x: 7, y: 5))
        } catch {
            XCTFail("Expected to be able to move piece")
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
    
    // MARK: - Game State Dictionary Representable
    
    func testGameStateDictionaryRepresentable() {
        
        let inProgress = Game.State.inProgress
        XCTAssertEqual(inProgress, inProgress.toDictionaryAndBack)
        
        let whiteStalemate = Game.State.staleMate(color: .white)
        XCTAssertEqual(whiteStalemate, whiteStalemate.toDictionaryAndBack)
        
        let blackStalemate = Game.State.staleMate(color: .black)
        XCTAssertEqual(blackStalemate, blackStalemate.toDictionaryAndBack)
        
        let whiteWon = Game.State.won(color: .white)
        XCTAssertEqual(whiteWon, whiteWon.toDictionaryAndBack)
        
        let blackWon = Game.State.won(color: .black)
        XCTAssertEqual(blackWon, blackWon.toDictionaryAndBack)
    }
    
    // MARK: - Game Dictionary Representable
    
    func testGameDictionaryRepresentable() {
        
        do {
            let whitePlayer = Human(color: .white)
            let blackPlayer = Human(color: .black)
            let board = Board(state: .newGame)
            let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer, board: board, colorToMove: .white)
            XCTAssertEqual(game, game.toDictionaryAndBack)
        }
        
        do {
            let whitePlayer = Human(color: .white)
            let blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: .hard))
            let board = Board(state: .newGame)
            let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer, board: board, colorToMove: .black)
            XCTAssertEqual(game, game.toDictionaryAndBack)
        }
    }
    
}
