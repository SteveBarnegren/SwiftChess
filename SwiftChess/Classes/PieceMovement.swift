//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

// MARK - PieceMovement (Base Class)

public class PieceMovement {
    
    public init(){
        
    }
   
    public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        return false
    }
    
    func isIndexInBounds(index: Int) -> Bool {
        return (index < 64 && index >= 0)
    }
    
    func canPieceMoveWithStride(fromIndex fromIndex: Int, toIndex: Int, board: Board, stride: Int, allowWrapping: Bool = false) -> Bool {
        
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
    
    func canPieceOccupySquareAtOffset(pieceIndex: Int, offset: Int, board: Board) -> Bool{
        
        guard isIndexInBounds(pieceIndex+offset) else{
            return false
        }
        
        var movingPiece = board.pieceAtIndex(pieceIndex)
        
        if movingPiece == nil {
            print("Cannot from an index that does not contain a piece")
            return false
        }
        
        if let otherPiece = board.pieceAtIndex(pieceIndex+offset) {
            
            if otherPiece.color == movingPiece!.color {
                return false
            }
        }
        
        return true
    }

}

// MARK - PieceMovementStraightLine

public class PieceMovementStraightLine: PieceMovement {
    
    override public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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

public class PieceMovementDiagonal: PieceMovement {
    
    override public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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

public class PieceMovementKnight: PieceMovement {
    
    override public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        let offsets = [-17, -15, -10, -6, 6, 10, 15, 17]
        
        for offset in offsets {
            
            var target = fromIndex + offset
            if target == toIndex && canPieceOccupySquareAtOffset(fromIndex, offset: offset, board: board) {
                return true
            }
        }
        
        return false
    }
    
}

// MARK - PieceMovementPawn

public class PieceMovementPawn: PieceMovement {
    
    override public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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

public class PieceMovementKing: PieceMovement {
    
    override public func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        let offsets = [-9, -8, -7, -1, 1, 7, 8, 9]
        
        for offset in offsets {
            
            var target = fromIndex + offset
            if target == toIndex && canPieceOccupySquareAtOffset(fromIndex, offset: offset, board: board) {
                return true
            }
        }
        
        return false
    }
}







