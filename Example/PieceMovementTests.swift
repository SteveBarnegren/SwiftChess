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
    
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "W - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
 
    }
    
    func testStraightLineMovementCanMoveDown() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "W - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
        
    }
    
    func testStraightLineMovementCanMoveRight() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "W - - - - - * -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testStraightLineMovementCanMoveLeft() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - - - W -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
 
    
    func testStraightLineMovementCannotMoveDiagonally() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - * - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testStraightLineMovementCannotMoveUpThroughOpponent() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - * - - - -" +
                        "- - - - - - - -" +
                        "- - - B - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - W - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testStraightLineMovementCannotMoveDownThroughOpponent() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - W - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - B - - -" +
                        "- - - - - - - -" +
                        "- - - - * - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testStraightLineMovementCannotMoveLeftThroughOpponent() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - B - - W" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testStraightLineMovementCannotMoveRightThroughOpponent() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "W - - - B - - *" +
                        "- - - - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementStraightLine()
        
        XCTAssertFalse(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testDiagonalMovementCanMoveNE() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - * - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - W - - - - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testDiagonalMovementCanMoveSE() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - W - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - * - -" +
                        "- - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testDiagonalMovementCanMoveSW() {
        
        let boardArt = ("- - - - - - - -" +
                        "- - - - - - W -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "* - - - - - - -")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }
    
    func testDiagonalMovementCanMoveNW() {
        
        let boardArt = ("* - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - -" +
                        "- - - - - - - W")
        
        let board = makeASCIIArtBoardWithPieceColors(boardArt)
        
        let startIndex = indexOfCharacter("W", boardArt: boardArt)
        let targetIndex = indexOfCharacter("*", boardArt: boardArt)
        
        let movement = PieceMovementDiagonal()
        
        XCTAssertTrue(movement.canPieceMove(startIndex, toIndex: targetIndex, board: board))
    }



    // MARK - Board Creation Helpers
    
    func makeASCIIArtBoardWithPieceColors(boardArt: String) -> Board {
        
        // We only care about colors, not piece type, so just make pawns
        
        var boardArt = boardArt
        boardArt = boardArt.stringByReplacingOccurrencesOfString("B", withString: "p")
        boardArt = boardArt.stringByReplacingOccurrencesOfString("W", withString: "P")

        return makeASCIIArtBoardWithPieceTypes(boardArt)
    }
    
    func makeASCIIArtBoardWithPieceTypes(boardArt: String) -> Board {
        
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
            
            let character = boardArt[boardArt.startIndex.advancedBy(i)]
            board.squares[i].piece = pieceFromCharacter(character)
        }
        
        return board;
    }
    
    func pieceFromCharacter(character: Character) -> Piece? {
        
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
    
    func transformASCIIBoardInput(input: String) -> String{
        
        let boardArt = input.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        var transformedArt = String()
        
        for y in  (0...7).reverse(){
            for x in 0...7 {
                
                let index = y*8 + x
                transformedArt.append(boardArt[boardArt.startIndex.advancedBy(index)])
            }
        }
 
        return transformedArt

    }
    
    func indexOfCharacter(character: Character, boardArt: String) -> Int{
        
        let boardArt = transformASCIIBoardInput(boardArt)
        
        var index: Int?
        
        if let idx = boardArt.characters.indexOf(character) {
            index = boardArt.startIndex.distanceTo(idx)
        }
        
        XCTAssertNotNil(index)
        return index!
    }

}











