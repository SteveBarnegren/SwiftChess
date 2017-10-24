//
//  BoardRaterCountPieces.swift
//  Example
//
//  Created by Steve Barnegren on 26/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterCountPiecesTests: XCTestCase {
    
    var boardRater: BoardRaterCountPieces!
    
    override func setUp() {
        super.setUp()
        
        // Initiailise a new board rater for each test
        boardRater = BoardRaterCountPieces(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWhiteWinningResultsInPositiveValue() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "P P P P P P P P" +
                                       "R K B Q G B K R" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        XCTAssert(rating > 0, "Expected rating to be positive")
    }
    
    func testWhiteLosingResultsInNegativeValue() {
        
        let board = ASCIIBoard(pieces: "r k b q g b k r" +
                                       "p p p p p p p p" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = boardRater.ratingfor(board: board.board, color: .white)
        XCTAssert(rating < 0, "Expected rating to be negative")
    }
    
    func testGreaterNumberOfPiecesResultsInHigherValue() {
        
        let fewerPiecesBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "- - - - - - - -" +
                                                  "P P P P P P P P" )
        
        let morePiecesBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "P P P P P P P P" +
                                                 "P P P P P P P P" )
        
        let fewerPiecesRating = boardRater.ratingfor(board: fewerPiecesBoard.board, color: .white)
        let morePiecesRating = boardRater.ratingfor(board: morePiecesBoard.board, color: .white)
        XCTAssert(morePiecesRating > fewerPiecesRating, "Expected more pieces to produce higher rating")
    }
    
    func testHigherValuePiecesResultsInHigherRating() {
        
        let lowerValuePiecesBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "P P P - - - - -" )
        
        let higherValuePiecesBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "- - - - - - - -" +
                                                        "R R R - - - - -" )
        
        let lowerValuePiecesRating = boardRater.ratingfor(board: lowerValuePiecesBoard.board, color: .white)
        let higherValuePiecesRating = boardRater.ratingfor(board: higherValuePiecesBoard.board, color: .white)
        XCTAssert(higherValuePiecesRating > lowerValuePiecesRating,
                  "Expected higher value pieces to produce higher rating")
    }
    
    // MARK: - Perfomance
    
    func testRatingPerformance() {
        
        let board = Board(state: .newGame)
    
        self.measure {
            for _ in 0..<1000 {
                _ = self.boardRater.ratingfor(board: board, color: .white)
            }
        }
    }
    
}
