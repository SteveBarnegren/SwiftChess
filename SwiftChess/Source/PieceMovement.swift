//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

//swiftlint:disable file_length

import Foundation

// MARK: - PieceMovement (Base Class)

let pawnMovement = PieceMovementPawn()
let rookMovement = PieceMovementRook()
let knightMovement = PieceMovementKnight()
let bishopMovement = PieceMovementBishop()
let queenMovement = PieceMovementQueen()
let kingMovement = PieceMovementKing()

open class PieceMovement {
    
    public class func pieceMovement(for pieceType: Piece.PieceType) -> PieceMovement {
        
        switch pieceType {
        case .pawn:
            return pawnMovement
        case .rook:
            return rookMovement
        case .knight:
            return knightMovement
        case .bishop:
            return bishopMovement
        case .queen:
            return queenMovement
        case .king:
            return kingMovement
        }   
    }
    
    public init() {
    }
   
    func canPieceMove(from fromLocation: BoardLocation,
                      to toLocation: BoardLocation,
                      board: Board,
                      accountForCheckState: Bool = false) -> Bool {
        
        if fromLocation == toLocation {
            return false
        }
        
        let canMove = isMovementPossible(from: fromLocation, to: toLocation, board: board)
        
        if canMove && accountForCheckState {
            
            let color = board.getPiece(at: fromLocation)!.color

            var boardCopy = board
            boardCopy.movePiece(from: fromLocation, to: toLocation)
            return boardCopy.isColorInCheck(color: color) ? false : true
        } else {
            return canMove
        }
    }
    
    func isMovementPossible(from fromLocation: BoardLocation, to toLocation: BoardLocation, board: Board) -> Bool {
        return false
    }
    
    // swiftlint:disable function_body_length
    func canPieceMove(from fromLocation: BoardLocation,
                      to toLocation: BoardLocation,
                      board: Board,
                      stride: BoardStride) -> Bool {
        
        enum Direction: Int {
            case increasing
            case decresing
            case none
        }
        
        var strideDirectionX = Direction.none
        if stride.x < 0 { strideDirectionX = .decresing }
        if stride.x > 0 { strideDirectionX = .increasing }
        
        var locationDirectionX = Direction.none
        if toLocation.x - fromLocation.x < 0 { locationDirectionX = .decresing }
        if toLocation.x - fromLocation.x > 0 { locationDirectionX = .increasing }
        
        if strideDirectionX != locationDirectionX {
            return false
        }
        
        var strideDirectionY = Direction.none
        if stride.y < 0 { strideDirectionY = .decresing }
        if stride.y > 0 { strideDirectionY = .increasing }
        
        var locationDirectionY = Direction.none
        if toLocation.y - fromLocation.y < 0 { locationDirectionY = .decresing }
        if toLocation.y - fromLocation.y > 0 { locationDirectionY = .increasing }
        
        if strideDirectionY != locationDirectionY {
            return false
        }
        
        // Make sure cannot take king
        if let piece = board.getPiece(at: toLocation) {
            if piece.type == .king {
                return false
            }
        }
        
        // Get the moving piece
        guard let movingPiece = board.getPiece(at: fromLocation) else {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        // Increment by stride
        if !fromLocation.canIncrement(by: stride) {
            return false
        }
        var testLocation = fromLocation.incremented(by: stride)
        
        while testLocation.isInBounds() {
            
            // If there is a piece on the square
            if let piece = board.getPiece(at: testLocation) {
                
                if piece.color == movingPiece.color {
                    return false
                }
                
                if piece.color == movingPiece.color.opposite && testLocation == toLocation {
                    return true
                }
                
                if piece.color == movingPiece.color.opposite && testLocation != toLocation {
                    return false
                }
            }
            // if the square is empty
            if testLocation == toLocation {
                return true
            }
            
            // Increment by stride
            if !testLocation.canIncrement(by: stride) {
                return false
            }
            testLocation = testLocation.incremented(by: stride)
            
        }
        
        return false
    }
    
    func canPieceOccupySquare(pieceLocation: BoardLocation, xOffset: Int, yOffset: Int, board: Board) -> Bool {
        
        let targetLocation = pieceLocation.incrementedBy(x: xOffset, y: yOffset)
        
        // Check if in bounds
        guard targetLocation.isInBounds() else {
            return false
        }
        
        // Check if wrapped
        if targetLocation.x - pieceLocation.x != xOffset || targetLocation.y - pieceLocation.y != yOffset {
            return false
        }
        
        // Check if space is occupied
        guard let movingPiece = board.getPiece(at: pieceLocation) else {
            print("Cannot move from an index that does not contain a piece")
            return false
        }
        
        if let otherPiece = board.getPiece(at: targetLocation) {
            
            if otherPiece.color == movingPiece.color {
                return false
            }
        }
        
        return true
    }

}

// MARK: - PieceMovementStraightLine

open class PieceMovementStraightLine: PieceMovement {
    
    let strides = [
        BoardStride(x: 0, y: -1 ), // Down
        BoardStride(x: 0, y: 1 ), // Up
        BoardStride(x: -1, y: 0 ), // Left
        BoardStride(x: 1, y: 0 )  // Right
    ]
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        let sameX = fromLocation.x == toLocation.x
        let sameY = fromLocation.y == toLocation.y
        
        if !(sameX || sameY) {
            return false
        }
        
        for stride in strides {
            if canPieceMove(from: fromLocation, to: toLocation, board: board, stride: stride) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - PieceMovementDiagonal

open class PieceMovementDiagonal: PieceMovement {
    
    let strides = [
        BoardStride(x: 1, y: -1 ), // South East
        BoardStride(x: -1, y: -1 ), // South West
        BoardStride(x: 1, y: 1 ), // North East
        BoardStride(x: -1, y: 1 )  // North West
    ]
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        if fromLocation.isDarkSquare != toLocation.isDarkSquare {
            return false
        }
        
        for stride in strides {
            if canPieceMove(from: fromLocation, to: toLocation, board: board, stride: stride) {
                return true
            }
        }

        return false
        
    }
    
}

// MARK: - PieceMovementQueen

open class PieceMovementQueen: PieceMovement {
    
    let movements: [PieceMovement] = [PieceMovementStraightLine(), PieceMovementDiagonal()]

    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        for pieceMovement in movements {
            
            if pieceMovement.canPieceMove(from: fromLocation, to: toLocation, board: board) {
                return true
            }
        }
        
        return false
        
    }
}

// MARK: - PieceMovementRook

open class PieceMovementRook: PieceMovement {
    
    let straightLineMovement = PieceMovementStraightLine()
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        return straightLineMovement.canPieceMove(from: fromLocation, to: toLocation, board: board)
    }
}

// MARK: - PieceMovementBishop

open class PieceMovementBishop: PieceMovement {
    
    let diagonalMovement = PieceMovementDiagonal()
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        return diagonalMovement.canPieceMove(from: fromLocation, to: toLocation, board: board)
    }
}

// MARK: - PieceMovementKnight

open class PieceMovementKnight: PieceMovement {
    
    let offsets: [(x: Int, y: Int)] = [
        (1, 2),
        (2, 1),
        (2, -1),
        (-2, 1),
        (-1, -2),
        (-2, -1),
        (1, -2),
        (-1, 2)
    ]
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        // Make sure cannot take king
        if let piece = board.getPiece(at: toLocation) {
            if piece.type == .king {
                return false
            }
        }
        
        for offset in offsets {
            
            let offsetLocation = fromLocation.incrementedBy(x: offset.x, y: offset.y)
            
            if toLocation == offsetLocation
                && canPieceOccupySquare(pieceLocation: fromLocation,
                                        xOffset: offset.x,
                                        yOffset: offset.y,
                                        board: board) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - PieceMovementPawn

// swiftlint:disable function_body_length
open class PieceMovementPawn: PieceMovement {
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        // Get the moving piece
        guard let movingPiece = board.getPiece(at: fromLocation) else {
            return false
        }
        
        if movingPiece.color == .white && toLocation.y == 0 {
            return false
        }
        
        if movingPiece.color == .black && toLocation.y == 7 {
            return false
        }
        
        // Make sure cannot take king
        if let piece = board.getPiece(at: toLocation) {
            if piece.type == .king {
                return false
            }
        }
        
        let color = movingPiece.color

        // ****** Test forward locations ******
        
        // Test one ahead offset
        let oneAheadStride = (color == .white ? BoardStride(x: 0, y: 1) : BoardStride(x: 0, y: -1))
        var canMoveOneAhead = true
        
        ONE_AHEAD: if fromLocation.canIncrement(by: oneAheadStride) {
            
            let location = fromLocation.incremented(by: oneAheadStride)
            
            if board.getPiece(at: location) != nil {
                canMoveOneAhead = false
                break ONE_AHEAD
            }
            
            if location == toLocation {
                return true
            }
        }
        
        // Test two ahead offset
        if canMoveOneAhead {
            
            var twoAheadStride: BoardStride?
            
            if color == .white && fromLocation.y == 1 {
                twoAheadStride = BoardStride(x: 0, y: 2)
            } else if color == .black && fromLocation.y == 6 {
                twoAheadStride = BoardStride(x: 0, y: -2)
            }
            
            TWO_AHEAD: if let twoAheadStride = twoAheadStride {
                
                let twoAheadLocation = fromLocation.incremented(by: twoAheadStride)
                
                if toLocation != twoAheadLocation {
                    break TWO_AHEAD
                }
                
                if board.getPiece(at: twoAheadLocation) == nil {
                    return true
                }
            }
        }
        
        // ****** Test Diagonal locations ******
        var diagonalStrides = [BoardStride]()
        
        if color == .white {
            diagonalStrides.append( BoardStride(x: -1, y: 1) )
            diagonalStrides.append( BoardStride(x: 1, y: 1) )
        } else {
            diagonalStrides.append( BoardStride(x: -1, y: -1) )
            diagonalStrides.append( BoardStride(x: 1, y: -1) )
        }

        for stride in diagonalStrides {
            
            guard fromLocation.canIncrement(by: stride) else {
                continue
            }
            
            let location = fromLocation.incremented(by: stride)
            
            if location != toLocation {
                continue
            }
            
            // If the target square has an opponent piece
            if let piece = board.getPiece(at: location) {
                if piece.color == color.opposite {
                    return true
                }
            }
            
            // If can make en passent move
            let enPassentStride = BoardStride(x: stride.x, y: 0)
            
            guard fromLocation.canIncrement(by: enPassentStride) else {
                break
            }
            
            let enPassentLocation = fromLocation.incremented(by: enPassentStride)
            
            guard let passingPiece = board.getPiece(at: enPassentLocation) else {
                break
            }
            
            if passingPiece.canBeTakenByEnPassant && passingPiece.color == color.opposite {
                return true
            }
            
        }
        
        return false
        
    }
}

// MARK: - PieceMovementKing

open class PieceMovementKing: PieceMovement {
    
    let offsets: [(x: Int, y: Int)] = [
        (0, 1),   // North
        (1, 1),   // North-East
        (1, 0),   // East
        (1, -1),  // South-East
        (0, -1),  // South
        (-1, -1), // South-West
        (-1, 0),  // West
        (-1, 1)   // North- West
    ]
    
    override func isMovementPossible(from fromLocation: BoardLocation,
                                     to toLocation: BoardLocation,
                                     board: Board) -> Bool {
        
        // Make sure cannot take king
        if let piece = board.getPiece(at: toLocation) {
            if piece.type == .king {
                return false
            }
        }
        
        for offset in offsets {
            
            let offsetLocation = fromLocation.incrementedBy(x: offset.x, y: offset.y)
            
            if toLocation == offsetLocation
                && offsetLocation.isInBounds()
                && canPieceOccupySquare(pieceLocation: fromLocation,
                                        xOffset: offset.x,
                                        yOffset: offset.y,
                                        board: board) {
                return true
            }
        }
        
        return false
    }

}
