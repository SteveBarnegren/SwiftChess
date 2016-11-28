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
    
    public class func pieceMovementForPieceType(pieceType: Piece.PieceType) -> PieceMovement {
        
        switch pieceType {
        case .pawn:
            return PieceMovementPawn()
        case .rook:
            return PieceMovementRook()
        case .knight:
            return PieceMovementKnight()
        case .bishop:
            return PieceMovementBishop()
        case .queen:
            return PieceMovementQueen()
        case .king:
            return PieceMovementKing()
        }   
    }
    
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

// MARK: - PieceMovementRook

open class PieceMovementRook: PieceMovement {
    
    let straightLineMovement = PieceMovementStraightLine()
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        return straightLineMovement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board)
        
        return false
        
    }
}

// MARK: - PieceMovementBishop

open class PieceMovementBishop: PieceMovement {
    
    let diagonalMovement = PieceMovementDiagonal()
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        return diagonalMovement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board)
        
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
        
        // Get the moving piece
        guard let movingPiece = board.getPiece(at: fromLocation) else{
            return false
        }
        
        let color = movingPiece.color


        // ****** Test forward locations ******
        var forwardStrides = [BoardStride]()
        
        // Add one ahead offset
        if color == .white {
            forwardStrides.append( BoardStride(x: 0, y: 1) )
        }
        else{
            forwardStrides.append( BoardStride(x: 0, y: -1) )
        }
        
        // Add the two ahead offset
        if color == .white && fromLocation.y == 1 {
            
            forwardStrides.append( BoardStride(x: 0, y: 2) )
        }
        else if color == .black && fromLocation.y == 6 {
            
            forwardStrides.append( BoardStride(x: 0, y: -2) )
        }
        
        for stride in forwardStrides {
            
            guard fromLocation.canIncrementBy(stride: stride) else {
                continue
            }
            
            let location = fromLocation.incrementedBy(stride: stride)
            
            if let piece = board.getPiece(at: location) {
                continue
            }
            
            if location == toLocation {
                return true
            }
        }
        
        // ****** Test Diagonal locations ******
        var diagonalStrides = [BoardStride]()
        
        if color == .white {
            diagonalStrides.append( BoardStride(x: -1, y: 1) )
            diagonalStrides.append( BoardStride(x: 1, y: 1) )
        }
        else{
            diagonalStrides.append( BoardStride(x: -1, y: -1) )
            diagonalStrides.append( BoardStride(x: 1, y: -1) )
        }

        for stride in diagonalStrides {
            
            guard fromLocation.canIncrementBy(stride: stride) else {
                continue
            }
            
            let location = fromLocation.incrementedBy(stride: stride)
            
            if location != toLocation {
                continue
            }
            
            if let piece = board.getPiece(at: location) {
                if piece.color == color.opposite() {
                    return true
                }
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
            
            if toLocation == offsetLocation
                && offsetLocation.isInBounds()
                && canPieceOccupySquare(pieceLocation: fromLocation, xOffset: offset.x, yOffset: offset.y, board: board) {
                return true
            }
        }
        
        return false
    }

}
