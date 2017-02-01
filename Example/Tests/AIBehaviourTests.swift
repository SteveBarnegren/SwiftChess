//
//  AIBehaviourTests.swift
//  Example
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

/*
 
 AI behaviour tests are tests that try to avoid or encourage certain behaviours in the AI.
 These are complex outcomes, so may require changing several variables to manipulate outcomes.
 */

import XCTest
@testable import SwiftChess

class AIBehaviourTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    func makeGameWithBoard(board: Board, colorToMove: Color) -> Game {
        
        let whitePlayer = AIPlayer(color: .white)
        let blackPlayer = AIPlayer(color: .black)
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer, board: board, colorToMove: colorToMove)
        
        return game
    }
    
    func findMovedPieceLocation(startBoard: Board, endBoard: Board, color: Color) -> BoardLocation {
        
        for location in BoardLocation.all {
            
            let startBoardPiece = startBoard.getPiece(at: location)
            let endBoardPiece = endBoard.getPiece(at: location)
            
            // If there is no end board piece, this is not the location
            if endBoardPiece == nil {
                continue
            }
            
            // If the end piece exists, but start doesn't, it's the moved piece
            if endBoardPiece != nil && startBoardPiece == nil {
                return location
            }
            
            // If both pieces exist, and are not the same, then it's the location
            if endBoardPiece != nil && startBoardPiece != nil {
                
                if endBoardPiece!.color != startBoardPiece!.color
                && endBoardPiece!.type != startBoardPiece!.type{
                    return location
                }
            }
           
            // Else continue - this isn't the location
            continue
        }
        
        fatalError("Failed to find moved location")
        
    }
    
    // MARK: - Scenario Tests
    
    func test_ScenarioOne_BlackShouldNotGiveAwayBishop() {
        
        
        // In the following example, the black player can move the bishop at (5,7) to the * location (2,4).
        // The can look like a good move because the bishop will then threaten the white queen at (3,3).
        // The white queen will also be threatening the black bishop, but because this is a lower value piece black can think that it is in a more preferrable position.
        // In reality, because the black bishop is unprotected, the white queen will take it.
        
        let board = ASCIIBoard(pieces:  "r - b - q b - r" +
                                        "p p g - - p p p" +
                                        "- - - - - k - -" +
                                        "- - * - - - - -" +
                                        "- - p Q P - - -" +
                                        "- - - - - - - -" +
                                        "P P G - - P P P" +
                                        "R K B - - B K R" )
        
        
        let location = board .locationOfCharacter("*")
        
        let game = makeGameWithBoard(board: board.board, colorToMove: .black)
        
        guard let player = game.currentPlayer as? AIPlayer else {
            XCTFail("Expected an AI Player")
            return
        }
        
        player.makeMoveSync()
        
        // If there is not piece at the location, then test has passed
        guard let piece = game.board.getPiece(at: location) else {
            return
        }
        
        // If the piece is not black, or is not a bishop, test passed
        if piece.type != .bishop || piece.color != .black {
            return
        }
        
        // Otherwise, black has moved the bishop to the *, test failed
        XCTFail("Black moved bishop")
    }
    
    func test_ScenarioTwo_BlackShouldTradeKnight() {
        
        // In this example, the black knight at (2, 1) can either take the white rook at (0,0), or trade itself for the white queen at (0,2)
        // Both of these are good moves
        
        let board = ASCIIBoard(pieces:  "- r - - q b k r" +
                                        "p - - g - - p p" +
                                        "- - - - b p - -" +
                                        "- - - - p - - -" +
                                        "- - - p P - - -" +
                                        "Q - - - - - - -" +
                                        "P P k P K P P P" +
                                        "R K B G - - - R" )

        let queenLocation = BoardLocation(x: 0, y: 2)
        let rookLocation = BoardLocation(x: 0, y: 0)
        
        let game = makeGameWithBoard(board: board.board, colorToMove: .black)

        guard let player = game.currentPlayer as? AIPlayer else {
            XCTFail("Expected an AI Player")
            return
        }
        
        player.makeMoveSync()
        
        if let queenLocationPiece = game.board.getPiece(at: queenLocation) {
            
            if queenLocationPiece.color == .black && queenLocationPiece.type == .knight {
                print("PASSED - Black took queen")
                return
            }
        }
        
        if let rookLocationPiece = game.board.getPiece(at: rookLocation) {
            
            if rookLocationPiece.color == .black && rookLocationPiece.type == .knight {
                print("PASSED - black took rook")
                return
            }
        }
        
        let location = findMovedPieceLocation(startBoard: board.board, endBoard: game.board, color: .black)
        
        guard let piece = game.board.getPiece(at: location) else {
            XCTFail("Couldn't find moved piece")
            return
        }
        
        XCTFail("FAILED - Black moved \(piece.type) to (\(location.x),\(location.y))")
    }
    
    
    
    
    
    
    
    
}
