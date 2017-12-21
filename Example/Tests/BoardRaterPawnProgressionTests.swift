//
//  BoardRaterPawnProgressionTests.swift
//  Example
//
//  Created by Steven Barnegren on 16/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterPawnProgressionTests: XCTestCase {

    var boardRater: BoardRaterPawnProgression!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        boardRater = BoardRaterPawnProgression(configuration: AIConfiguration(difficulty: .hard))
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testProgressedPawnResultsInHigherRatingForWhitePlayer() {

        let progressedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                 "- P - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" )
        
        let lessProgressedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- P - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" )
        
        let progressedRating = boardRater.ratingFor(board: progressedBoard.board, color: .white)
        let lessProgressedRating = boardRater.ratingFor(board: lessProgressedBoard.board, color: .white)

        XCTAssert(progressedRating > lessProgressedRating)
    }
    
    func testProgressedPawnResultsInHigherRatingForBlackPlayer() {
        
        let progressedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- p - - - - - -" +
                                                 "- - - - - - - -" )
        
        let lessProgressedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- p - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" )
        
        let progressedRating = boardRater.ratingFor(board: progressedBoard.board, color: .black)
        let lessProgressedRating = boardRater.ratingFor(board: lessProgressedBoard.board, color: .black)
        
        XCTAssert(progressedRating > lessProgressedRating)
    }
    
    func testWhitePawnsOnStartingRowResultInZeroRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- P - P - - P -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertEqual(rating, 0, accuracy: 0.0001)
    }
    
    func testBlackPawnsOnStartingRowResultInZeroRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- p - p - - p -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .black)
        
        XCTAssertEqual(rating, 0, accuracy: 0.0001)
    }
    
    func testWhiteAndBlackPawnRelativeSquaresResultInTheSameValue() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - p" +
                                       "P - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let whiteRating = boardRater.ratingFor(board: board.board, color: .white)
        let blackRating = boardRater.ratingFor(board: board.board, color: .black)
        
        XCTAssertEqual(whiteRating, blackRating, accuracy: 0.0001)
    }
    
    func testTotalWhiteAndBlackRowsValueAreEqual() {
        
        let board = ASCIIBoard(pieces: "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" +
                                       "P - - - - - - p" )
        
        let whiteRating = boardRater.ratingFor(board: board.board, color: .white)
        let blackRating = boardRater.ratingFor(board: board.board, color: .black)
        
        XCTAssertEqual(whiteRating, blackRating, accuracy: 0.0001)
    }
    
}
