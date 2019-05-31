//
//  AIConfigurationTests.swift
//  Example
//
//  Created by Steve Barnegren on 03/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

//swiftlint:disable type_body_length

import XCTest
@testable import SwiftChess

class AIConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Board Rater - Count Pieces
    
    func testBoardRaterCountPiecesWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "P P P P P P P P" +
                                       "R K B Q G B K R" )

        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCountPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                           difficultValue: 1,
                                                                                           multiplier: 10)
        let lowValueRater = BoardRaterCountPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCountPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                            difficultValue: 2,
                                                                                            multiplier: 10)
        let highValueRater = BoardRaterCountPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Board Dominance
    
    func testBoardDominanceWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- P - - - P P -" +
                                       "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterBoardDominanceWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                              difficultValue: 1,
                                                                                              multiplier: 10)
        let lowValueRater = BoardRaterBoardDominance(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterBoardDominanceWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                               difficultValue: 2,
                                                                                               multiplier: 10)
        let highValueRater = BoardRaterBoardDominance(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Center Ownership
    
    func testCenterOwnershipWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces: "- - - r g r - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - Q B - - -" +
                                       "- - - K P - - -" +
                                       "- - - - - - - -" +
                                       "- P - - - P P -" +
                                       "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCenterOwnershipWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                               difficultValue: 1,
                                                                                               multiplier: 10)
        let lowValueRater = BoardRaterCenterOwnership(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCenterOwnershipWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                difficultValue: 2,
                                                                                                multiplier: 10)
        let highValueRater = BoardRaterCenterOwnership(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Center Dominance
    
    func testCenterDominanceWeightingAffetsRating() {
        
        let board = ASCIIBoard(pieces: "- - - r g r - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - Q B - - -" +
                                       "- - - K P - - -" +
                                       "- - - - - - - -" +
                                       "- P - - - P P -" +
                                       "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCenterDominanceWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                               difficultValue: 1,
                                                                                               multiplier: 10)
        let lowValueRater = BoardRaterCenterDominance(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCenterDominanceWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                difficultValue: 2,
                                                                                                multiplier: 10)
        let highValueRater = BoardRaterCenterDominance(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Threatened Pieces
    
    func testBoardRaterThreatenedPiecesWeightingAffectsRating() {
        
        // White is threatening the black rook with its bishop and knight
        let board = ASCIIBoard(pieces: "r - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- K - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - G - - B" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterThreatenedPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                                difficultValue: 1,
                                                                                                multiplier: 10)
        let lowValueRater = BoardRaterThreatenedPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterThreatenedPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                 difficultValue: 2,
                                                                                                 multiplier: 10)
        let highValueRater = BoardRaterThreatenedPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    func testBoardRaterThreatenedPiecesOwnPiecesWeightingAffectsRating() {
        
        // White and black rook are threatening each other, so advantage is neutral
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "r - - - - - - R" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - G - - -" )

        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterThreatenedPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                                difficultValue: 1,
                                                                                                multiplier: 10)
        let lowValueRater = BoardRaterThreatenedPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterThreatenedPiecesWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                 difficultValue: 2,
                                                                                                 multiplier: 10)
        let highValueRater = BoardRaterThreatenedPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        // Result should be more negative for a higher value, as white is under threat
        XCTAssertLessThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Pawn Progression
    
    func testPawnProgressionWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "p p p p p p p p" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "P P P P P P P P" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - G - - -" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterPawnProgressionWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                               difficultValue: 1,
                                                                                               multiplier: 10)
        let lowValueRater = BoardRaterPawnProgression(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterPawnProgressionWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                difficultValue: 2,
                                                                                                multiplier: 10)
        let highValueRater = BoardRaterPawnProgression(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - King Surrounding Possession
    
    func testKingSurroundingPossessionWeightingAffectsRating() {
    
        let board = ASCIIBoard(pieces: "- - - - g - - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P P P - -" +
                                       "- - - P G P - -" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterKingSurroundingPossessionWeighting =
            AIConfiguration.ConfigurationValue(easyValue: 1,
                                               difficultValue: 1,
                                               multiplier: 10)
        let lowValueRater = BoardRaterKingSurroundingPossession(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterKingSurroundingPossessionWeighting =
            AIConfiguration.ConfigurationValue(easyValue: 2,
                                               difficultValue: 2,
                                               multiplier: 10)
        let highValueRater = BoardRaterKingSurroundingPossession(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Check Mate Opportunity
    
    func testCheckMateOpportunityWeightingAffectsRating() {
        
        // White can move Rook at (0,0) to (0,7) to check mate black
        let board = ASCIIBoard(pieces: "- - - - g p - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P P P - -" +
                                       "R - - P G P - -" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCheckMateOpportunityWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                                    difficultValue: 1,
                                                                                                    multiplier: 1)
        let lowValueRater = BoardRaterCheckMateOpportunity(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCheckMateOpportunityWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                     difficultValue: 2,
                                                                                                     multiplier: 1)
        let highValueRater = BoardRaterCheckMateOpportunity(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
        
    }
    
    // MARK: - Board Rater - Center Four Occupation
    
    func testCenterFourOccupationWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces: "- - - p g p - -" +
                                       "- - - p p p - -" +
                                       "- - - - - - - -" +
                                       "- - - K R - - -" +
                                       "- - - Q R - - -" +
                                       "- - - - - - - -" +
                                       "- - - P P P - -" +
                                       "- - - P G P - -" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCenterFourOccupationWeighting = AIConfiguration.ConfigurationValue(easyValue: 1,
                                                                                                    difficultValue: 1,
                                                                                                    multiplier: 1)
        let lowValueRater = BoardRaterCenterFourOccupation(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingFor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCenterFourOccupationWeighting = AIConfiguration.ConfigurationValue(easyValue: 2,
                                                                                                     difficultValue: 2,
                                                                                                     multiplier: 1)
        let highValueRater = BoardRaterCenterFourOccupation(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingFor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - AIConfiguration Dictionary Representable
    
    func testDictionaryRepresentable() {
        
        let easy = AIConfiguration(difficulty: .easy)
        XCTAssertEqual(easy, easy.toDictionaryAndBack)
        
        let medium = AIConfiguration(difficulty: .medium)
        XCTAssertEqual(medium, medium.toDictionaryAndBack)
        
        let hard = AIConfiguration(difficulty: .hard)
        XCTAssertEqual(hard, hard.toDictionaryAndBack)
    }
}
