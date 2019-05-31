//
//  BoardRaterCenterFourOccupationTests.swift
//  Example
//
//  Created by Steve Barnegren on 03/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterCenterFourOccupationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func defaultBoardRater() -> BoardRaterCenterFourOccupation {
        
        let configuration = AIConfiguration(difficulty: .hard)
        let boardRater = BoardRaterCenterFourOccupation(configuration: configuration)
        return boardRater
    }
    
    func testNorthEastCenterSquareResultsInHigherRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - P - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testSouthEastCenterSquareResultsInHigherRating() {
       
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - P - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testSouthWestCenterSquareResultsInHigherRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testNorthWestCenterSquareResultsInHigherRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testNonCenterSquaresResultInZeroRating() {
        
        let board = ASCIIBoard(pieces: "P P P P P P P P" +
                                       "P P P P P P P P" +
                                       "P P P P P P P P" +
                                       "P P P - - P P P" +
                                       "P P P - - P P P" +
                                       "P P P P P P P P" +
                                       "P P P P P P P P" +
                                       "P P P P P P P P" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertEqual(rating, 0, accuracy: 0.01)
    }
    
    func testOpponentOccupationResultsInNegativeRating() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - p p - - -" +
                                       "- - - p p - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let rating = defaultBoardRater().ratingFor(board: board.board, color: .white)
        XCTAssertLessThan(rating, 0)
    }
    
}
