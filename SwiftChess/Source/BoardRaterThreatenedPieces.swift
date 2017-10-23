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
    
    override func ratingfor(board: Board, color: Color) -> Double {
        
        let rating =  board.getPieces(color: color)
            .map { threatValue(forPiece: $0, onBoard: board) }
            .reduce(0, +)
            * configuration.boardRaterThreatenedPiecesWeighting.value
                
        return rating
    }
    
    func threatValue(forPiece piece: Piece, onBoard board: Board) -> Double {
        
        let threatenedByPieces = getPieces(threatening: piece, onBoard: board)
        let protectedByPieces = getPieces(protecting: piece, onBoard: board)
        let isThreatened = threatenedByPieces.count > 0
        let isProtected = protectedByPieces.count > 0
        
        // Threatened but not protected
        if isThreatened && !isProtected {
            return -piece.value() * 3
        }
        
        // Threatened, but protected (only return if the trade is not preferable)
        if isThreatened && isProtected {
            
            let lowestValueThreat = threatenedByPieces.lowestPieceValue()
            
            if lowestValueThreat < piece.value() {
                return -piece.value()
            }
            
            // Here we could bump the value to encourage a good trade?
        }
        
        let targetPieces = getPieces(threatenedBy: piece, onBoard: board)
        for targetPiece in targetPieces {
            
            let isTargetProtected = isPieceProtected(targetPiece, onBoard: board)
            
            // If it's protected, is it a good trade
            if isTargetProtected && targetPiece.value() < piece.value() {
                return 0
            } else {
                return targetPiece.value()
            }
        }
        
        // Nothing much interesting
        return 0
    }
    
    // MARK: - Helpers
    
    func getPieces(protecting piece: Piece, onBoard board: Board) -> [Piece] {
        
        var alteredBoard = board
        alteredBoard.setPiece(piece.withOppositeColor(), at: piece.location)
        
        return alteredBoard.getPieces(color: piece.color).filter {
            $0.movement.canPieceMove(fromLocation: $0.location,
                                     toLocation: piece.location,
                                     board: alteredBoard,
                                     accountForCheckState: true)
        }
    }
    
    func getPieces(protectedBy piece: Piece, onBoard board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color).filter {
            piece.movement.canPieceMove(fromLocation: piece.location,
                                        toLocation: $0.location,
                                        board: board,
                                        accountForCheckState: true)
        }
    }
    
    func isPieceProtected(_ piece: Piece, onBoard board: Board) -> Bool {
        
        var alteredBoard = board
        alteredBoard.setPiece(piece.withOppositeColor(), at: piece.location)
        
        for square in alteredBoard.squares {
            
            guard let squarePiece = square.piece else {
                continue
            }
            
            guard squarePiece.color == piece.color else {
                continue
            }
            
            if squarePiece.movement.canPieceMove(fromLocation: squarePiece.location,
                                                 toLocation: piece.location,
                                                 board: alteredBoard,
                                                 accountForCheckState: true) {
                return true
            }
        }
        
        return false
    }
    
    func isPieceThreatened(_ piece: Piece, onBoard board: Board) -> Bool {
        
        for square in board.squares {
            
            guard let squarePiece = square.piece else {
                continue
            }
            
            guard squarePiece.color == piece.color.opposite() else {
                continue
            }
            
            if squarePiece.movement.canPieceMove(fromLocation: squarePiece.location,
                                                 toLocation: piece.location,
                                                 board: board,
                                                 accountForCheckState: true) {
                return true
            }
        }
        
        return false
    }

    func getPieces(threatening piece: Piece, onBoard board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color.opposite()).filter {
            $0.movement.canPieceMove(fromLocation: $0.location,
                                     toLocation: piece.location,
                                     board: board,
                                     accountForCheckState: true)
        }
    }
    
    func getPieces(threatenedBy piece: Piece, onBoard board: Board) -> [Piece] {
        
        return board.getPieces(color: piece.color.opposite()).filter {
            piece.movement.canPieceMove(fromLocation: piece.location,
                                        toLocation: $0.location,
                                        board: board,
                                        accountForCheckState: true)
        }
    }
    
    func canPieceMoveToSafety(_ piece: Piece, onBoard board: Board) -> Bool {
        
        for location in BoardLocation.all {
            
            if piece.movement.canPieceMove(fromLocation: piece.location,
                                           toLocation: location,
                                           board: board,
                                           accountForCheckState: true) {
                
                var boardCopy = board
                boardCopy.movePiece(fromLocation: piece.location, toLocation: location)
                let movedPiece = boardCopy.getPiece(at: location)!
                if !isPieceThreatened(movedPiece, onBoard: boardCopy) {
                    return true
                }
            }
        }
        
        return false
    }
}

extension Collection where Iterator.Element == Piece {
    
    func lowestPieceValue() -> Double {
        
        if self.count == 0 {
            return 0
        }
        
        var result = self.first!.value()
        
        for piece in self {
            
            let pieceValue = piece.value()
            
            if pieceValue < result {
                result = pieceValue
            }
        }
        
        return result
    }
    
    func highestPieceValue() -> Double {
        
        if self.count == 0 {
            return 0
        }
        
        var result = self.first!.value()
        
        for piece in self {
            
            let pieceValue = piece.value()
            
            if pieceValue > result {
                result = pieceValue
            }
        }
        
        return result
    }

}
