//
//  BoardRaterCenterDominanceTests.swift
//  Example
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterCenterDominanceTests: XCTestCase {
    
    var boardRater: BoardRaterCenterDominance!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        boardRater = BoardRaterCenterDominance(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPiecesWithCenterVisibilityResultsInHigherValueThanPiecesWithoutCenterVisibility() {
        
        let centerVisibleBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - Q" +
                                                    "- - - - - - - R" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" +
                                                    "- - - - - - - -" )
        let centerVisibleRating = boardRater.ratingFor(board: centerVisibleBoard.board, color: .white)
        
        let centerObstructedBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - - -" +
                                                       "- - - - - - P -" +
                                                       "- - - - - - - Q" )
        let centerObstructedRating = boardRater.ratingFor(board: centerObstructedBoard.board, color: .white)
        
        XCTAssertGreaterThan(centerVisibleRating, centerObstructedRating)
    }
    
}
