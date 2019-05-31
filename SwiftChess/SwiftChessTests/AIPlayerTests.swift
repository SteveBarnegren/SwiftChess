//
//  AIPlayerTests.swift
//  Example
//
//  Created by Steve Barnegren on 29/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class AIPlayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    // MARK: - Test Cannot move in the check
    
    func makeTestGame(board: Board, colorToMove: Color) -> Game {
        
        let whitePlayer = AIPlayer(color: .white, configuration: AIConfiguration(difficulty: .hard))
        let blackPlayer = AIPlayer(color: .black, configuration: AIConfiguration(difficulty: .hard))
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer, board: board, colorToMove: colorToMove)
        return game
    }
    
    func testKnightCannotPutOwnKingInToCheck() {
        
        let board = ASCIIBoard(pieces: "r - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - * - - - - -" +
                                       "K - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "G - - - - - - -" )
        
        let knightLocation = board.locationOfCharacter("K")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .white)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: knightLocation, to: testLocation))
    }
    
    func testKingCannotMoveInToCheck() {
        
        // This is a complex scenario because it was one that I observed from an actual game
        
        let board = ASCIIBoard(pieces: "r k - - q b - r" +
                                       "p p p g k - - p" +
                                       "- - * p b p - -" +
                                       "P P - - p - p P" +
                                       "- - P - P - - -" +
                                       "- B - - Q P - -" +
                                       "- B - P K G P -" +
                                       "R K - - - - - R" )
        
        let kingLocation = board.locationOfCharacter("g")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .black)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: kingLocation, to: testLocation))
    }
    
    func testPawnCannotPutOwnKingInToCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - * - - - -" +
                                       "G - - P - - - r" +
                                       "- - - - - - - -" )
        
        let pawnLocation = board.locationOfCharacter("P")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .white)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: pawnLocation, to: testLocation))

    }
    
    func testQueenCannotPutOwnKingInToCheck() {
        
        let board = ASCIIBoard(pieces: "- - - * - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "G - - Q - - - r" +
                                       "- - - - - - - -" )
        
        let queenLocation = board.locationOfCharacter("Q")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .white)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: queenLocation, to: testLocation))
    }
    
    func testRookCannotPutOwnKingInToCheck() {
        
        let board = ASCIIBoard(pieces: "- - - * - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "G - - R - - - r" +
                                       "- - - - - - - -" )
        
        let rookLocation = board.locationOfCharacter("R")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .white)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: rookLocation, to: testLocation))
    }
    
    func testBishopCannotPutOwnKingInToCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - *" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "G - - B - - - r" +
                                       "- - - - - - - -" )
        
        let bishopLocation = board.locationOfCharacter("B")
        let testLocation = board.locationOfCharacter("*")
        
        let game = makeTestGame(board: board.board, colorToMove: .white)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            fatalError()
        }
        
        XCTAssertFalse(player.canAIMovePiece(from: bishopLocation, to: testLocation))
    }
    
    // MARK: - Dictionary Representable
    
    func testDictionaryRepresentable() {
        
        let whiteEasy = AIPlayer(color: .white,
                                 configuration: AIConfiguration(difficulty: .easy))
        XCTAssertEqual(whiteEasy, whiteEasy.toDictionaryAndBack)
        
        let blackHard = AIPlayer(color: .black,
                                 configuration: AIConfiguration(difficulty: .hard))
        XCTAssertEqual(blackHard, blackHard.toDictionaryAndBack)
    }
}
