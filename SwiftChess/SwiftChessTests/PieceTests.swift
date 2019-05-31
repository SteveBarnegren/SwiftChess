//
//  PieceTests.swift
//  Example
//
//  Created by Steve Barnegren on 26/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

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
                continue
            }
            
            XCTAssertFalse(foundTags.contains(piece.tag), "Expected all pieces to have unique tags")
            foundTags.append(piece.tag)
        }
    }
    
    // MARK: - DictionaryRepresentable
    
    func testPieceDictionaryRepresentable() {
        
        var piece1 = Piece(type: .pawn, color: .white)
        piece1.tag = 0
        piece1.hasMoved = false
        piece1.canBeTakenByEnPassant = false
        piece1.location = BoardLocation(index: 0)
        XCTAssertEqual(piece1, piece1.toDictionaryAndBack)
        
        var piece2 = Piece(type: .bishop, color: .black)
        piece2.tag = 15
        piece2.hasMoved = true
        piece2.canBeTakenByEnPassant = true
        piece2.location = BoardLocation(index: 15)
        XCTAssertEqual(piece2, piece2.toDictionaryAndBack)
    }
    
}
