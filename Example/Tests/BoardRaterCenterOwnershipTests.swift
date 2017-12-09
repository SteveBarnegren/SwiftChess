//
//  BoardRaterCenterDominanceTests.swift
//  Example
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class BoardRaterCenterOwnershipTests: XCTestCase {
    
    var boardRater: BoardRaterCenterOwnership!
    
    override func setUp() {
        super.setUp()
        
        boardRater = BoardRaterCenterOwnership(configuration: AIConfiguration(difficulty: .hard))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCenterReturnsHigherValueThatSide() {
                
        let centerBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - P - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" +
                                             "- - - - - - - -" )
        
        let centerRating = boardRater.ratingFor(board: centerBoard.board, color: .white)
        
        let sideBoard = ASCIIBoard(pieces: "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - P -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" +
                                           "- - - - - - - -" )
        
        let sideRating = boardRater.ratingFor(board: sideBoard.board, color: .white)
        
        XCTAssertGreaterThan(centerRating, sideRating)
    }
    
}
