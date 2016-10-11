//
//  BoardTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 11/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftChess

class BoardTests: XCTestCase {
    
    // MARK: - Setup / Tear Down
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Creation
    
    func testNewEmptyBoardContainsNoPieces() {
        
        let board = Board(state: .empty)
        
        for index in 0..<64 {
            
            let piece = board.getPiece(at: BoardLocation(index: index))
            XCTAssert(piece == nil, "Expected piece at index \(index) to be nil")
        }
    }
    
    func testNewGameBoardContainsCorrectGamePieces() {
        
        let expectedPieces: [(index: Int, type: Piece.PieceType, color: Color)] = [
            
            // white back row
            (0, .rook, .white),
            (1, .knight, .white),
            (2, .bishop, .white),
            (3, .queen, .white),
            (4, .king, .white),
            (5, .bishop, .white),
            (6, .knight, .white),
            (7, .rook, .white),

            // white pawn row
            (8, .pawn, .white),
            (9, .pawn, .white),
            (10, .pawn, .white),
            (11, .pawn, .white),
            (12, .pawn, .white),
            (13, .pawn, .white),
            (14, .pawn, .white),
            (15, .pawn, .white),
            
            // black back row
            (56, .rook, .black),
            (57, .knight, .black),
            (58, .bishop, .black),
            (59, .king, .black),
            (60, .queen, .black),
            (61, .bishop, .black),
            (62, .knight, .black),
            (63, .rook, .black),
            
            // black pawn row
            (48, .pawn, .black),
            (49, .pawn, .black),
            (50, .pawn, .black),
            (51, .pawn, .black),
            (52, .pawn, .black),
            (53, .pawn, .black),
            (54, .pawn, .black),
            (55, .pawn, .black),
            
        ]
        
        let board = Board(state: .newGame);

        for expectedPiece in expectedPieces {
            
            guard let piece = board.getPiece(at: BoardLocation(index: expectedPiece.index)) else {
                XCTFail("Expected piece to exist at index: \(expectedPiece.index)")
                return
            }
            
            XCTAssert(piece.type == expectedPiece.type, "Expected piece at index \(expectedPiece.index) to be type \(expectedPiece.type), but was type \(piece.type)")
            XCTAssert(piece.color == expectedPiece.color, "Expected piece at index \(expectedPiece.index) to be color \(expectedPiece.color), but was color \(piece.color)")
        }
    }
    
    // MARK: - Piece Manipulation
    
    func testSetAndGetPiece() {
        
        var board = Board(state: .empty)
        
        let piece = Piece(type: .king, color: .black)
        let location = BoardLocation(index: 5)
        
        board.setPiece(piece, at: location)
        
        guard let returnedPiece = board.getPiece(at: location) else {
            print("Expected piece to exist at location")
            return
        }
        
        XCTAssert(returnedPiece == piece, "Expected pieces to be the same");
        
    }
    
    func testMovePieceResultsInPieceMoved() {
        
        var board = Board(state: .empty);
        
        let piece = Piece(type: .king, color: .black)
        
        let startLocation = BoardLocation(index: 10)
        let endLocation = BoardLocation(index: 20)
        
        board.setPiece(piece, at: startLocation)
        board.movePiece(fromLocation: startLocation, toLocation: endLocation)
        
        guard let returnedPiece = board.getPiece(at: endLocation) else {
            XCTFail("Expected piece to exist at location")
            return
        }
        
        XCTAssert(returnedPiece == piece, "Expected pieces to be the same")

    }
    
}
