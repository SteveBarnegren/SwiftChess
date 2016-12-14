//
//  BoardRaterThreatenedPiecesTests.swift
//  Example
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterThreatenedPiecesTests: XCTestCase {
    
    var boardRater = BoardRaterThreatenedPieces()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        boardRater = BoardRaterThreatenedPieces()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardRaterThreatededPiecesReturnsNoThreatIfNoOpponants() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - Q - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)

        XCTAssertEqualWithAccuracy(rating, 0, accuracy: 0.01)
    }
    
    func testBoardRaterThreatenedPiecesReturnsNoThreatIfOnlySameColorPieces() {
        
        let board = ASCIIBoard(pieces:  "- R - - - - - -" +
                                        "- - - - - K - -" +
                                        "- - - - - - - -" +
                                        "- - - G - - - P" +
                                        "- - Q - - - - -" +
                                        "- - - - - - - -" +
                                        "- P - - - B - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertEqualWithAccuracy(rating, 0, accuracy: 0.01)
    }
    
    func testBoardRaterThreatenedPiecesReturnsNegativeValueIfThreatened() {
        
        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "q - - - - - K -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssert(rating < 0);
    }
    
    func testBoardRaterThreatenedPiecesReturnsPositiveValueIfThreateningOpponant() {

        let board = ASCIIBoard(pieces:  "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "Q - - - - - k -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        
        XCTAssert(rating > 0);
    }
    
    func testBoardRaterThreatenedPiecesReturnsHigherThreatValueForHigherValuePieces() {
        
        let queenBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "q - - - - - Q -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" )
        
        let queenIndex = queenBoard.indexOfCharacter("Q")
        let queenLocation = BoardLocation(index: queenIndex)
        let queenRating = boardRater.threatRatingForPiece(at: queenLocation,
                                                          board: queenBoard.board)
        
        
        
        let knightBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "q - - - - - K -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" )
        
        let knightIndex = knightBoard.indexOfCharacter("K")
        let knightLocation = BoardLocation(index: knightIndex)
        let knightRating = boardRater.threatRatingForPiece(at: knightLocation,
                                                           board: knightBoard.board)
        
        XCTAssert(queenRating > knightRating);
    }
    
    
}
