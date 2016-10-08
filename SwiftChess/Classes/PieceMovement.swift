//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

// MARK: - PieceMovement (Base Class)

open class PieceMovement {
    
    public init(){
        
    }
   
    open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        return false
    }
    
    func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board, stride: BoardStride) -> Bool {
        
        // Get the moving piece
        var movingPiece = board.getPiece(at: fromLocation)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        // Increment by stride
        if !fromLocation.canIncrementBy(stride: stride) {
            return false
        }
        var testLocation = fromLocation.incrementedBy(stride: stride)
        
        while testLocation.isInBounds() {
            
            // If there is a piece on the square
            if let piece = board.getPiece(at: testLocation) {
                
                if piece.color == movingPiece!.color {
                    return false
                }
                
                if piece.color == movingPiece!.color.opposite() && testLocation == toLocation {
                    return true
                }
                
                if piece.color == movingPiece!.color.opposite() && testLocation != toLocation {
                    return false
                }
            }
            // if the square is empty
            if testLocation == toLocation {
                return true
            }
            
            // Increment by stride
            if !testLocation.canIncrementBy(stride: stride) {
                return false
            }
            testLocation = testLocation.incrementedBy(stride: stride)
            
        }
        
        return false
    }
    
    func canPieceOccupySquare(pieceLocation: BoardLocation, xOffset: Int, yOffset: Int, board: Board) -> Bool{
        
        let targetLocation = pieceLocation.incrementedBy(x: xOffset, y: yOffset)
        
        // Check if in bounds
        guard targetLocation.isInBounds() else{
            return false
        }
        
        // Check if wrapped
        if targetLocation.x - pieceLocation.x != xOffset || targetLocation.y - pieceLocation.y != yOffset {
            return false
        }
        
        // Check if space is occupied
        var movingPiece = board.getPiece(at: pieceLocation)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        if let otherPiece = board.getPiece(at: targetLocation) {
            
            if otherPiece.color == movingPiece!.color {
                return false
            }
        }
        
        return true
    }

}

// MARK: - PieceMovementStraightLine

open class PieceMovementStraightLine: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        let strides = [
            BoardStride(x: 0, y: -1 ), // Down
            BoardStride(x: 0, y: 1 ), // Up
            BoardStride(x: -1, y: 0 ), // Left
            BoardStride(x: 1, y: 0 )  // Right
        ]
        
        for stride in strides {
            if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: stride) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - PieceMovementDiagonal

open class PieceMovementDiagonal: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        
        let strides = [
            BoardStride(x: 1, y: -1 ), // South East
            BoardStride(x: -1, y: -1 ), // South West
            BoardStride(x: 1, y: 1 ), // North East
            BoardStride(x: -1, y: 1 )  // North West
        ]
        
        for stride in strides {
            if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: stride) {
                return true
            }
        }

        return false
        
    }
    
}

// MARK: - PieceMovementQueen

open class PieceMovementQueen: PieceMovement {
    
    let movements : [PieceMovement] = [PieceMovementStraightLine(), PieceMovementDiagonal()]

    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        for pieceMovement in movements {
            
            if pieceMovement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board) {
                return true
            }
        }
        
        return false
        
    }
}

// MARK: - PieceMovementKnight

open class PieceMovementKnight: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        let offsets: [(x: Int, y: Int)] = [
            (1,2),
            (2,1),
            (2,-1),
            (-2,1),
            (-1,-2),
            (-2,-1),
            (1,-2),
            (-1,2)
        ]
        
        for offset in offsets {
            
            let offsetLocation = fromLocation.incrementedBy(x: offset.x, y: offset.y)
            
            if toLocation == offsetLocation && canPieceOccupySquare(pieceLocation: fromLocation, xOffset: offset.x, yOffset: offset.y, board: board) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK: - PieceMovementPawn

open class PieceMovementPawn: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        let movingPiece = board.getPiece(at: fromLocation)
        
        if movingPiece == nil {
            return false;
        }
        
        var offsets = [(x: Int, y: Int)]()
        
        let color = movingPiece!.color
        
        // Add one ahead offset
        if color == .white {
            offsets.append((0,1))
        }
        else{
            offsets.append((0,-1))
        }
        
        // Add the two ahead offset
        if color == .white && fromLocation.y == 1 {
            offsets.append((0,2))
        }
        else if color == .black && fromLocation.y == 6 {
            offsets.append((0,-2))
        }
        
        // TODO: Need to implement the en-passent rule
        
        for offset in offsets {
            
            let offsetLocation = fromLocation.incrementedBy(x: offset.x, y: offset.y)
            
            if toLocation == offsetLocation && canPieceOccupySquare(pieceLocation: fromLocation, xOffset: offset.x, yOffset: offset.y, board: board) {
                return true
            }
        }
        
        return false
    }
}


// MARK: - PieceMovementKing

open class PieceMovementKing: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        
        let offsets: [(x: Int, y: Int)] = [
            (0,1), // North
            (1,1), // North-East
            (1,0), // East
            (1,-1), // South-East
            (0,-1), // South
            (-1,-1), // South-West
            (-1,0), // West
            (-1,1) // North- West
        ]
        
        for offset in offsets {
            
            let offsetLocation = fromLocation.incrementedBy(x: offset.x, y: offset.y)
            
            if toLocation == offsetLocation && canPieceOccupySquare(pieceLocation: fromLocation, xOffset: offset.x, yOffset: offset.y, board: board) {
                return true
            }
        }
        
        return false
    }

}
