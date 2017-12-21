//
//  BoardRaterBoardDominanceTests.swift
//  Example
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterBoardDominanceTests: XCTestCase {
    
    var boardRater: BoardRaterBoardDominance!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.boardRater = BoardRaterBoardDominance(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingleQueenResultsInHigherValueThanSinglePawn() {
        
        let queenBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - Q - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" )
        let queenRating = boardRater.ratingFor(board: queenBoard.board, color: .white)

        let pawnBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - P - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" )
        let pawnRating = boardRater.ratingFor(board: pawnBoard.board, color: .white)

        XCTAssertGreaterThan(queenRating, pawnRating)
    }
    
    func testOwnPieceBlockingPathResultsInLowerValue() {
        
        let blockedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "P - - - - - - -" +
                                              "Q P - - - - - -" )
        let blockedRating = boardRater.ratingFor(board: blockedBoard.board, color: .white)
        
        let nonBockedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "Q - - - - - - -" )
        let nonBockedRating = boardRater.ratingFor(board: nonBockedBoard.board, color: .white)
        
        XCTAssertGreaterThan(nonBockedRating, blockedRating)

    }
    
    func testOpponantDominanceResultsInLowerValue() {
        
        let whiteDominantBoard = ASCIIBoard(pieces: "R - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - k" +
                                                    "- - - - - - - p" +
                                                    "Q - - - - - - -" )
        let whiteRating = boardRater.ratingFor(board: whiteDominantBoard.board, color: .white)
        
        let blackDominantBoard = ASCIIBoard(pieces: "r - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - K" +
                                                    "- - - - - - - P" +
                                                    "q - - - - - - -" )
        let blackRating = boardRater.ratingFor(board: blackDominantBoard.board, color: .white)
        
        XCTAssertGreaterThan(whiteRating, blackRating)
    }
    
    func testQueenInCornerResultsInLowerValueThanQueenInCenter() {
        
        let queenInCornerBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "Q - - - - - - -" )
        let queenInCornerRating = boardRater.ratingFor(board: queenInCornerBoard.board, color: .white)
        
        let queenInCenterBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - Q - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" )
        let queenInCenterRating = boardRater.ratingFor(board: queenInCenterBoard.board, color: .white)
        
        XCTAssertGreaterThan(queenInCenterRating, queenInCornerRating)
    }
}
