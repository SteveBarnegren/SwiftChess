//
//  BoardTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 11/10/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

// swiftlint:disable type_body_length
// swiftlint:disable file_length
// swiftlint:disable function_body_length

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
        
        (0..<64).forEach {
            let piece = board.getPiece(at: BoardLocation(index: $0))
            XCTAssert(piece == nil, "Expected piece at index \($0) to be nil")
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
            (59, .queen, .black),
            (60, .king, .black),
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
            (55, .pawn, .black)
            
        ]
        
        let board = Board(state: .newGame)

        for expectedPiece in expectedPieces {
            
            guard let piece = board.getPiece(at: BoardLocation(index: expectedPiece.index)) else {
                XCTFail("Expected piece to exist at index: \(expectedPiece.index)")
                return
            }
            
            XCTAssert(piece.type == expectedPiece.type,
                      "Expected idx \(expectedPiece.index) to be type \(expectedPiece.type), but was \(piece.type)")
            XCTAssert(piece.color == expectedPiece.color,
                      "Expected idx \(expectedPiece.index) to be color \(expectedPiece.color), but was \(piece.color)")
        }
    }
    
    // MARK: - Board Location
    
    func testBoardLocationStrideToReturnsExpectedStride() {
    
        let fromLocation = BoardLocation(x: 1, y: 1)
        let toLocation = BoardLocation(x: 3, y: 4)
        
        let stride = fromLocation.strideTo(location: toLocation)
        XCTAssertEqual(stride.x, 2)
        XCTAssertEqual(stride.y, 3)
    }
    
    func testBoardLocationStrideFromReturnsExpectedStride() {
        
        let fromLocation = BoardLocation(x: 1, y: 1)
        let toLocation = BoardLocation(x: 3, y: 4)
        
        let stride = toLocation.strideFrom(location: fromLocation)
        XCTAssertEqual(stride.x, 2)
        XCTAssertEqual(stride.y, 3)
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
        
        XCTAssert(returnedPiece.isSameTypeAndColor(asPiece: piece), "Expected pieces to be the same")
        
    }
    
    func testRemovePieceRemovesPiece() {
        
        var board = Board(state: .newGame)
        let location = BoardLocation(index: 10)
        board.setPiece(Piece(type: .pawn, color: .white),
                             at: location)
        board.removePiece(at: location)
        
        XCTAssertNil(board.getPiece(at: location))
    }
    
    func testMovePieceResultsInPieceMoved() {
        
        var board = Board(state: .empty)
        
        let piece = Piece(type: .king, color: .black)
        
        let startLocation = BoardLocation(index: 10)
        let endLocation = BoardLocation(index: 20)
        
        board.setPiece(piece, at: startLocation)
        board.movePiece(from: startLocation, to: endLocation)
        
        guard let returnedPiece = board.getPiece(at: endLocation) else {
            XCTFail("Expected piece to exist at location")
            return
        }
        
        XCTAssert(returnedPiece.isSameTypeAndColor(asPiece: piece), "Expected pieces to be the same")

    }
    
    func testPieceHasMovedPropertyIsFalseForNewBoard() {
        
        let board = Board(state: .newGame)
        
        let whitePieces = board.getPieces(color: .white)
        let blackPieces = board.getPieces(color: .black)
        let allPieces = whitePieces + blackPieces
        
        allPieces.forEach {
            XCTAssertFalse($0.hasMoved)
        }
    }
    
    func testMovePieceChangesPieceHasMovedProperty() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* - - - - - - -" +
                                       "W - - - - - - -" +
                                       "- - - - - - - -" )
        
        let fromLocation = board.locationOfCharacter("W")
        let toLocation = board.locationOfCharacter("*")
        
        var gameBoard = board.board
        
        gameBoard.movePiece(from: fromLocation, to: toLocation)
        
        guard let piece = gameBoard.getPiece(at: toLocation) else {
            XCTFail("Couldn't find piece at new position")
            return
        }
        
        XCTAssertTrue(piece.hasMoved, "Expected piece hasMoved property to be true")

    }
    
    func testGetPiecesReturnsCorrectPieces() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- R P Q G B K -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )

        let pieces = board.board.getPieces(color: .white)
        
        board.board.printBoardPieces()
        
        func verifyPieceExistance(piece: Piece) {
            
            let matchingPieces = pieces.filter {
                return $0.isSameTypeAndColor(asPiece: piece)
            }
            
            XCTAssert(matchingPieces.count != 0,
                      "No instances of piece with type \(piece.type) and color \(piece.color) found")
            XCTAssert(matchingPieces.count == 1,
                      "Multiple instances of piece with type \(piece.type) and color \(piece.color) found")
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
        
        XCTAssert(board.getKing(color: .white).isSameTypeAndColor(asPiece: whiteKing), "Unable to find white king")
        XCTAssert(board.getKing(color: .black).isSameTypeAndColor(asPiece: blackKing), "Unable to find black king")

    }
    
    func testGetLocationsOfColorReturnsCorrectLocations() {
        
        let whiteLocations = [BoardLocation(index: 1), BoardLocation(index: 2), BoardLocation(index: 3)]
        let blackLocations = [BoardLocation(index: 11), BoardLocation(index: 12), BoardLocation(index: 13)]

        var board = Board(state: .empty)
        
        whiteLocations.forEach {
            board.setPiece(Piece(type: .pawn, color: .white), at: $0)
        }
        
        blackLocations.forEach {
            board.setPiece(Piece(type: .pawn, color: .black), at: $0)
        }
        
        let returnedWhitelocations = board.getLocations(of: .white)
        XCTAssertEqual(whiteLocations.count, returnedWhitelocations.count)
        
        let returnedBlacklocations = board.getLocations(of: .black)
        XCTAssertEqual(blackLocations.count, returnedBlacklocations.count)
        
        whiteLocations.forEach { (location) in
            XCTAssertEqual(returnedWhitelocations.filter { location == $0 }.count, 1)
        }
        
        blackLocations.forEach { (location) in
            XCTAssertEqual(returnedBlacklocations.filter { location == $0 }.count, 1)
        }
    }
    
    func testIsColorInCheckReturnsTrueWhenInCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
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
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
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
        
        let board = ASCIIBoard(pieces: "- p - - - - - K" +
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
        
        let board = ASCIIBoard(pieces: "- p - - - - - K" +
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
        
        let board = ASCIIBoard(pieces: "- p - - - - - K" +
                                       "- - - - - P - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "r - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == true,
                  "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInCheckMate(color: .white) == false,
                  "Expected white to not be in check mate")
    }
    
    func testIsColorInCheckMateReturnsFalseWhenInStaleMate() {
        
        let board = ASCIIBoard(pieces: "- - r - r - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "r - - - - - - -" +
                                       "- - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == false,
                  "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInCheckMate(color: .white) == false,
                  "Expected white to not be in check mate")
    }
    
    func testColorIsInStaleMateReturnsTrueWhenStaleMate() {
        
        let board = ASCIIBoard(pieces: "- - r - r - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "q - - - - - - -" +
                                       "- - - G - - - -" )
        
        XCTAssert(board.board.isColorInCheck(color: .white) == false,
                  "Expected white to not be in check - test may be set up incorrectly")
        XCTAssert(board.board.isColorInStalemate(color: .white) == true,
                  "Expected white to be in stale mate")
    }
    
    func testColorIsInStaleMateReturnsFalseWhenStaleMate() {
        
        let board = Board(state: .newGame)
        
        XCTAssert(board.isColorInCheckMate(color: .white) == false, "Expected white to not be in stale mate")
    }
    
    // Get Promotable pawns
    
    func testGetWhitePromotablePawnsReturnsLastAllWhiteFinalRowPawns() {
        
        let board = ASCIIBoard(pieces: "P P P P P P P P" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )

        let promotable = board.board.getLocationsOfPromotablePawns(color: .white)
        
        XCTAssert(promotable.count == 8)
    }
    
    func testGetWhitePromotablePawnsReturnsDoesntReturnWhiteNonPawns() {
        
        let board = ASCIIBoard(pieces: "B K G R R R Q B" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .white)
        
        XCTAssert(promotable.count == 0)
    }
    
    func testGetWhitePromotablePawnsDoesntReturnBlackPawns() {
        
        let board = ASCIIBoard(pieces: "p p p p p p p p" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .white)
        
        XCTAssert(promotable.count == 0)
    }
    
    func testGetWhitePromotablePawnsDoesntReturnNonPromotableWhitePawns() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "P - - - - P - -" +
                                       "- - - P - - - -" +
                                       "- - - - - P - -" +
                                       "- - - - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - P" +
                                       "- - - - - - - -" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .white)
        
        XCTAssert(promotable.count == 0)
    }
    
    func testGetBlackPromotablePawnsReturnsLastAllBlackFinalRowPawns() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "p p p p p p p p" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .black)
        
        XCTAssert(promotable.count == 8)
    }
    
    func testGetBlackPromotablePawnsReturnsDoesntReturnBlackNonPawns() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "b k g r r r q b" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .black)
        
        XCTAssert(promotable.count == 0)
    }
    
    func testGetBlackPromotablePawnsDoesntReturnWhitePawns() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "P P P P P P P P" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .black)
        
        XCTAssert(promotable.count == 0)
    }
    
    func testGetBlackPromotablePawnsDoesntReturnNonPromotableBlackPawns() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "p - - - - p - -" +
                                       "- - - p - - - -" +
                                       "- - - - - p - -" +
                                       "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - - - - - p" +
                                       "- - - - - - - -" )
        
        let promotable = board.board.getLocationsOfPromotablePawns(color: .black)
        
        XCTAssert(promotable.count == 0)
    }
    
    // MARK: - Can Castle? Logic
    
    func assertKingAndRookStartLocationsAndColor(kingLocation: BoardLocation,
                                                 rookLocation: BoardLocation,
                                                 color: Color) {
        
        let board = Board(state: .newGame)
        
        guard let king = board.getPiece(at: kingLocation) else {
            XCTFail("Could not find king")
            return
        }
        
        guard let rook = board.getPiece(at: rookLocation) else {
            XCTFail("Could not find king")
            return
        }
        
        // Assert king color and type
        XCTAssert(king.color == color)
        XCTAssert(king.type == .king)
        
        // Assert rook color and type
        XCTAssert(rook.color == color)
        XCTAssert(rook.type == .rook)
    }
    
    func testCastleMoveWhiteKingSideKingAndRookStartLocationsAreCorrect() {
        
        let castleMove = Board.CastleMove(color: .white, side: .kingSide)
        assertKingAndRookStartLocationsAndColor(kingLocation: castleMove.kingStartLocation,
                                                rookLocation: castleMove.rookStartLocation,
                                                color: .white)
    }
    
    func testCastleMoveWhiteQueenSideKingAndRookStartLocationsAreCorrect() {
        
        let castleMove = Board.CastleMove(color: .white, side: .queenSide)
        assertKingAndRookStartLocationsAndColor(kingLocation: castleMove.kingStartLocation,
                                                rookLocation: castleMove.rookStartLocation,
                                                color: .white)
    }
    
    func testCastleMoveBlackKingSideKingAndRookStartLocationsAreCorrect() {
        
        let castleMove = Board.CastleMove(color: .black, side: .kingSide)
        assertKingAndRookStartLocationsAndColor(kingLocation: castleMove.kingStartLocation,
                                                rookLocation: castleMove.rookStartLocation,
                                                color: .black)
    }
    
    func testCastleMoveBlackQueenSideKingAndRookStartLocationsAreCorrect() {
        
        let castleMove = Board.CastleMove(color: .black, side: .queenSide)
        assertKingAndRookStartLocationsAndColor(kingLocation: castleMove.kingStartLocation,
                                                rookLocation: castleMove.rookStartLocation,
                                                color: .black)
    }
    
    func testCanCastle() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - G - - R" )

        XCTAssertTrue(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfKingInIncorrectPostion() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - G - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - R" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfRookInIncorrectPostion() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - R" +
                                       "- - - - G - - -" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }

    func testCannotCastleIfKingHasPreviouslyMoved() {

        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        let startLocation = BoardLocation(index: board.indexOfCharacter("G") )
        let newLocation = BoardLocation(index: 0)
        var gameBoard = board.board
        
        // move then back
        gameBoard.movePiece(from: startLocation, to: newLocation)
        gameBoard.movePiece(from: newLocation, to: startLocation)
        
        XCTAssertFalse(gameBoard.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfRookHasPreviouslyMoved() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        let startLocation = BoardLocation(index: board.indexOfCharacter("R") )
        let newLocation = BoardLocation(index: 0)
        var gameBoard = board.board
        
        // move then back
        gameBoard.movePiece(from: startLocation, to: newLocation)
        gameBoard.movePiece(from: newLocation, to: startLocation)
        
        XCTAssertFalse(gameBoard.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfPiecesAreBetweenKingAndRook() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - P R" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfKingIsInCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - q - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfKingWillMoveThroughCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - - q - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCannotCastleIfKingWillMoveEndUpInCheck() {
        
        let board = ASCIIBoard(pieces: "- - - - - - q -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        XCTAssertFalse(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    func testCanStillCastleIfRookUnderAttack() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - r" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - --" +
                                       "- - - - G - - R" )
        
        XCTAssertTrue(board.board.canColorCastle(color: .white, side: .kingSide))
    }
    
    // MARK: - Perform Castle
    
    func createPerformCastleBoard() -> Board {
        
        let board = ASCIIBoard(pieces: "r - - - g - - r" +
                                       "p p p p p p p p" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "P P P P P P P P" +
                                       "R - - - G - - R" )
        
        return board.board
    }
    
    func testWhiteKingSideCastleUpdatesPiecePositions() {
        
        var board = createPerformCastleBoard()
        board.performCastle(color: .white, side: .kingSide)
        XCTAssert(board.getPiece(at: BoardLocation(x: 6, y: 0))?.type == .king)
        XCTAssert(board.getPiece(at: BoardLocation(x: 5, y: 0))?.type == .rook)
    }
    
    func testWhiteQueenSideCastleUpdatesPiecePositions() {
        
        var board = createPerformCastleBoard()
        board.performCastle(color: .white, side: .queenSide)
        XCTAssert(board.getPiece(at: BoardLocation(x: 2, y: 0))?.type == .king)
        XCTAssert(board.getPiece(at: BoardLocation(x: 3, y: 0))?.type == .rook)
    }
    
    func testBlackKingSideCastleUpdatesPiecePositions() {
        
        var board = createPerformCastleBoard()
        board.performCastle(color: .black, side: .kingSide)
        XCTAssert(board.getPiece(at: BoardLocation(x: 6, y: 7))?.type == .king)
        XCTAssert(board.getPiece(at: BoardLocation(x: 5, y: 7))?.type == .rook)
    }
    
    func testBlackQueenSideCastleUpdatesPiecePositions() {
        
        var board = createPerformCastleBoard()
        board.performCastle(color: .black, side: .queenSide)
        XCTAssert(board.getPiece(at: BoardLocation(x: 2, y: 7))?.type == .king)
        XCTAssert(board.getPiece(at: BoardLocation(x: 3, y: 7))?.type == .rook)
    }
    
    // MARK: - Check hasMoved flag isn't accidentally set
    
    func createHasMovedTestBoard() -> Board {
        
        let board = ASCIIBoard(pieces: "r - - g - - - r" +
                                       "- - p p p - - -" +
                                       "- - - - - q - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- Q - - - - - -" +
                                       "- - - P P P --" +
                                       "R - - - G - - R" )

        return board.board
    }
    
    func areAnyPiecesHasMovedFlagsSet(on board: Board) -> Bool {
        
        for (index, square) in board.squares.enumerated() {
         
            guard let piece = square.piece else {
                continue
            }
            
            if piece.hasMoved {
                print("Has moved flag set at index \(index)")
                return true
            }
        }
        
        return false
    }
    
    func testCheckingForCheckDoesntResultInHasMovedFlagChange() {
        
        let board = createHasMovedTestBoard()
        _ = board.isColorInCheck(color: .white)
        _ = board.isColorInCheck(color: .black)
        
        XCTAssertFalse(areAnyPiecesHasMovedFlagsSet(on: board))
    }
    
    func testCheckingForCheckMateDoesntResultInHasMovedFlagChange() {
        
        let board = createHasMovedTestBoard()
        _ = board.isColorInCheckMate(color: .white)
        _ = board.isColorInCheckMate(color: .black)
        
        XCTAssertFalse(areAnyPiecesHasMovedFlagsSet(on: board))
    }
    
    func testCheckingForStaleMateDoesntResultInHasMovedFlagChange() {
        
        let board = createHasMovedTestBoard()
        _ = board.isColorInStalemate(color: .white)
        _ = board.isColorInStalemate(color: .black)
        
        XCTAssertFalse(areAnyPiecesHasMovedFlagsSet(on: board))
    }
    
    func testCheckingForAbilityToMoveDoesntResultInHasMovedFlagChange() {
        
        let board = createHasMovedTestBoard()
        _ = board.isColorAbleToMove(color: .white)
        _ = board.isColorAbleToMove(color: .black)
        
        XCTAssertFalse(areAnyPiecesHasMovedFlagsSet(on: board))
    }
    
    func testCheckingForAbilityToCastleDoesntResultInHasMovedFlagChange() {
        
        let board = createHasMovedTestBoard()
        _ = board.canColorCastle(color: .white, side: .kingSide)
        _ = board.canColorCastle(color: .white, side: .queenSide)
        _ = board.canColorCastle(color: .black, side: .kingSide)
        _ = board.canColorCastle(color: .black, side: .queenSide)

        XCTAssertFalse(areAnyPiecesHasMovedFlagsSet(on: board))
    }
    
    // MARK: - Test canColorMoveAnyPieceToLocation method
    
    func testCanColorMoveAnyPieceToLocationReturnsYesIfCanMakeMove() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "R - - - - - - *" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let targetLocation = board.locationOfCharacter("*")
        XCTAssertTrue(board.board.canColorMoveAnyPieceToLocation(color: .white, location: targetLocation))
    }
    
    func testCanColorMoveAnyPieceToLocationReturnsFalseIfCannotMakeMove() {
        
        let board = ASCIIBoard(pieces: "B - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "R - - - - - - -" +
                                       "- - - - - - - *" +
                                       "R - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - Q - - - -" )
        
        let targetLocation = board.locationOfCharacter("*")
        XCTAssertFalse(board.board.canColorMoveAnyPieceToLocation(color: .white, location: targetLocation))
    }
    
    func testCanColorMoveAnyPieceToLocationReturnsFalseIfCannotMakeMoveButOpponentCan() {
        
        let board = ASCIIBoard(pieces: "B - - - - - - q" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "R - - - - - - -" +
                                       "- - - - - - - *" +
                                       "R - - - - - - -" +
                                       "- - - - - - k -" +
                                       "- - - Q - - - r" )
        
        let targetLocation = board.locationOfCharacter("*")
        XCTAssertFalse(board.board.canColorMoveAnyPieceToLocation(color: .white, location: targetLocation))
    }
    
    // MARK: - Test doesColorOccupyLocation method
    
    func testDoesColorOccupyLocationReturnsTrueForWhiteOccupation() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - Q - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let location = board.locationOfCharacter("Q")
        XCTAssertTrue(board.board.doesColorOccupyLocation(color: .white, location: location))
    }
    
    func testDoesColorOccupyLocationReturnsTrueForBlackOccupation() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - q - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let location = board.locationOfCharacter("q")
        XCTAssertTrue(board.board.doesColorOccupyLocation(color: .black, location: location))
    }
    
    func testDoesColorOccupyLocationReturnsFalseForWhiteOpponentOccupation() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - q - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let location = board.locationOfCharacter("q")
        XCTAssertFalse(board.board.doesColorOccupyLocation(color: .white, location: location))
    }
    
    func testDoesColorOccupyLocationReturnsFalseForBlackOpponentOccupation() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - Q - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let location = board.locationOfCharacter("Q")
        XCTAssertFalse(board.board.doesColorOccupyLocation(color: .black, location: location))
    }
    
    func testDoesColorOccupyLocationReturnsFalseForNonOccupation() {
        
        let board = Board(state: .empty)
        
        let location = BoardLocation(x: 4, y: 4)
        XCTAssertFalse(board.doesColorOccupyLocation(color: .white, location: location))
        XCTAssertFalse(board.doesColorOccupyLocation(color: .black, location: location))
    }
    
    // MARK: Test Possible Move Locations
    
    func testPossibleMoveLocationsReturnsExpectedLocations() {
        
        let asciiBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                            "- - * - * - - -" +
                                            "- * - - - * - -" +
                                            "- - - K - - - -" +
                                            "- * - - - * - -" +
                                            "- - * - * - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" )
        
        let board = asciiBoard.board
        
        let sourceLocation = asciiBoard.locationOfCharacter("K")
        let locations = board.possibleMoveLocationsForPiece(atLocation: sourceLocation)
        XCTAssertEqual(locations.count, 8)
        
        let expectedLocations = asciiBoard.locationsWithCharacter("*")
        
        expectedLocations.forEach { expectedLocation in
            XCTAssertEqual(locations.filter {$0 == expectedLocation}.count, 1)
        }
    }
    
    // MARK: - Test Board Equality
    
    func testEqualBoardsAreEqual() {
        
        var board1 = Board(state: .newGame)
        var board2 = Board(state: .newGame)
        
        let sourceLocation = BoardLocation(x: 0, y: 1)
        let targetLocation = BoardLocation(x: 0, y: 3)
        
        board1.movePiece(from: sourceLocation, to: targetLocation)
        board2.movePiece(from: sourceLocation, to: targetLocation)
        
        XCTAssertEqual(board1, board2)
    }
    
    func testNonEqualBoardsAreNotEqual() {
        
        var board1 = Board(state: .newGame)
        board1.movePiece(from: BoardLocation(x: 0, y: 1),
                         to: BoardLocation(x: 0, y: 3))
        
        let board2 = Board(state: .newGame)
        
        XCTAssertNotEqual(board1, board2)
    }
    
    // MARK: - Piece Location tests
    
    func testPieceLocationsAreCorrectForNewBoard() {
        
        let board = Board(state: .newGame)
        
        for location in BoardLocation.all {
            
            guard let piece = board.getPiece(at: location) else {
                continue
            }
            
            XCTAssertEqual(piece.location, location)
        }
    }
    
    func testPieceLocationsAreCorrectAfterMoves() {
        
        var board = Board(state: .newGame)
        board.movePiece(from: BoardLocation(gridPosition: .e2),
                        to: BoardLocation(gridPosition: .e4))
        
        board.movePiece(from: BoardLocation(gridPosition: .d7),
                        to: BoardLocation(gridPosition: .d5))

        for location in BoardLocation.all {
            
            guard let piece = board.getPiece(at: location) else {
                continue
            }
            
            XCTAssertEqual(piece.location, location)
        }
    }
    
    // MARK: - Dictionary Representable
    
    func testDictionaryRepresentable() {
        
        let asciiBoard = ASCIIBoard(pieces: "r - - - g - - r" +
                                            "p p p p p p p p" +
                                            "- - - - - - - -" +
                                            "- K - - - b - -" +
                                            "- - B - - - k -" +
                                            "- - - - - - - -" +
                                            "P P P P P P P P" +
                                            "R - - - G - - R" )
    
        let board = asciiBoard.board
        XCTAssertEqual(board, board.toDictionaryAndBack)
    }

}
