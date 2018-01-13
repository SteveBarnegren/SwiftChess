//
//  SquareTests.swift
//  SwiftChessExampleTests
//
//  Created by Steve Barnegren on 13/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import SwiftChess

class SquareTests: XCTestCase {
    
    func testDictionaryRepresentable() {
        
        let piece = Piece(type: .bishop, color: .black)
        let squareWithPiece = Square(piece: piece)
        XCTAssertEqual(squareWithPiece, squareWithPiece.toDictionaryAndBack)
        
        let squareWithoutPiece = Square(piece: nil)
        XCTAssertEqual(squareWithoutPiece, squareWithoutPiece.toDictionaryAndBack)
    }
    
}
