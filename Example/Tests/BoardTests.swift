//
//  BoardTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 11/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

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
    
    func testGetPiecesReturnsCorrectPieces() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- R P Q G B K -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )

        let pieces = board.board.getPieces(color: .white)
        
        board.board.printBoardPieces()
        
        func verifyPieceExistance(piece: Piece) -> () {
            
            let matchingPieces = pieces.filter{
                return $0 == piece
            }
            
            XCTAssert(matchingPieces.count != 0, "No instances of piece with type \(piece.type) and color \(piece.color) found")
            XCTAssert(matchingPieces.count == 1, "Multiple instances of piece with type \(piece.type) and color \(piece.color) found")
        }
        
        verifyPieceExistance(piece: Piece(type: .king, color: .white))
        verifyPieceExistance(piece: Piece(type: .queen, color: .white))
        verifyPieceExistance(piece: Piece(type: .rook, color: .white))
        verifyPieceExistance(piece: Piece(type: .bishop, color: .white))
        verifyPieceExistance(piece: Piece(type: .pawn, color: .white))
        verifyPieceExistance(piece: Piece(type: .knight, color: .white))
    }
    
    func testGetKingLocationReturnsCorrectLocation() {
        
        var board = Board(state: .empty)
        
        let whiteLocation = BoardLocation(index: 5)
        let blackLocation = BoardLocation(index: 10)
        
        board.setPiece( Piece(type: .king, color: .white), at: whiteLocation)
        board.setPiece( Piece(type: .king, color: .black), at: blackLocation)
        
        XCTAssert( board.getKingLocation(color: .white) == whiteLocation,
                   "Expected white king to be at location \(whiteLocation)")
        
        XCTAssert( board.getKingLocation(color: .black) == blackLocation,
                   "Expected black king to be at location \(blackLocation)")

    }
    
    func testGetKingReturnsKing() {
        
        let whiteKing = Piece(type: .king, color: .white)
        let blackKing = Piece(type: .king, color: .black)

        var board = Board(state: .empty)
        board.setPiece(whiteKing, at: BoardLocation(index: 0))
        board.setPiece(blackKing, at: BoardLocation(index: 1))
        
        XCTAssert(board.getKing(color: .white) == whiteKing, "Unable to find white king")
        XCTAssert(board.getKing(color: .black) == blackKing, "Unable to find black king")

    }
    
    func testGetLocationsOfColorReturnsCorrectLocations() {
        
        let whiteLocations = [BoardLocation(index: 1), BoardLocation(index: 2), BoardLocation(index: 3)]
        let blackLocations = [BoardLocation(index: 11), BoardLocation(index: 12), BoardLocation(index: 13)]

        var board = Board(state: .empty)
        
        for location in whiteLocations {
            board.setPiece(Piece(type: .pawn, color: .white), at: location)
        }
        
        for location in blackLocations {
            board.setPiece(Piece(type: .pawn, color: .black), at: location)
        }
        
        let returnedWhitelocations = board.getLocationsOfColor(.white)
        XCTAssert(returnedWhitelocations.count == whiteLocations.count,
                  "Expected white count to be \(whiteLocations.count), was \(returnedWhitelocations.count)")
        
        let returnedBlacklocations = board.getLocationsOfColor(.black)
        XCTAssert(returnedBlacklocations.count == blackLocations.count,
                  "Expected white count to be \(blackLocations.count), was \(returnedBlacklocations.count)")
        
        
        for location in whiteLocations {
            
            XCTAssert(
                returnedWhitelocations.filter({ (returnedLocation: BoardLocation) -> Bool in
                    return location == returnedLocation
                }).count == 1,
                "Expected only one location to exist"
            )
        }
        
        
        for location in blackLocations {
            
            XCTAssert(
                returnedBlacklocations.filter({ (returnedLocation: BoardLocation) -> Bool in
                    return location == returnedLocation
                }).count == 1,
                "Expected only one location to exist"
            )
        }
        
    }
    
    func testIsColorInCheckReturnsTrueWhenInCheck() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- Q - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - g - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )

        XCTAssert(board.board.isColorInCheck(color: .black), "Expected king to be in check")
    }
    
    func testIsColorInCheckReturnsFalseWhenNotInCheck() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - Q - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - g - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .black) == false, "Expected king to not be in check")
    }
    
    func testIsColorInCheckMateReturnsTrueWhenInCheckMate() {
        
        let board = ASCIIBoard(pieces:  "- p - - - - - K" +
                                        "- - - - - P - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "r - - - - - - -" +
                                        "r - - G - - - -" )
                                    
        XCTAssert(board.board.isColorInCheckMate(color: .white) == true, "Expected white to be in check mate")
    }
    
    func testIsColorInCheckMateReturnsFalseWhenNotInCheckMate() {
        
        let board = ASCIIBoard(pieces:  "- p - - - - - K" +
                                        "- - - - - P - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheckMate(color: .white) == false, "Expected white to not be in check mate")
    }
    
    func testIsColorInCheckMateReturnsFalseWhenInCheckButNotCheckMate() {
        
        let board = ASCIIBoard(pieces:  "- p - - - - - K" +
                                        "- - - - - P - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "r - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == true, "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInCheckMate(color: .white) == false, "Expected white to not be in check mate")
    }
    
    func testIsColorInCheckMateReturnsFalseWhenInStaleMate() {
        
        let board = ASCIIBoard(pieces:  "- - r - r - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "r - - - - - - -" +
                                        "- - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == false, "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInCheckMate(color: .white) == false, "Expected white to not be in check mate")
    }
    
    func testColorIsInStaleMateReturnsTrueWhenStaleMate() {
        
        let board = ASCIIBoard(pieces:  "- - r - r - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "q - - - - - - -" +
                                        "- - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == false, "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInStalemate(color: .white) == true, "Expected white to be in stale mate")
    }
    
    func testColorIsInStaleMateReturnsFalseWhenStaleMate() {
        
        let board = Board(state: .newGame)
        
        XCTAssert(board.isColorInCheckMate(color: .white) == false, "Expected white to not be in stale mate")
    }


}
