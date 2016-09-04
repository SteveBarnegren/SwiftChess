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
   
    func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        return false
    }
    
    func isIndexInBounds(index: Int) -> Bool {
        return (index < 64 && index >= 0)
    }
    
    func canPieceMoveWithStride(fromIndex fromIndex: Int, toIndex: Int, board: Board, stride: Int) -> Bool {
        
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
            }
            // if the square is empty
            
            if index == toIndex {
                return true
            }
            
            index += stride
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

class PieceMovementStraightLine: PieceMovement {
    
    override func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        // Check downwards
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -8){
            return true
        }
        
        // Check upwards
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 8){
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

class PieceMovementDiagonal: PieceMovement {
    
    override func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
        // Check South East
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -7){
            return true
        }
        
        // Check South West
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: -9){
            return true
        }
        
        // Check North East
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 9){
            return true
        }
        
        // Check North West
        if canPieceMoveWithStride(fromIndex: fromIndex, toIndex: toIndex, board: board, stride: 7){
            return true
        }
        
        return false
        
    }
    
}

// MARK - PieceMovementKnight

class PieceMovementKnight: PieceMovement {
    
    override func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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

class PieceMovementPawn: PieceMovement {
    
    override func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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

class PieceMovementKing: PieceMovement {
    
    override func canPieceMove(fromIndex: Int, toIndex: Int, board: Board) -> Bool {
        
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







