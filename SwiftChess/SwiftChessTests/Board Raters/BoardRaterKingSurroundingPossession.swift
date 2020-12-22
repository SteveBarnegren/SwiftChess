//
//  BoardRaterKingSurroundingPossession.swift
//  Example
//
//  Created by Steve Barnegren on 29/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

// swiftlint:disable type_body_length
// swiftlint:disable file_length

import XCTest
@testable import SwiftChess

class BoardRaterKingSurroundingPossessionTests: XCTestCase {
    
    var boardRater: BoardRaterKingSurroundingPossession!
    
    override func setUp() {
        super.setUp()
        
        boardRater = BoardRaterKingSurroundingPossession(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test obtaining surrounding spaces
    
    func assertSurroundingSpacesAreCorrect(color: Color, board: ASCIIBoard) {
        
        let indexes = board.indexesWithCharacter("*")
        let surroundingLocations = self.boardRater.locationsSurroundingKing(color: color, board: board.board)
        
        XCTAssertEqual(indexes.count, surroundingLocations.count,
                       "Expected same: (\(indexes.count) indexes \(surroundingLocations.count) surrounding locations).")
        
        for index in indexes {
            
            let location = BoardLocation(index: index)
            let foundLocation = surroundingLocations.contains { $0 == location  }
            
            XCTAssertTrue(foundLocation, "Expected location x: \(location.x) y: \(location.y) to be returned")
        }

    }
    
    func testWhiteKingSurroundingSpacesReturnsCorrectIndexesInCenter() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - * * * - - -" +
                                       "- - * K * - - -" +
                                       "- - * * * - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .white, board: board)
    }
    
    func testWhiteKingSurroundingSpacesReturnsCorrectIndexesInBottomLeft() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* * - - - - - -" +
                                       "K * - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .white, board: board)
    }
    
    func testWhiteKingSurroundingSpacesReturnsCorrectIndexesInBottomRight() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - * *" +
                                       "- - - - - - * K" )
        
        assertSurroundingSpacesAreCorrect(color: .white, board: board)
    }
    
    func testWhiteKingSurroundingSpacesReturnsCorrectIndexesInTopLeft() {
        
        let board = ASCIIBoard(pieces: "K * - - - - - -" +
                                       "* * - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .white, board: board)
    }
    
    func testWhiteKingSurroundingSpacesReturnsCorrectIndexesInTopRight() {
        
        let board = ASCIIBoard(pieces: "- - - - - - * K" +
                                       "- - - - - - * *" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .white, board: board)
    }

    func testBlackKingSurroundingSpacesReturnsCorrectIndexesInCenter() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - * * * - - -" +
                                       "- - * k * - - -" +
                                       "- - * * * - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .black, board: board)
    }
    
    func testBlackKingSurroundingSpacesReturnsCorrectIndexesInBottomLeft() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* * - - - - - -" +
                                       "k * - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .black, board: board)
    }
    
    func testBlackKingSurroundingSpacesReturnsCorrectIndexesInBottomRight() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - * *" +
                                       "- - - - - - * k" )
        
        assertSurroundingSpacesAreCorrect(color: .black, board: board)
    }
    
    func testBlackKingSurroundingSpacesReturnsCorrectIndexesInTopLeft() {
        
        let board = ASCIIBoard(pieces: "k * - - - - - -" +
                                       "* * - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .black, board: board)
    }
    
    func testBlackKingSurroundingSpacesReturnsCorrectIndexesInTopRight() {
        
        let board = ASCIIBoard(pieces: "- - - - - - * k" +
                                       "- - - - - - * *" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        assertSurroundingSpacesAreCorrect(color: .black, board: board)
    }

    // MARK: - Test Ratings
    
    func testThatGreaterOpponentPossessionOfOurKingSurroundingsResultsInLowerRating() {
        
        let lowRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "r - - - - - - -" +
                                                "- - - - K - - -" )

        let highRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "r - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - K - - -" )
        
        let lowRating = boardRater.ratingFor(board: lowRatingBoard.board, color: .white)
        let highRating = boardRater.ratingFor(board: highRatingBoard.board, color: .white)
        
        XCTAssertGreaterThan(highRating, lowRating)
    }
    
    func testThatGreaterPossessionOfOurKingSurroundingsResultsInHigherRating() {
        
        let lowRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "R - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - K - - -" )
        
        let highRatingBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                 "- - - - k - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "R - - - - - - -" +
                                                 "- - - - K - - -" )
        
        let lowRating = boardRater.ratingFor(board: lowRatingBoard.board, color: .white)
        let highRating = boardRater.ratingFor(board: highRatingBoard.board, color: .white)
        
        XCTAssertGreaterThan(highRating, lowRating)
    }
    
    func testThatGreaterPossessionOfOpponentKingSurroundingsResultsInHigherRating() {
        
        let lowRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                "- - - - - - - -" +
                                                "R - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - K - - -" )
        
        let highRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                 "R - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - K - - -" )
        
        let lowRating = boardRater.ratingFor(board: lowRatingBoard.board, color: .white)
        let highRating = boardRater.ratingFor(board: highRatingBoard.board, color: .white)
        
        XCTAssertGreaterThan(highRating, lowRating)
    }
    
    func testThatGreaterOpponentPossessionOfOpponentKingSurroundingsResultsInLowerRating() {
        
        let lowRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                "r - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - - - - -" +
                                                "- - - - K - - -" )
        
        let highRatingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                 "- - - - - - - -" +
                                                 "r - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - - - - -" +
                                                 "- - - - K - - -" )
        
        let lowRating = boardRater.ratingFor(board: lowRatingBoard.board, color: .white)
        let highRating = boardRater.ratingFor(board: highRatingBoard.board, color: .white)
        
        XCTAssertGreaterThan(highRating, lowRating)
    }
    
    func testThatBlackandWhiteRatingsAreTheSame() {
        
        let board = ASCIIBoard(pieces: "- - - - k - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "Q - - - - - - b" +
                                       "R - - - p - - q" +
                                       "- n - - K - N -" )
        
        let invertedBoard = ASCIIBoard(pieces: "- - - - K - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "q - - - - - - B" +
                                               "r - - - P - - Q" +
                                               "- N - - k - n -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .white)
        let invertedRating = boardRater.ratingFor(board: invertedBoard.board, color: .black)
        
        XCTAssertEqual(rating, invertedRating, accuracy: 0.01)
    }
    
    func testThatPiecesSurroundingOwnKingResultsInPositiveRatingForWhite() {
        
        let board = ASCIIBoard(pieces: "- - - - k - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P P P - -" +
                                       "- - - P K P - -" )

        let rating = boardRater.ratingFor(board: board.board, color: .white)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testThatPiecesSurroundingOwnKingResultsInPositiveRatingForBlack() {
        
        let board = ASCIIBoard(pieces: "- - - p k p - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - K - - -" )
        
        let rating = boardRater.ratingFor(board: board.board, color: .black)
        XCTAssertGreaterThan(rating, 0)
    }
    
    func testThatPiecesSurroundingOpponentKingResultsInMoreNegativeRatingForWhite() {
        
        let openKingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - K - - -" )
        
        let surroundedKingBoard = ASCIIBoard(pieces: "- - - p k p - -" +
                                                     "- - - p p p - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - K - - -" )
        
        let openKingRating = boardRater.ratingFor(board: openKingBoard.board, color: .white)
        let surroundedKingRating = boardRater.ratingFor(board: surroundedKingBoard.board, color: .white)

        XCTAssertLessThan(surroundedKingRating, openKingRating)
    }
    
    func testThatPiecesSurroundingOpponentKingResultsInMoreNegativeRatingForBlack() {
        
        let openKingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - - - - -" +
                                               "- - - - K - - -" )
        
        let surroundedKingBoard = ASCIIBoard(pieces: "- - - - k - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - - - - - -" +
                                                     "- - - P P P - -" +
                                                     "- - - P K P - -" )

        let openKingRating = boardRater.ratingFor(board: openKingBoard.board, color: .black)
        let surroundedKingRating = boardRater.ratingFor(board: surroundedKingBoard.board, color: .black)
        XCTAssertLessThan(surroundedKingRating, openKingRating)
    }

}
