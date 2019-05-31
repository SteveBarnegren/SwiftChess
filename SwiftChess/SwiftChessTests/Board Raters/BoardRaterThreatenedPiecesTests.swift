//
//  BoardRaterThreatenedPiecesTests.swift
//  Example
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

// swiftlint:disable type_body_length

import XCTest
@testable import SwiftChess

class BoardRaterThreatenedPiecesTests: XCTestCase {
    
    var boardRater: BoardRaterThreatenedPieces!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        boardRater = BoardRaterThreatenedPieces(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardRaterThreatededPiecesReturnsNoThreatIfNoOtherPieces() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - Q - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)

        XCTAssertEqual(rating, 0, accuracy: 0.01)
    }
    
    func testBoardRaterThreatenedPiecesReturnsNegativeValueIfThreatened() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "q - - - - - K -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertLessThan(rating, 0)        
    }

    func testBoardRaterThreatenedPiecesReturnsPositiveValueIfThreateningOpponant() {

        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "Q - - - - - k -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(rating, 0)
    }
    
    // MARK: - Get protected pieces tests
    
    func testGetProtectingPiecesReturnsProtectingPieces() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - K - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "- - - - - - R -" +
                                       "- - - B - - - -" )
       
        let expectedIndexes = [
            board.indexOfCharacter("K"),
            board.indexOfCharacter("R"),
            board.indexOfCharacter("B")
        ]
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        let protectingLocations = boardRater.getPieces(protecting: gameBoard.getPiece(at: queenLocation)!,
                                                       on: board.board).map { $0.location }
        
        // Check all of the expected locations appeared in the protecting locations array
        for expectedIndex in expectedIndexes {
            var foundIndex = false
            
            for location in protectingLocations {
                if location == BoardLocation(index: expectedIndex) {
                    foundIndex = true
                }
            }
            
            XCTAssertTrue(foundIndex, "Failed to find expected index \(expectedIndex)")
        }
    
        // Check all of the protecting locations were expected
        for location in protectingLocations {
            var wasExpected = false
            
            for expectedIndex in expectedIndexes {
                if location == BoardLocation(index: expectedIndex) {
                    wasExpected = true
                }
            }
            
            XCTAssertTrue(wasExpected, "Found unexpected protecting location \(location)")
        }
    }
    
    func testGetProtectingPiecesDoesntReturnNonProtectingPiecesOfSameColor() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - K - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "R - - - - - - -" +
                                       "- B - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let protectingPieces = boardRater.getPieces(protecting: gameBoard.getPiece(at: queenLocation)!,
                                                    on: gameBoard)
        
        // None of the pieces are protecting the queen, so expect count to be zero
        XCTAssertTrue(protectingPieces.count == 0)
    }
    
    func testGetProtectingPiecesDoesntReturnThreateningPiecesOfOppositeColor() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - k - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "- - - - - - r -" +
                                       "- - - b - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let protectingPieces = boardRater.getPieces(protecting: gameBoard.getPiece(at: queenLocation)!,
                                                    on: gameBoard)
        
        // The black pieces cannot protect the white queen, so expect count to be zero
        XCTAssertTrue(protectingPieces.count == 0)
    }
    
    func testGetProtectingPiecesDoesntReturnPawnsMovingStraightAhead() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - P -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let protectingPieces = boardRater.getPieces(protecting: gameBoard.getPiece(at: queenLocation)!,
                                                    on: gameBoard)
        
        XCTAssertTrue(protectingPieces.count == 0)

    }
    
    func testGetProtectingPiecesReturnsPawnsMovingDiagonally() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - P - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let protectingPieces = boardRater.getPieces(protecting: gameBoard.getPiece(at: queenLocation)!,
                                                    on: gameBoard)
        
        XCTAssertTrue(protectingPieces.count == 1)
    }
    
    // MARK: - Get threatening pieces tests
    
    func testGetThreateningPiecesReturnsThreateningPieces() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - k - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "- - - - - - r -" +
                                       "- - - b - - - -" )
        
        let expectedIndexes = [
            board.indexOfCharacter("k"),
            board.indexOfCharacter("r"),
            board.indexOfCharacter("b")
            ]
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board

        let threateningLocations = boardRater.getPieces(threatening: gameBoard.getPiece(at: queenLocation)!,
                                                        on: gameBoard).map { $0.location }
        
        // Check all of the expected locations appeared in the protecting locations array
        for expectedIndex in expectedIndexes {
            var foundIndex = false
            
            for location in threateningLocations {
                if location == BoardLocation(index: expectedIndex) {
                    foundIndex = true
                }
            }
            
            XCTAssertTrue(foundIndex, "Failed to find expected index \(expectedIndex)")
        }
        
        // Check all of the protecting locations were expected
        for location in threateningLocations {
            var wasExpected = false
            
            for expectedIndex in expectedIndexes {
                if location == BoardLocation(index: expectedIndex) {
                    wasExpected = true
                }
            }
            
            XCTAssertTrue(wasExpected, "Found unexpected threatening location \(location)")
        }
    }
    
    func testGetThreateningPiecesDoesntReturnNonThreateningPiecesOfOppositeColor() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - k - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "r - - - - - - -" +
                                       "- b - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let threateningPieces = boardRater.getPieces(threatening: gameBoard.getPiece(at: queenLocation)!,
                                                     on: gameBoard)
        
        // None of the pieces are threatening the queen, so expect count to be zero
        XCTAssertTrue(threateningPieces.count == 0)
    }
    
    func testGetThreateningPiecesDoesntReturnProtectingPiecesOfSameColor() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - K - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - Q -" +
                                       "- - - - - - - -" +
                                       "- - - - - - R -" +
                                       "- - - B - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("Q"))
        let gameBoard = board.board
        
        let threateningPieces = boardRater.getPieces(threatening: gameBoard.getPiece(at: queenLocation)!,
                                                     on: gameBoard)
        
        // The white pieces cannot threaten the white queen, so expect count to be zero
        XCTAssertTrue(threateningPieces.count == 0)
    }
    
    func testGetThreateningPiecesDoesntReturnPawnsMovingStraightAhead() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - q -" +
                                       "- - - - - - P -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("q"))
        let gameBoard = board.board
        
        let threateningPieces = boardRater.getPieces(threatening: gameBoard.getPiece(at: queenLocation)!,
                                                     on: gameBoard)
        
        XCTAssertTrue(threateningPieces.count == 0)
    }
    
    func testGetThreateningPiecesReturnsPawnsMovingDiagonally() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - q -" +
                                       "- - - - - P - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let queenLocation = BoardLocation(index: board.indexOfCharacter("q"))
        let gameBoard = board.board
        
        let threateningPieces = boardRater.getPieces(threatening: gameBoard.getPiece(at: queenLocation)!,
                                                     on: gameBoard)
        
        XCTAssertTrue(threateningPieces.count == 1)
    }
    
}
