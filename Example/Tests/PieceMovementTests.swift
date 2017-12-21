//
//  PieceMovementTests.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 20/09/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

// swiftlint:disable type_body_length
// swiftlint:disable file_length

import XCTest
@testable import SwiftChess

class PieceMovementTests: XCTestCase {

    // MARK: - Setup / Tear down
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Board Testing
    
    func testBoard(board: ASCIIBoard, movingPiece: Character, movement: PieceMovement) {
        
        // Get the index of the moving piece
        let movingIndex = board.indexOfCharacter(movingPiece)
        
        // Test allowed locations
        let allowedIndexes = board.indexesWithCharacter("*")
        if allowedIndexes.count > 0 {
            
            for allowedIndex in allowedIndexes {
                XCTAssertTrue(
                    movement.canPieceMove(from: BoardLocation(index: movingIndex),
                                          to: BoardLocation(index: allowedIndex),
                                          board: board.board),
                    "Allowed index was invalid: \(allowedIndex)")
            }
        }
        
        // Test invalid locations
        let invalidIndexes = board.indexesWithCharacter("!")
        if invalidIndexes.count > 0 {
            
            for invalidIndex in invalidIndexes {
                XCTAssertFalse(
                    movement.canPieceMove(from: BoardLocation(index: movingIndex),
                                          to: BoardLocation(index: invalidIndex),
                                          board: board.board),
                    "Invalid index was valid: \(invalidIndex)")
            }
        }

    }
    
    func canMakeMove(board: ASCIIBoard, from: Character, to: Character, movement: PieceMovement) -> Bool {
        
        let movingIndex = board.indexOfCharacter(from)
        let targetIndex = board.indexOfCharacter(to)
        
        return movement.canPieceMove(from: BoardLocation(index: movingIndex),
                                     to: BoardLocation(index: targetIndex),
                                     board: board.board)
    }
    
    // MARK: - Straight Line Movement
    
    func testStraightLineMovementCanMoveUp() {
        
        let board = ASCIIBoard(colors: "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "W - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCanMoveDown() {
        
        let board = ASCIIBoard(colors: "W - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" +
                                       "* - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCanMoveRight() {
     
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "W * * * * * * *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())

    }
    
    func testStraightLineMovementCanMoveLeft() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* * * * * * * W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())

    }
    
    func testStraightLineMovementCannotMoveToInvalidPositionFromCenter() {
     
        let board = ASCIIBoard(colors: "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "* * * W * * * *" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W * * * * * * *" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "* * * * * * * W" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "W * * * * * * *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
    }
    
    func testStraightLineMovementCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "* * * * * * * W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())
        
    }
    
    func testStraightLineMovementCannotMoveThroughOpponent() {
        
        let board = ASCIIBoard(colors: "- - - ! - - - -" +
                                       "- - - ! - - - -" +
                                       "- - - B - - - -" +
                                       "- - - * - - - -" +
                                       "! B * W * B ! !" +
                                       "- - - * - - - -" +
                                       "- - - B - - - -" +
                                       "- - - ! - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementStraightLine())

     }
    
    func testStraightLineMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "W - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementStraightLine()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testStraightLineMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "Q - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("Q")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementStraightLine()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }

    // MARK: - Diagonal Movement
    
    func testDiagonalMovementCanMoveNE() {
        
        let board = ASCIIBoard(colors: "- - - - - - - *" +
                                       "- - - - - - * -" +
                                       "- - - - - * - -" +
                                       "- - - - * - - -" +
                                       "- - - * - - - -" +
                                       "- - * - - - - -" +
                                       "- * - - - - - -" +
                                       "W - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())

    }
    
    func testDiagonalMovementCanMoveSE() {
        
        let board = ASCIIBoard(colors: "W - - - - - - -" +
                                       "- * - - - - - -" +
                                       "- - * - - - - -" +
                                       "- - - * - - - -" +
                                       "- - - - * - - -" +
                                       "- - - - - * - -" +
                                       "- - - - - - * -" +
                                       "- - - - - - - *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())

    }
    
    func testDiagonalMovementCanMoveSW() {
        
        let board = ASCIIBoard(colors: "- - - - - - - W" +
                                       "- - - - - - * -" +
                                       "- - - - - * - -" +
                                       "- - - - * - - -" +
                                       "- - - * - - - -" +
                                       "- - * - - - - -" +
                                       "- * - - - - - -" +
                                       "* - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())

    }
    
    func testDiagonalMovementCanMoveNW() {
        
        let board = ASCIIBoard(colors: "* - - - - - - -" +
                                       "- * - - - - - -" +
                                       "- - * - - - - -" +
                                       "- - - * - - - -" +
                                       "- - - - * - - -" +
                                       "- - - - - * - -" +
                                       "- - - - - - * -" +
                                       "- - - - - - - W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())

    }
    
    func testDiagonalMovementCannotMoveToInvalidPositionFromCenter() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "* ! ! ! ! ! * !" +
                                       "! * ! ! ! * ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! ! ! W ! ! ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! * ! ! ! * ! !" +
                                       "* ! ! ! ! ! * !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())

     }
    
    func testDiagonalMovementCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W ! ! ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())
        
    }
    
    func testDiagonalMovementCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! W" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())
        
    }
    
    func testDiagonalMovementCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "W ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())
        
    }
    
    func testDiagonalMovementCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! ! ! W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementDiagonal())
        
    }
    
    func testDiagonalMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - W" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementDiagonal()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testDiagonalMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - Q" )
        
        let pieceIndex = board.indexOfCharacter("Q")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementDiagonal()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }

    // MARK: - Knight Movement
    
    func testKnightMovementCanMoveToClockwisePosition1() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - * - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }
    
    func testKnightMovementCanMoveToClockwisePosition2() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - * - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }
    
    func testKnightMovementCanMoveToClockwisePosition3() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - * - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCanMoveToClockwisePosition4() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - * - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }

    func testKnightMovementCanMoveToClockwisePosition5() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - * - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }
    
    func testKnightMovementCanMoveToClockwisePosition6() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- * - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }

    func testKnightMovementCanMoveToClockwisePosition7() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- * - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }

    func testKnightMovementCanMoveToClockwisePosition8() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - * - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())

    }
    
    func testKnightMovementCannotMoveToInvalidPositionFromCenter() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! * ! ! ! * ! !" +
                                       "! ! ! W ! ! ! !" +
                                       "! * ! ! ! * ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! ! ! ! ! ! ! !" )

        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W ! ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! W" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "W ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! ! W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKnight())
        
    }
    
    func testKnightMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .knight, color: .white), at: location)
        
        let movement = PieceMovementKnight()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }
    
    func testKnightMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementKnight()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testKnightMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - K - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("K")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementKnight()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }
    
    // MARK: - King Movement
    
    func testKingMovementCannotMoveToInvalidPositionFromCenter() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! * * * ! ! !" +
                                       "! ! * W * ! ! !" +
                                       "! ! * * * ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKing())
        
    }
    
    func testKingMovementCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W * ! ! ! ! ! !" +
                                       "* * ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKing())
        
    }
    
    func testKingMovementCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! * W" +
                                       "! ! ! ! ! ! * *" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKing())
        
    }
    
    func testKingMovementCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "* * ! ! ! ! ! !" +
                                       "W * ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKing())
        
    }
    
    func testKingMovementCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! * *" +
                                       "! ! ! ! ! ! * W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementKing())
        
    }
    
    func testKingMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .king, color: .white), at: location)
        
        let movement = PieceMovementKing()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }
    
    func testKingMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - B - - -" +
                                       "- - - W - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementKing()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testKingMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - g - - -" +
                                       "- - - G - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("G")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementKing()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }
    
    // MARK: - Pawn Movement
    
    func testWhitePawnCanMoveAheadOneSpace() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - * - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
        
    }
    
    func testBlackPawnCanMoveAheadOneSpace() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - * - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
        
    }
    
    func testWhitePawnCanMoveAheadTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - * - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
    }
    
    func testBlackPawnCanMoveAheadTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - - - - - -" +
                                       "- - - * - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
        
    }
    
    func testStartingWhitePawnCannotJumpOverPiece() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - ! - - - -" +
                                       "- - - K - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
    }
    
    func testStartingBlackPawnCannotJumpOverPiece() {

        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - k - - - -" +
                                       "- - - ! - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
    }
    
    func testNonStartingRowWhitePawnCannotMoveAheadTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - ! - - - -" +
                                       "- - - - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
        
    }
    
    func testNonStartingRowBlackPawnCannotMoveAheadTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - - - - - -" +
                                       "- - - ! - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
        
    }
    
    func testStartingRowWhitePawnCannotMoveToInvalidPosition() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! P ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
        
    }
    
    func testStartingRowBlackPawnCannotMoveToInvalidPosition() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! p ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
        
    }
    
    func testPawnMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .pawn, color: .white), at: location)
        
        let movement = PieceMovementPawn()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }

    func testNonStartingRowWhitePawnCannotMoveToInvalidPosition() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! P ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "P", movement: PieceMovementPawn())
        
    }
    
    func testNonStartingRowBlackPawnCannotMoveToInvalidPosition() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! p ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" +
                                       "! ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "p", movement: PieceMovementPawn())
        
    }
    
    func testWhitePawnCannotTakePieceByMovingForwardOneSpace() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- p - - - - - -" +
                                       "- P - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "P", to: "p", movement: PieceMovementPawn()) == false)
        
    }
    
    func testBlackPawnCannotTakePieceByMovingForwardOneSpace() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- p - - - - - -" +
                                       "- P - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "p", to: "P", movement: PieceMovementPawn()) == false)
        
    }
    
    func testWhitePawnCannotTakePieceByMovingForwardTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- p - - - - - -" +
                                       "- - - - - - - -" +
                                       "- P - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "P", to: "p", movement: PieceMovementPawn()) == false)
        
    }
    
    func testBlackPawnCannotTakePieceByMovingForwardTwoSpaces() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- p - - - - - -" +
                                       "- - - - - - - -" +
                                       "- P - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "p", to: "P", movement: PieceMovementPawn()) == false)
        
    }
    
    func testWhitePawnCanTakePieceDiagonallyToLeft() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - p - - - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "P", to: "p", movement: PieceMovementPawn()))
        
    }
    
    func testWhitePawnCanTakePieceDiagonallyToRight() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - p - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "P", to: "p", movement: PieceMovementPawn()))
        
    }

    func testBlackPawnCanTakePieceDiagonallyToLeft() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - P - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "p", to: "P", movement: PieceMovementPawn()))
        
    }
    
    func testBlackPawnCanTakePieceDiagonallyToRight() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - p - - - -" +
                                       "- - - - P - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        XCTAssert(canMakeMove(board: board, from: "p", to: "P", movement: PieceMovementPawn()))
        
    }
    
    func testPawnMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - g - - -" +
                                       "- - - P - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("P")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementPawn()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }
    
    // MARK: - Test pawn En Passant
    
    func makeGame(board: Board, colorToMove: Color) -> Game {
        
        let whitePlayer = Human(color: .white)
        let blackPlayer = Human(color: .black)
        
        let game = Game(firstPlayer: whitePlayer, secondPlayer: blackPlayer, board: board, colorToMove: colorToMove)
        return game
    }
    
    func testPawnEnPassantFlagIsTrueAfterMoveTwoSpaces() {
        
        let board = Board(state: .newGame)
        
        let startLocation = BoardLocation(x: 0, y: 1)
        let targetLocation = BoardLocation(x: 0, y: 3)
        
        let game = makeGame(board: board, colorToMove: .white)
        
        guard let whitePlayer = game.currentPlayer as? Human else {
            fatalError()
        }
        
        do {
            try whitePlayer.movePiece(from: startLocation, to: targetLocation)
        } catch {
            fatalError()
        }
        
        guard let piece = game.board.getPiece(at: targetLocation) else {
            fatalError()
        }
        
        XCTAssertTrue(piece.color == .white)
        XCTAssertTrue(piece.type == .pawn)
        XCTAssertTrue(piece.canBeTakenByEnPassant == true)
    }
    
    func testPawnEnPassantFlagIsFalseAfterMoveOneSpace() {
        
        let board = Board(state: .newGame)
        
        let startLocation = BoardLocation(x: 0, y: 1)
        let targetLocation = BoardLocation(x: 0, y: 2)
        
        let game = makeGame(board: board, colorToMove: .white)
        
        guard let whitePlayer = game.currentPlayer as? Human else {
            fatalError()
        }
        
        do {
            try whitePlayer.movePiece(from: startLocation, to: targetLocation)
        } catch {
            fatalError()
        }
        
        guard let piece = game.board.getPiece(at: targetLocation) else {
            fatalError()
        }
        
        XCTAssertTrue(piece.color == .white)
        XCTAssertTrue(piece.type == .pawn)
        XCTAssertTrue(piece.canBeTakenByEnPassant == false)
    }
    
    func testPawnEnPassantFlagIsResetAfterSubsequentMove() {
        
        // White moves pawn
        let board = Board(state: .newGame)
        
        let startLocation = BoardLocation(x: 0, y: 1)
        let targetLocation = BoardLocation(x: 0, y: 2)
        
        let game = makeGame(board: board, colorToMove: .white)
        
        guard let whitePlayer = game.currentPlayer as? Human else {
            fatalError()
        }
        
        do {
            try whitePlayer.movePiece(from: startLocation, to: targetLocation)
        } catch {
            fatalError()
        }
        
        // Black moves pawn
        guard let blackPlayer = game.currentPlayer as? Human else {
            fatalError()
        }
        
        guard blackPlayer.color == .black else {
            fatalError()
        }
        
        do {
            try blackPlayer.movePiece(from: BoardLocation(x: 0, y: 6), to: BoardLocation(x: 0, y: 5))
        } catch {
            fatalError()
        }
        
        // Check white pawn flag is false
        guard let piece = game.board.getPiece(at: targetLocation) else {
            fatalError()
        }
        
        XCTAssertTrue(piece.color == .white)
        XCTAssertTrue(piece.type == .pawn)
        XCTAssertTrue(piece.canBeTakenByEnPassant == false)
    }
    
    func testWhitePawnCanTakeOpponentUsingEnPassant() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - g" +
                                       "p - - - - - - -" +
                                       "+ - - - - - - -" +
                                       "* P - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - G" )
        
        let game = makeGame(board: board.board, colorToMove: .black)
        let blackPlayer = game.blackPlayer as! Human
        let whitePlayer = game.whitePlayer as! Human
        
        // Black move two spaces
        do {
            try blackPlayer.movePiece(from: board.locationOfCharacter("p"),
                                      to: board.locationOfCharacter("*"))
        } catch {
            fatalError()
        }
        
        // White should be able to take the black pawn using the en passant rule
        let pieceMovement = PieceMovementPawn()
        XCTAssertTrue(pieceMovement.canPieceMove(from: board.locationOfCharacter("P"),
                                                 to: board.locationOfCharacter("+"),
                                                 board: game.board),
                      "Expected white to be able to make en passant move")
        
        do {
            try whitePlayer.movePiece(from: board.locationOfCharacter("P"),
                                      to: board.locationOfCharacter("+"))
        } catch {
            XCTFail("Expected white to be able to execute en passant move")
        }
    
        XCTAssertTrue(game.board.getPiece(at: board.locationOfCharacter("*")) == nil,
                      "Expected black pawn to be removed from board")

    }
    
    func testBlackPawnCanTakeOpponentUsingEnPassant() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - g" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* p - - - - - -" +
                                       "+ - - - - - - -" +
                                       "P - - - - - - -" +
                                       "- - - - - - - G" )
        
        let game = makeGame(board: board.board, colorToMove: .white)
        let whitePlayer = game.whitePlayer as! Human
        let blackPlayer = game.blackPlayer as! Human
        
        // White move two spaces
        do {
            try whitePlayer.movePiece(from: board.locationOfCharacter("P"),
                                      to: board.locationOfCharacter("*"))
        } catch {
            fatalError()
        }
        
        // Black should be able to take the white pawn using the en passant rule
        let pieceMovement = PieceMovementPawn()
        XCTAssertTrue(pieceMovement.canPieceMove(from: board.locationOfCharacter("p"),
                                                 to: board.locationOfCharacter("+"),
                                                 board: game.board),
                      "Expected black to be able to make en passant move")
        
        do {
            try blackPlayer.movePiece(from: board.locationOfCharacter("p"),
                                      to: board.locationOfCharacter("+"))
        } catch {
            XCTFail("Expected black to be able to execute en passant move")
        }
        
        XCTAssertTrue(game.board.getPiece(at: board.locationOfCharacter("*")) == nil,
                      "Expected white pawn to be removed from board")

    }
    
    func testWhitePawnCannotTakeOpponentUsingEnPassantIfMoveNotMadeImmediately() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - g" +
                                       "p - - - - - - %" +
                                       "+ - - - - - - -" +
                                       "* P - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - &" +
                                       "- - - - - - - G" )
        
        let game = makeGame(board: board.board, colorToMove: .black)
        let whitePlayer = game.whitePlayer as! Human
        let blackPlayer = game.blackPlayer as! Human
        
        // Black move two spaces
        do {
            try blackPlayer.movePiece(from: board.locationOfCharacter("p"),
                                      to: board.locationOfCharacter("*"))
        } catch {
            fatalError()
        }
        
        // White moves king
        do {
            try whitePlayer.movePiece(from: board.locationOfCharacter("G"),
                                      to: board.locationOfCharacter("&"))
        } catch {
            fatalError()
        }
        
        // Black moves king
        do {
            try blackPlayer.movePiece(from: board.locationOfCharacter("g"),
                                      to: board.locationOfCharacter("%"))
        } catch {
            fatalError()
        }
        
        // White should not be able to take the black pawn using the en passant rule
        let pieceMovement = PieceMovementPawn()
        XCTAssertFalse(pieceMovement.canPieceMove(from: board.locationOfCharacter("P"),
                                                  to: board.locationOfCharacter("+"),
                                                  board: game.board))

    }
    
    func testBlackPawnCannotTakeOpponentUsingEnPassantIfMoveNotMadeImmediately() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - g" +
                                       "- - - - - - - %" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "* p - - - - - -" +
                                       "+ - - - - - - -" +
                                       "P - - - - - - &" +
                                       "- - - - - - - G" )
        
        let game = makeGame(board: board.board, colorToMove: .white)
        let whitePlayer = game.whitePlayer as! Human
        let blackPlayer = game.blackPlayer as! Human
        
        // White moves pawn two spaces
        do {
            try whitePlayer.movePiece(from: board.locationOfCharacter("P"),
                                      to: board.locationOfCharacter("*"))
        } catch {
            fatalError()
        }
        
        // Black moves king
        do {
            try blackPlayer.movePiece(from: board.locationOfCharacter("g"),
                                      to: board.locationOfCharacter("%"))
        } catch {
            fatalError()
        }
        
        // White moves king
        do {
            try whitePlayer.movePiece(from: board.locationOfCharacter("G"),
                                      to: board.locationOfCharacter("&"))
        } catch {
            fatalError()
        }
        
        // Black should not be able to take the white pawn using the en passant rule
        let pieceMovement = PieceMovementPawn()
        XCTAssertFalse(pieceMovement.canPieceMove(from: board.locationOfCharacter("p"),
                                                  to: board.locationOfCharacter("+"),
                                                  board: game.board))
    }
    
    // MARK: - Queen movement
    
    func testQueenCannotMoveToInvalidPositionFromCentre() {
        
        let board = ASCIIBoard(colors: "! ! ! * ! ! ! *" +
                                       "* ! ! * ! ! * !" +
                                       "! * ! * ! * ! !" +
                                       "! ! * * * ! ! !" +
                                       "* * * W * * * *" +
                                       "! ! * * * ! ! !" +
                                       "! * ! * ! * ! !" +
                                       "* ! ! * ! ! * !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementQueen())
        
    }
    
    func testQueenCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W * * * * * * *" +
                                       "* * ! ! ! ! ! !" +
                                       "* ! * ! ! ! ! !" +
                                       "* ! ! * ! ! ! !" +
                                       "* ! ! ! * ! ! !" +
                                       "* ! ! ! ! * ! !" +
                                       "* ! ! ! ! ! * !" +
                                       "* ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementQueen())
        
    }
    
    func testQueenCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "* * * * * * * W" +
                                       "! ! ! ! ! ! * *" +
                                       "! ! ! ! ! * ! *" +
                                       "! ! ! ! * ! ! *" +
                                       "! ! ! * ! ! ! *" +
                                       "! ! * ! ! ! ! *" +
                                       "! * ! ! ! ! ! *" +
                                       "* ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementQueen())
        
    }
    
    func testQueenCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! *" +
                                       "* ! ! ! ! ! * !" +
                                       "* ! ! ! ! * ! !" +
                                       "* ! ! ! * ! ! !" +
                                       "* ! ! * ! ! ! !" +
                                       "* ! * ! ! ! ! !" +
                                       "* * ! ! ! ! ! !" +
                                       "W * * * * * * *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementQueen())
        
    }
    
    func testQueenCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! *" +
                                       "! * ! ! ! ! ! *" +
                                       "! ! * ! ! ! ! *" +
                                       "! ! ! * ! ! ! *" +
                                       "! ! ! ! * ! ! *" +
                                       "! ! ! ! ! * ! *" +
                                       "! ! ! ! ! ! * *" +
                                       "* * * * * * * W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementQueen())
        
    }
    
    func testQueenMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .queen, color: .white), at: location)
        
        let movement = PieceMovementQueen()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }
    
    func testQueenMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "W - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementQueen()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testQueenMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "Q - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("Q")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementQueen()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }
    
    // MARK: - Rook Movement
    
    func testRookCannotMoveToInvalidPositionFromCentre() {
        
        let board = ASCIIBoard(colors: "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "* * * W * * * *" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! * ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementRook())
        
    }
    
    func testRookCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W * * * * * * *" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementRook())
        
    }
    
    func testRookCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "* * * * * * * W" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementRook())
        
    }
    
    func testRookCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" +
                                       "W * * * * * * *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementRook())
        
    }
    
    func testRookCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! ! *" +
                                       "* * * * * * * W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementRook())
        
    }
    
    func testRookMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .rook, color: .white), at: location)
        
        let movement = PieceMovementRook()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }
    
    func testRookMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "W - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementRook()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testRookMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "R - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("R")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementRook()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }
    
    // MARK: - Bishop movement
    
    func testBishopCannotMoveToInvalidPositionFromCentre() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "* ! ! ! ! ! * !" +
                                       "! * ! ! ! * ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! ! ! W ! ! ! !" +
                                       "! ! * ! * ! ! !" +
                                       "! * ! ! ! * ! !" +
                                       "* ! ! ! ! ! * !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementBishop())
        
    }
    
    func testBishopCannotMoveToInvalidPositionFromTopLeft() {
        
        let board = ASCIIBoard(colors: "W ! ! ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! ! ! *" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementBishop())
        
    }
    
    func testBishopCannotMoveToInvalidPositionFromTopRight() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! W" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "* ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementBishop())
        
    }
    
    func testBishopCannotMoveToInvalidPositionFromBottomLeft() {
        
        let board = ASCIIBoard(colors: "! ! ! ! ! ! ! *" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "W ! ! ! ! ! ! !" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementBishop())
        
    }
    
    func testBishopCannotMoveToInvalidPositionFromBottomRight() {
        
        let board = ASCIIBoard(colors: "* ! ! ! ! ! ! !" +
                                       "! * ! ! ! ! ! !" +
                                       "! ! * ! ! ! ! !" +
                                       "! ! ! * ! ! ! !" +
                                       "! ! ! ! * ! ! !" +
                                       "! ! ! ! ! * ! !" +
                                       "! ! ! ! ! ! * !" +
                                       "! ! ! ! ! ! ! W" )
        
        testBoard(board: board, movingPiece: "W", movement: PieceMovementBishop())
        
    }
    
    func testBishopMovementCannotMoveToCurrentPosition() {
        
        let location = BoardLocation(x: 3, y: 3)
        
        var board = Board(state: .empty)
        board.setPiece(Piece(type: .bishop, color: .white), at: location)
        
        let movement = PieceMovementBishop()
        
        XCTAssert(movement.canPieceMove(from: location, to: location, board: board) == false,
                  "Expected piece could not move to its current position")
        
    }
    
    func testBishopMovementCanTakeOpponent() {
        
        let board = ASCIIBoard(colors: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - B - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- W - - - - - -" )
        
        let whiteIndex = board.indexOfCharacter("W")
        let blackIndex = board.indexOfCharacter("B")
        
        let movement = PieceMovementBishop()
        XCTAssertTrue(movement.canPieceMove(from: BoardLocation(index: whiteIndex),
                                            to: BoardLocation(index: blackIndex),
                                            board: board.board))
    }
    
    func testBishopMovementCannotTakeKing() {
        
        let board = ASCIIBoard(pieces: "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- - - - g - - -" +
                                       "- - - - - - - -" +
                                       "- - - - - - - -" +
                                       "- B - - - - - -" )
        
        let pieceIndex = board.indexOfCharacter("B")
        let kingIndex = board.indexOfCharacter("g")
        
        let movement = PieceMovementBishop()
        XCTAssertFalse(movement.canPieceMove(from: BoardLocation(index: pieceIndex),
                                             to: BoardLocation(index: kingIndex),
                                             board: board.board))
    }

}
