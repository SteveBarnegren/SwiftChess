//
//  OpeningsTests.swift
//  Example
//
//  Created by Steve Barnegren on 31/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class OpeningsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpeningsContainValidMoves() {
        
        let openings = Opening.allOpenings()
        
        for opening in openings {
            
            print("Testing \(opening)")
            
            var board = Board(state: .newGame)
            for (source, target) in opening.moveLocations() {
                
                // Assert that the piece exists
                guard let piece = board.getPiece(at: source) else {
                    XCTFail("No piece at \(source)")
                    break
                }
                
                // Assert the piece can move
                if piece.movement.canPieceMove(from: source, to: target, board: board) {
                    board.movePiece(from: source, to: target)
                } else {
                    XCTFail("Cannot move piece from \(source) to \(target)")
                }
            }
 
        }
    }
    
}
