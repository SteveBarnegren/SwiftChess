//
//  PieceTests.swift
//  Example
//
//  Created by Steve Barnegren on 26/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftChess

class PieceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllPiecesHaveUniqueTags() {
        
        let board = Board(state: .newGame)
        
        var foundTags = [Int]()
        
        for square in board.squares {
            
            guard let piece = square.piece else {
                continue;
            }
            
            XCTAssertFalse(foundTags.contains(piece.tag), "Expected all pieces to have unique tags")
            foundTags.append(piece.tag)
        }
    }
    
}
