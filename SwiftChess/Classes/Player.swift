//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Player {
   
    let color: Color!
    weak var game: Game!
    
    init(color: Color, game: Game){
        self.color = color
        self.game = game;
    }
    
    func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation){
        
        // We can't move to our current location
        if fromLocation == toLocation {
            print("Cannot move piece to its current location")
        }
        
        // Get the piece
        guard let piece = self.game.board.getPiece(at: fromLocation) else {
            print("There isn't a piece of color \(color) at \(fromLocation)")
            return
        }
        
        // Check that the piece color matches the player color
        if piece.color != self.color {
            print("Player color \(color) cannot move piece of color \(piece.color)")
            return;
        }
        
        // Make sure the piece can move to the location
        if !piece.movement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: game.board) {
            print("Piece at \(fromLocation) cannot move to \(toLocation)")
        }
        
        // Move the piece
        
        print("Piece can be moved")
        
    }
    
}

