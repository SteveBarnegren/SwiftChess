//
//  PieceMovementTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 20/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import SwiftChess

class PieceMovementTests: XCTestCase {

    
    // MARK - Setup / Tear down
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStraightLineMovementCanMoveUp() {
    
        let boardArt = ("* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "W - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testStraightLineMovementCanMoveDown() {
        
        let boardArt = ("W - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -" +
                        "* - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
        
    }
    
    func testStraightLineMovementCanMoveRight() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "W * * * * * * *")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }

    }
    
    func testStraightLineMovementCanMoveLeft() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* * * * * * * W")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
 
    
    func testStraightLineMovementCannotMoveToInValidPosition() {
        
        let boardArt = ("- - - * - - - -" +
                        "- - - * - - - -" +
                        "- - - * - - - -" +
                        "* * * W * * * *" +
                        "- - - * - - - -" +
                        "- - - * - - - -" +
                        "- - - * - - - -" +
                        "- - - * - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("-", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testStraightLineMovementCannotMoveThroughOpponent() {
        
        let boardArt = ("- - - * - - - -" +
                        "- - - * - - - -" +
                        "- - - B - - - -" +
                        "- - - - - - - -" +
                        "* B - W - B * *" +
                        "- - - - - - - -" +
                        "- - - B - - - -" +
                        "- - - * - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        for targetIndex in targetIndexes {
            XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testDiagonalMovementCanMoveNE() {
        
        let boardArt = ("- - - - - - - *" +
                        "- - - - - - * -" +
                        "- - - - - * - -" +
                        "- - - - * - - -" +
                        "- - - * - - - -" +
                        "- - * - - - - -" +
                        "- * - - - - - -" +
                        "W - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testDiagonalMovementCanMoveSE() {
        
        let boardArt = ("W - - - - - - -" +
                        "- * - - - - - -" +
                        "- - * - - - - -" +
                        "- - - * - - - -" +
                        "- - - - * - - -" +
                        "- - - - - * - -" +
                        "- - - - - - * -" +
                        "- - - - - - - *")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }

    }
    
    func testDiagonalMovementCanMoveSW() {
        
        let boardArt = ("- - - - - - - W" +
                        "- - - - - - * -" +
                        "- - - - - * - -" +
                        "- - - - * - - -" +
                        "- - - * - - - -" +
                        "- - * - - - - -" +
                        "- * - - - - - -" +
                        "* - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testDiagonalMovementCanMoveNW() {
        
        let boardArt = ("* - - - - - - -" +
                        "- * - - - - - -" +
                        "- - * - - - - -" +
                        "- - - * - - - -" +
                        "- - - - * - - -" +
                        "- - - - - * - -" +
                        "- - - - - - * -" +
                        "- - - - - - - W")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        for targetIndex in targetIndexes {
            XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        }
    }
    
    func testDiagonalMovementCannotMoveToInvalidPosition() {
        
        let boardArt = ("- - - - - - - *" +
                        "* - - - - - * -" +
                        "- * - - - * - -" +
                        "- - * - * - - -" +
                        "- - - W - - - -" +
                        "- - * - * - - -" +
                        "- * - - - * - -" +
                        "* - - - - - * -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndexes = indexesWithCharacter("-", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        for targetIndex in targetIndexes {            
            XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board),
                           "Should not be able to move to index \(targetIndex)")
        }
    }
    
    func testKnightMovementCanMoveToClockwisePosition1() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - * - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCanMoveToClockwisePosition2() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - * - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCanMoveToClockwisePosition3() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - * - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCanMoveToClockwisePosition4() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - * - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }

    func testKnightMovementCanMoveToClockwisePosition5() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - * - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCanMoveToClockwisePosition6() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- * - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }

    func testKnightMovementCanMoveToClockwisePosition7() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- * - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }

    func testKnightMovementCanMoveToClockwisePosition8() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - * - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCannotMoveToInvalidPosition() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - *" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCannotWrapToPosition1() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - *" +
                        "W - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }

    
    func testKnightMovementCannotWrapUpAndRight() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - - - - -" +
                        "- - - - - - W -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCannotWrapDownAndRight() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - W -" +
                        "* - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCannotWrapUpAndLeft() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - *" +
                        "- W - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testKnightMovementCannotWrapDownAndLeft() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- W - - - - - -" +
                        "- - - - - - - *" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementKnight()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }

    // MARK - Board Creation Helpers
    
    func makeASCIIArtBoardWithPieceColors(_ boardArt: String) -> Board {
        
        // We only care about colors, not piece type, so just make pawns
        
        var boardArt = boardArt
        boardArt = boardArt.replacingOccurrences(of: "B", with: "p")
        boardArt = boardArt.replacingOccurrences(of: "W", with: "P")

        return makeASCIIArtBoardWithPieceTypes(boardArt)
    }
    
    func makeASCIIArtBoardWithPieceTypes(_ boardArt: String) -> Board {
        
        let boardArt = transformASCIIBoardInput(boardArt)
        
        // Check string format
        XCTAssertEqual(boardArt.characters.count, 64, "ASCII board art must be 128 characters long")
    
        var board = Board();
        
        // Clear all pieces on the board
        for i in 0..<64 {
            board.squares[i].piece = nil;
        }
        
        // Setup pieces from ascii art
        for i in 0..<64 {
            
            let character = boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: i)]
            board.squares[i].piece = pieceFromCharacter(character)
        }
        
        return board;
    }
    
    func pieceFromCharacter(_ character: Character) -> Piece? {
        
        var piece: Piece?
        
        switch character {
        case "R":
            piece = Piece(type: .rook, color: .white)
        case "K":
            piece = Piece(type: .knight, color: .white)
        case "B":
            piece = Piece(type: .bishop, color: .white)
        case "Q":
            piece = Piece(type: .queen, color: .white)
        case "G":
            piece = Piece(type: .king, color: .white)
        case "P":
            piece = Piece(type: .pawn, color: .white)
        case "r":
            piece = Piece(type: .rook, color: .black)
        case "k":
            piece = Piece(type: .knight, color: .black)
        case "b":
            piece = Piece(type: .bishop, color: .black)
        case "q":
            piece = Piece(type: .queen, color: .black)
        case "g":
            piece = Piece(type: .king, color: .black)
        case "p":
            piece = Piece(type: .pawn, color: .black)
        default:
            piece = nil
        }
        
        return piece
    }
    
    func transformASCIIBoardInput(_ input: String) -> String{
        
        let boardArt = input.replacingOccurrences(of: " ", with: "")
        
        var transformedArt = String()
        
        for y in  (0...7).reversed(){
            for x in 0...7 {
                
                let index = y*8 + x
                transformedArt.append(boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: index)])
            }
        }
 
        return transformedArt

    }
    
    func indexOfCharacter(_ character: Character, boardArt: String) -> Int{
        
        let boardArt = transformASCIIBoardInput(boardArt)
        
        var index: Int?
        
        if let idx = boardArt.characters.index(of: character) {
            index = boardArt.characters.distance(from: boardArt.startIndex, to: idx)
        }
        
        XCTAssertNotNil(index)
        return index!
    }
    
    func indexesWithCharacter(_ character: Character, boardArt: String) -> [Int]{
        
        let boardArt = transformASCIIBoardInput(boardArt)
        
        var indexes = [Int]()
        
        for i in 0..<64 {
            
            let aCharacter = boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: i)]
            if character == aCharacter {
                indexes.append(i)
            }
        }
        
        // If this assert triggers, then the bug is in the test that called this function
        XCTAssertGreaterThan(indexes.count, 0)
        return indexes
    }


}











