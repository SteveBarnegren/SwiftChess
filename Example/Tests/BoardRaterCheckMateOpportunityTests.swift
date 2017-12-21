//
//  BoardRaterCheckMateOpportunityTests.swift
//  Example
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterCheckMateOpportunityTests: XCTestCase {
    
    var boardRater: BoardRaterCheckMateOpportunity!
    
    override func setUp() {
        super.setUp()
        
        boardRater = BoardRaterCheckMateOpportunity(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardWithNoCheckMateOpportuniesResultsInZeroRating() {
        
        let board = Board(state: .newGame)
        let whiteRating = boardRater.ratingFor(board: board, color: .white)
        let blackRating = boardRater.ratingFor(board: board, color: .black)
        
        let accuracy = Double(0.1)
        XCTAssertEqual(whiteRating, 0, accuracy: accuracy)
        XCTAssertEqual(blackRating, 0, accuracy: accuracy)
    }
    
    func testThatOpponentKingCheckMateOpportunityResultsInPositiveRating() {
        
        // White can move the rook at (0, 0) to (0, 7) to put black in check mate
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "- R - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "R - - - G - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testThatOwnKingCheckMateOpportunityResultsInNegativeRating() {
        
        // Black can move the rook at (0, 7) to (0, 0) to put white in check mate
        let board = ASCIIBoard(pieces: "r - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- r - - - - - -" +
                                       "- - - - G - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        XCTAssertLessThan(rating, 0)
    }
    
    func testThatMultipleCheckMateOpportunitiesResultInHigherRating() {
        
        // White can move the rook at (0, 0) to (0, 7) to put black in check mate
        let singleCheckMateBoard = ASCIIBoard(pieces: "- - - - g - - -" +
                                                      "- R - - - - - -" +
                                                      "- - - - - - - -" +
                                                      "- - - - - - - -" +
                                                      "- - - - - - - -" +
                                                      "- - - - - - - -" +
                                                      "- - - - - - - -" +
                                                      "R - - - G - - -" )
        
        // White can also move the rook at (7, 0) to (7, 7) to put black in check mate
        let multipleCheckMateBoard = ASCIIBoard(pieces: "- - - - g - - -" +
                                                        "- R - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "R - - - G - - R" )

        let singleRating = boardRater.ratingFor(board: singleCheckMateBoard.board, color: .white)
        let multipleRating = boardRater.ratingFor(board: multipleCheckMateBoard.board, color: .white)
        
        XCTAssertGreaterThan(multipleRating, singleRating)
    }

}
