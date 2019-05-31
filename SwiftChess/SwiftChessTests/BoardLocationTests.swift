//
//  BoardLocationTests.swift
//  Example
//
//  Created by Steve Barnegren on 31/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

//swiftlint:disable function_body_length

import XCTest
@testable import SwiftChess

class BoardLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoardLocationFromGridPositionResultsInCorrectIndex() {
        
        let testCases = [
            // row 1
            (BoardLocation.GridPosition.a1, 0),
            (BoardLocation.GridPosition.b1, 1),
            (BoardLocation.GridPosition.c1, 2),
            (BoardLocation.GridPosition.d1, 3),
            (BoardLocation.GridPosition.e1, 4),
            (BoardLocation.GridPosition.f1, 5),
            (BoardLocation.GridPosition.g1, 6),
            (BoardLocation.GridPosition.h1, 7),
            // row 2
            (BoardLocation.GridPosition.a2, 8),
            (BoardLocation.GridPosition.b2, 9),
            (BoardLocation.GridPosition.c2, 10),
            (BoardLocation.GridPosition.d2, 11),
            (BoardLocation.GridPosition.e2, 12),
            (BoardLocation.GridPosition.f2, 13),
            (BoardLocation.GridPosition.g2, 14),
            (BoardLocation.GridPosition.h2, 15),
            // row 3
            (BoardLocation.GridPosition.a3, 16),
            (BoardLocation.GridPosition.b3, 17),
            (BoardLocation.GridPosition.c3, 18),
            (BoardLocation.GridPosition.d3, 19),
            (BoardLocation.GridPosition.e3, 20),
            (BoardLocation.GridPosition.f3, 21),
            (BoardLocation.GridPosition.g3, 22),
            (BoardLocation.GridPosition.h3, 23),
            // row 4
            (BoardLocation.GridPosition.a4, 24),
            (BoardLocation.GridPosition.b4, 25),
            (BoardLocation.GridPosition.c4, 26),
            (BoardLocation.GridPosition.d4, 27),
            (BoardLocation.GridPosition.e4, 28),
            (BoardLocation.GridPosition.f4, 29),
            (BoardLocation.GridPosition.g4, 30),
            (BoardLocation.GridPosition.h4, 31),
            // row 5
            (BoardLocation.GridPosition.a5, 32),
            (BoardLocation.GridPosition.b5, 33),
            (BoardLocation.GridPosition.c5, 34),
            (BoardLocation.GridPosition.d5, 35),
            (BoardLocation.GridPosition.e5, 36),
            (BoardLocation.GridPosition.f5, 37),
            (BoardLocation.GridPosition.g5, 38),
            (BoardLocation.GridPosition.h5, 39),
            // row 6
            (BoardLocation.GridPosition.a6, 40),
            (BoardLocation.GridPosition.b6, 41),
            (BoardLocation.GridPosition.c6, 42),
            (BoardLocation.GridPosition.d6, 43),
            (BoardLocation.GridPosition.e6, 44),
            (BoardLocation.GridPosition.f6, 45),
            (BoardLocation.GridPosition.g6, 46),
            (BoardLocation.GridPosition.h6, 47),
            // row 7
            (BoardLocation.GridPosition.a7, 48),
            (BoardLocation.GridPosition.b7, 49),
            (BoardLocation.GridPosition.c7, 50),
            (BoardLocation.GridPosition.d7, 51),
            (BoardLocation.GridPosition.e7, 52),
            (BoardLocation.GridPosition.f7, 53),
            (BoardLocation.GridPosition.g7, 54),
            (BoardLocation.GridPosition.h7, 55),
            // row 8
            (BoardLocation.GridPosition.a8, 56),
            (BoardLocation.GridPosition.b8, 57),
            (BoardLocation.GridPosition.c8, 58),
            (BoardLocation.GridPosition.d8, 59),
            (BoardLocation.GridPosition.e8, 60),
            (BoardLocation.GridPosition.f8, 61),
            (BoardLocation.GridPosition.g8, 62),
            (BoardLocation.GridPosition.h8, 63)
        ]
        
        for (grid, index) in testCases {
            XCTAssertEqual(BoardLocation(gridPosition: grid).index, index)
            XCTAssertEqual(BoardLocation(index: index).gridPosition, grid)
        }
        
    }
    
    func testMoveLocationsForColorReturnsCorrectLocations() {
        
        class FakeOpening: Opening {
            override func moveGridPositions()
                -> [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
                let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
                    (.e2, .e4), // white moves pawn to e4
                    (.e7, .e5), // black moves pawn to e5
                    (.g1, .f3), // white moves knight to f3
                    (.b8, .c6), // black moves knight to c6
                    (.f1, .b5)  // white moves bishop to b5
                ]
                return moves
            }
        }
        
        let expectedWhiteLocations: [(fromLocation: BoardLocation, toLocation: BoardLocation)] = [
            (BoardLocation(gridPosition: .e2), BoardLocation(gridPosition: .e4)),
            (BoardLocation(gridPosition: .g1), BoardLocation(gridPosition: .f3)),
            (BoardLocation(gridPosition: .f1), BoardLocation(gridPosition: .b5))
            ]
        
        let expectedBlackLocations: [(fromLocation: BoardLocation, toLocation: BoardLocation)] = [
            (BoardLocation(gridPosition: .e7), BoardLocation(gridPosition: .e5)),
            (BoardLocation(gridPosition: .b8), BoardLocation(gridPosition: .c6))
            ]
        
        let opening = FakeOpening()
        
        let whiteMoves = opening.moves(for: .white)
        XCTAssertEqual(whiteMoves.count, expectedWhiteLocations.count)
        
        let blackMoves = opening.moves(for: .black)
        XCTAssertEqual(blackMoves.count, expectedBlackLocations.count)
        
        for i in 0..<whiteMoves.count {
            let expected = expectedWhiteLocations[i]
            let actual = whiteMoves[i]
            
            XCTAssertEqual(expected.fromLocation, actual.fromLocation)
            XCTAssertEqual(expected.toLocation, actual.toLocation)
        }
        
        for i in 0..<blackMoves.count {
            let expected = expectedBlackLocations[i]
            let actual = blackMoves[i]
            
            XCTAssertEqual(expected.fromLocation, actual.fromLocation)
            XCTAssertEqual(expected.toLocation, actual.toLocation)
        }
        
    }
    
    func testIsDarkSquareReturnsExpectedValue() {
        
        let board = ASCIIBoard(colors: "! * ! * ! * ! *" +
                                       "* ! * ! * ! * !" +
                                       "! * ! * ! * ! *" +
                                       "* ! * ! * ! * !" +
                                       "! * ! * ! * ! *" +
                                       "* ! * ! * ! * !" +
                                       "! * ! * ! * ! *" +
                                       "* ! * ! * ! * !" )
        
        let darkLocatons = board.locationsWithCharacter("*")
        let lightLocations = board.locationsWithCharacter("!")
        
        darkLocatons.forEach {
            XCTAssertTrue($0.isDarkSquare, "Expected \($0) to be dark")
        }
        
        lightLocations.forEach {
            XCTAssertFalse($0.isDarkSquare, "Expected \($0) to be light")
        }
    }
    
    // MARK: - Dictionary Representable
    
    func testDictionaryRepresentable() {
        
        let location = BoardLocation(index: 14)
        XCTAssertEqual(location, location.toDictionaryAndBack)
    }
}
