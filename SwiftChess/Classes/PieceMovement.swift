//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

// MARK - PieceMovement (Base Class)

open class PieceMovement {
    
    public init(){
        
    }
   
    open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        return false
    }
    
    func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board, stride: Int, allowWrapping: Bool = false) -> Bool {
        
        var movingPiece = board.getPiece(at: fromLocation)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        var testLocation = fromLocation.incremented(by: stride)
        
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
            
            testLocation = testLocation.incremented(by: stride)
            
            // If we're moving horizontally, make sure we watch out for row wrapping!
            if !allowWrapping && testLocation.y != fromLocation.y {
                return false
            }
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

// MARK - PieceMovementStraightLine

open class PieceMovementStraightLine: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        // Check downwards (-8, true)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: -8, allowWrapping: true){
            return true
        }
        
        // Check upwards (8, true)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: 8, allowWrapping: true){
            return true
        }
        
        // Check to right (1)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: 1){
            return true
        }
        
        // Check to left (-1)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: -1){
            return true
        }
   
        return false
        
    }
    
}

// MARK - PieceMovementDiagonal

open class PieceMovementDiagonal: PieceMovement {
    
    override open func canPieceMove(fromLocation: BoardLocation, toLocation: BoardLocation, board: Board) -> Bool {
        
        // Check South East (-7, true)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: -7, allowWrapping: true){
            return true
        }
        
        // Check South West (-9, true)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: -9, allowWrapping: true){
            return true
        }
        
        // Check North East (9)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: 9){
            return true
        }
        
        // Check North West (7)
        if canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: board, stride: 7){
            return true
        }
        
        return false
        
    }
    
}

// MARK - PieceMovementKnight

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

// MARK - PieceMovementPawn
/*
open class PieceMovementPawn: PieceMovement {
    
    override open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        var movingPiece = board.pieceAtIndex(fromIndex)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }

        var offset = (movingPiece!.color == .white) ? 1 : -1
        
        var target = fromIndex + offset
        if target == toIndex && canPieceOccupySquareAtOffset(fromIndex, offset: offset, board: board) {
            return true
        }
        
        return false
    }
}

// MARK - PieceMovementKing

open class PieceMovementKing: PieceMovement {
    
    override open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        let offsets = [-9, -8, -7, -1, 1, 7, 8, 9]
        
        for offset in offsets {
            
            let target = fromIndex + offset
            if target == toIndex && canPieceOccupySquareAtOffset(fromIndex, offset: offset, board: board) {
                return true
            }
        }
        
        return false
    }
}
 */







