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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCenterReturnsHigherValueThatSide() {
        
        let boardRater = BoardRaterCenterDominance()
        
        let centerBoard = ASCIIBoard(pieces:  "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - P - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" +
                                              "- - - - - - - -" )
        
        let centerRating = boardRater.ratingfor(board: centerBoard.board, color: .white);
        
        let sideBoard = ASCIIBoard(pieces:  "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - P -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" +
                                            "- - - - - - - -" )
        
        let sideRating = boardRater.ratingfor(board: sideBoard.board, color: .white);
        
        XCTAssertGreaterThan(centerRating, sideRating);
    }
    
}
