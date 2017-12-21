//
//  BoardRaterThreatenedPieces.swift
//  SwiftChess
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

// Tendancy to protect own pieces

class BoardRaterThreatenedPieces: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        let rating =  board.getPieces(color: color)
            .map { threatValue(forPiece: $0, on: board) }
            .reduce(0, +)
            * configuration.boardRaterThreatenedPiecesWeighting.value
                
        return rating
    }
    
    func threatValue(forPiece piece: Piece, on board: Board) -> Double {
        
        let threatenedByPieces = getPieces(threatening: piece, on: board)
        let protectedByPieces = getPieces(protecting: piece, on: board)
        let isThreatened = threatenedByPieces.count > 0
        let isProtected = protectedByPieces.count > 0
        
        // Threatened but not protected
        if isThreatened && !isProtected {
            return -piece.value * 3
        }
        
        // Threatened, but protected (only return if the trade is not preferable)
        if isThreatened && isProtected {
            
            let lowestValueThreat = threatenedByPieces.lowestPieceValue
            
            if lowestValueThreat < piece.value {
                return -piece.value
            }
            
            // Here we could bump the value to encourage a good trade?
        }
        
        let targetPieces = getPieces(threatenedBy: piece, on: board)
        for targetPiece in targetPieces {
            
            let isTargetProtected = isPieceProtected(targetPiece, on: board)
            
            // If it's protected, is it a good trade
            if isTargetProtected && targetPiece.value < piece.value {
                return 0
            } else {
                return targetPiece.value
            }
        }
        
        // Nothing much interesting
        return 0
    }
    
    // MARK: - Helpers
    
    func getPieces(protecting piece: Piece, on board: Board) -> [Piece] {
        
        var alteredBoard = board
        alteredBoard.setPiece(piece.withOppositeColor, at: piece.location)
        
        return alteredBoard.getPieces(color: piece.color).filter {
            $0.movement.canPieceMove(from: $0.location,
                                     to: piece.location,
                                     board: alteredBoard,
                                     accountForCheckState: true)
        }
    }
    
    func getPieces(protectedBy piece: Piece, on board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color).filter {
            piece.movement.canPieceMove(from: piece.location,
                                        to: $0.location,
                                        board: board,
                                        accountForCheckState: true)
        }
    }
    
    func isPieceProtected(_ piece: Piece, on board: Board) -> Bool {
        
        var alteredBoard = board
        alteredBoard.setPiece(piece.withOppositeColor, at: piece.location)
        
        for square in alteredBoard.squares {
            
            guard let squarePiece = square.piece else {
                continue
            }
            
            guard squarePiece.color == piece.color else {
                continue
            }
            
            if squarePiece.movement.canPieceMove(from: squarePiece.location,
                                                 to: piece.location,
                                                 board: alteredBoard,
                                                 accountForCheckState: true) {
                return true
            }
        }
        
        return false
    }
    
    func isPieceThreatened(_ piece: Piece, on board: Board) -> Bool {
        
        for square in board.squares {
            
            guard let squarePiece = square.piece else {
                continue
            }
            
            guard squarePiece.color == piece.color.opposite else {
                continue
            }
            
            if squarePiece.movement.canPieceMove(from: squarePiece.location,
                                                 to: piece.location,
                                                 board: board,
                                                 accountForCheckState: true) {
                return true
            }
        }
        
        return false
    }

    func getPieces(threatening piece: Piece, on board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color.opposite).filter {
            $0.movement.canPieceMove(from: $0.location,
                                     to: piece.location,
                                     board: board,
                                     accountForCheckState: true)
        }
    }
    
    func getPieces(threatenedBy piece: Piece, on board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color.opposite).filter {
            piece.movement.canPieceMove(from: piece.location,
                                        to: $0.location,
                                        board: board,
                                        accountForCheckState: true)
        }
    }
    
    func canPieceMoveToSafety(_ piece: Piece, on board: Board) -> Bool {
        
        for location in BoardLocation.all {
            
            if piece.movement.canPieceMove(from: piece.location,
                                           to: location,
                                           board: board,
                                           accountForCheckState: true) {
                
                var boardCopy = board
                boardCopy.movePiece(from: piece.location, to: location)
                let movedPiece = boardCopy.getPiece(at: location)!
                if !isPieceThreatened(movedPiece, on: boardCopy) {
                    return true
                }
            }
        }
        
        return false
    }
}

extension Collection where Iterator.Element == Piece {
    
    var lowestPieceValue: Double {
        
        if self.count == 0 {
            return 0
        }
        
        var result = self.first!.value
        
        for piece in self {
            
            let pieceValue = piece.value
            
            if pieceValue < result {
                result = pieceValue
            }
        }
        
        return result
    }
    
    var highestPieceValue: Double {
        
        if self.count == 0 {
            return 0
        }
        
        var result = self.first!.value
        
        for piece in self {
            
            let pieceValue = piece.value
            
            if pieceValue > result {
                result = pieceValue
            }
        }
        
        return result
    }

}
