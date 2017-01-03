//
//  AIConfigurationTests.swift
//  Example
//
//  Created by Steve Barnegren on 03/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

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
        
        let board = ASCIIBoard(pieces:  "- - - - g - - -" +
                                        "- - - p p p - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "P P P P P P P P" +
                                        "R K B Q G B K R" )

        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCountPiecesWeighting = 1
        let lowValueRater = BoardRaterCountPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCountPiecesWeighting = 2
        let highValueRater = BoardRaterCountPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Board Dominance
    
    func testBoardDominanceWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces:  "- - - - g - - -" +
                                        "- - - p p p - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- P - - - P P -" +
                                        "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterBoardDominanceWeighting = 1
        let lowValueRater = BoardRaterBoardDominance(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterBoardDominanceWeighting = 2
        let highValueRater = BoardRaterBoardDominance(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Center Ownership
    
    func testCenterOwnershipWeightingAffectsRating() {
        
        let board = ASCIIBoard(pieces:  "- - - r g r - -" +
                                        "- - - p p p - -" +
                                        "- - - - - - - -" +
                                        "- - - Q B - - -" +
                                        "- - - K P - - -" +
                                        "- - - - - - - -" +
                                        "- P - - - P P -" +
                                        "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCenterOwnershipWeighting = 1
        let lowValueRater = BoardRaterCenterOwnership(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCenterOwnershipWeighting = 2
        let highValueRater = BoardRaterCenterOwnership(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Center Dominance
    
    func testCenterDominanceWeightingAffetsRating() {
        
        let board = ASCIIBoard(pieces:  "- - - r g r - -" +
                                        "- - - p p p - -" +
                                        "- - - - - - - -" +
                                        "- - - Q B - - -" +
                                        "- - - K P - - -" +
                                        "- - - - - - - -" +
                                        "- P - - - P P -" +
                                        "R K B Q G B K R" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterCenterDominanceWeighting = 1
        let lowValueRater = BoardRaterCenterDominance(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterCenterDominanceWeighting = 2
        let highValueRater = BoardRaterCenterDominance(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    // MARK: - Board Rater - Threatened Pieces
    
    func testBoardRaterThreatenedPiecesWeightingAffectsRating() {
        
        // White is threatening the black rook with its bishop and knight
        let board = ASCIIBoard(pieces:  "r - - - g - - -" +
                                        "- - - - - - - -" +
                                        "- K - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - G - - B" )
        
        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterThreatenedPiecesWeighting = 1
        let lowValueRater = BoardRaterThreatenedPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterThreatenedPiecesWeighting = 2
        let highValueRater = BoardRaterThreatenedPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        XCTAssertGreaterThan(highValueRating, lowValueRating)
    }
    
    func testBoardRaterThreatenedPiecesOwnPiecesMultiplierAffectsRating() {
        
        // White and black rook are threatening each other, so advantage is neutral
        let board = ASCIIBoard(pieces:  "- - - - g - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "r - - - - - - R" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - G - - -" )

        var lowValueConfig = AIConfiguration()
        lowValueConfig.boardRaterThreatenedPiecesOwnPiecesMultiplier = 1
        let lowValueRater = BoardRaterThreatenedPieces(configuration: lowValueConfig)
        let lowValueRating = lowValueRater.ratingfor(board: board.board, color: .white)
        
        var highValueConfig = AIConfiguration()
        highValueConfig.boardRaterThreatenedPiecesOwnPiecesMultiplier = 2
        let highValueRater = BoardRaterThreatenedPieces(configuration: highValueConfig)
        let highValueRating = highValueRater.ratingfor(board: board.board, color: .white)
        
        // Result should be more negative for a higher value, as white is under threat
        XCTAssertLessThan(highValueRating, lowValueRating)
    }
    
    // TODO: Continue from pawn progression
    
}
