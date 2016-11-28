//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Human : Player {
   
    public init(color: Color){
        super.init()
        self.color = color
    }
    
    // MARK: - Public
    
    public func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation) throws {
        
        // Check that we're the current player
        guard game.currentPlayer === self else {
            throw MoveError.notThisPlayersTurn
        }
        
        // Check if move is allowed
        let canMove = canMovePieceWithError(fromLocation: fromLocation, toLocation: toLocation)
        if let error = canMove.error {
            throw error
        }
        
        // Move the piece
        let operations = game.board.movePiece(fromLocation: fromLocation, toLocation: toLocation)
        
        // Inform the delegate that we made a move
        delegate?.playerDidMakeMove(player: self, boardOperations: operations)
    }
    
   
    
}


