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
   
    open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        return false
    }
    
    func isIndexInBounds(_ index: Int) -> Bool {
        return (index < 64 && index >= 0)
    }
    
    func canPieceMoveWithStride(fromIndex: Int, toIndex: Int, board: Board, stride: Int, allowWrapping: Bool = false) -> Bool {
        
        let startRowIndex = fromIndex / 8
        
        var movingPiece = board.pieceAtIndex(fromIndex)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        var index = fromIndex + stride
        
        while isIndexInBounds(index) {
            
            // If there is a piece on the square
            if let piece = board.pieceAtIndex(index) {
                
                if piece.color == movingPiece!.color {
                    return false
                }
                
                if piece.color == movingPiece!.color.opposite() && index == toIndex {
                    return true
                }
                
                if piece.color == movingPiece!.color.opposite() && index != toIndex {
                    return false
                }
            }
            // if the square is empty
            if index == toIndex {
                return true
            }
            
            index += stride
            
            // If we're moving horizontally, make sure we watch out for row wrapping!
            if !allowWrapping && (index / 8 != startRowIndex) {
                return false
            }
        }
        
        return false
    }
    
    func canPieceOccupySquareAtOffset(pieceIndex: Int, xOffset: Int, yOffset: Int, board: Board) -> Bool{
        
        let targetIndex = pieceIndex + (yOffset * 8) + xOffset
        
        // Check if in bounds
        guard isIndexInBounds(targetIndex) else{
            return false
        }
        
        // Check if wrapped
        let currentY = Int(pieceIndex / 8)
        let currentX = pieceIndex % 8
        let targetY = Int(targetIndex / 8)
        let targetX = targetIndex % 8
        
        if targetX - currentX != xOffset || targetY - currentY != yOffset {
            return false
        }
        
        // Check if space is occupied
        var movingPiece = board.pieceAtIndex(pieceIndex)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        if let otherPiece = board.pieceAtIndex(targetIndex) {
            
            if otherPiece.color == movingPiece!.color {
                return false
            }
        }
        
        return true
    }

}

// MARK - PieceMovementStraightLine

open class PieceMovementStraightLine: PieceMovement {
    
    override open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        // Check downwards
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -8, allowWrapping: true){
            return true
        }
        
        // Check upwards
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 8, allowWrapping: true){
            return true
        }
        
        // Check to right
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 1){
            return true
        }
        
        // Check to left
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -1){
            return true
        }
   
        return false
        
    }
    
}

// MARK - PieceMovementDiagonal

open class PieceMovementDiagonal: PieceMovement {
    
    override open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        // Check South East
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -7, allowWrapping: true){
            return true
        }
        
        // Check South West
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -9, allowWrapping: true){
            return true
        }
        
        // Check North East
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 9, allowWrapping: true){
            return true
        }
        
        // Check North West
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 7, allowWrapping: true){
            return true
        }
        
        return false
        
    }
    
}

// MARK - PieceMovementKnight

open class PieceMovementKnight: PieceMovement {
    
    override open func canPieceMove(_ fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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
            
            let offsetTarget = fromIndex + (offset.x) + (offset.y * 8)
            
            if toIndex == offsetTarget && canPieceOccupySquareAtOffset(pieceIndex: fromIndex, xOffset: offset.x, yOffset: offset.y, board: board) {
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







