//
//  PerformanceTests.swift
//  Example
//
//  Created by Steve Barnegren on 02/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class PerformanceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPawnMoveValidationPerformance() {
        
        let board = Board(state: .newGame)
        let pawnLocation = BoardLocation(x: 0, y: 1)
        
        guard let pawn = board.getPiece(at: pawnLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(pawn.type == .pawn)
        
        self.measure {
            
            BoardLocation.all.forEach{
                pawn.movement.canPieceMove(fromLocation: pawnLocation,
                                           toLocation: $0,
                                           board: board)
            }
        }
    }
    
    func testQueenMoveValidationPerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - g" +
                                            "- - - R - - p -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - Q - - - r" +
                                            "- - - - - - - -" +
                                            "P P - - - - - -" +
                                            "G - - - - - - -" )

        let queenLocation = asciiBoard.locationOfCharacter("Q")
        let board = asciiBoard.board
        
        guard let queen = board.getPiece(at: queenLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(queen.type == .queen)
        
        self.measure {
            
            BoardLocation.all.forEach{
                queen.movement.canPieceMove(fromLocation: queenLocation,
                                            toLocation: $0,
                                            board: board)
            }
        }
    }
    
    func testKingMoveValidationPerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - g" +
                                            "- - - R - - p -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - Q - - - r" +
                                            "- - - - - - - -" +
                                            "- - - P - - - -" +
                                            "- - - G - - - -" )
        
        let kingLocation = asciiBoard.locationOfCharacter("G")
        let board = asciiBoard.board
        
        guard let king = board.getPiece(at: kingLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(king.type == .king)
        
        self.measure {
            
            BoardLocation.all.forEach{
                king.movement.canPieceMove(fromLocation: kingLocation,
                                            toLocation: $0,
                                            board: board)
            }
        }
    }
    
    func testKnightMoveValidationPerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - g" +
                                            "- - - R - - p -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - Q - K - r" +
                                            "- - - - - - - -" +
                                            "- - - P - - - -" +
                                            "- - - G - - - -" )
        
        let knightLocation = asciiBoard.locationOfCharacter("K")
        let board = asciiBoard.board
        
        guard let knight = board.getPiece(at: knightLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(knight.type == .knight)
        
        self.measure {
            
            BoardLocation.all.forEach{
                knight.movement.canPieceMove(fromLocation: knightLocation,
                                             toLocation: $0,
                                             board: board)
            }
        }
    }
    
    func testBishopMoveValidationPerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - g" +
                                            "- - - R - - p -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - Q - K - r" +
                                            "- - - - - B - -" +
                                            "- - - P - - - -" +
                                            "- - - G - - - -" )
        
        let bishopLocation = asciiBoard.locationOfCharacter("B")
        let board = asciiBoard.board
        
        guard let bishop = board.getPiece(at: bishopLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(bishop.type == .bishop)
        
        self.measure {
            
            BoardLocation.all.forEach{
                bishop.movement.canPieceMove(fromLocation: bishopLocation,
                                             toLocation: $0,
                                             board: board)
            }
        }
    }
    
    func testRookMoveValidationPerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - g" +
                                            "- - - - - - p -" +
                                            "- - - - - - - -" +
                                            "- R - - - - - -" +
                                            "- - - Q - K - r" +
                                            "- - - - - B - -" +
                                            "- - - P - - - -" +
                                            "- - - G - - - -" )
        
        let rookLocation = asciiBoard.locationOfCharacter("R")
        let board = asciiBoard.board
        
        guard let rook = board.getPiece(at: rookLocation) else {
            XCTFail()
            return
        }
        
        XCTAssert(rook.type == .rook)
        
        self.measure {
            
            BoardLocation.all.forEach{
                rook.movement.canPieceMove(fromLocation: rookLocation,
                                           toLocation: $0,
                                           board: board)
            }
        }
    }
    
    func testCanAnyPieceMovePerformance() {
        
        let asciiBoard = ASCIIBoard(pieces: "r - b q g b - r" +
                                            "p p p - - p - -" +
                                            "k - - - p - - k" +
                                            "- - - p - - - -" +
                                            "- - - P - - - -" +
                                            "K - - - P - - -" +
                                            "P P P - - P P -" +
                                            "R - B Q G B K R" )
        
        let board = asciiBoard.board;
        
        self.measure {
            
            BoardLocation.all.forEach{
                board.canColorMoveAnyPieceToLocation(color: .white, location: $0)
                board.canColorMoveAnyPieceToLocation(color: .black, location: $0)
            }
        }
        
        
    }

    


    
}
