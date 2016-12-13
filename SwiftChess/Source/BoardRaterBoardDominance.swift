//
//  BoardRaterBoardDominance.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

struct BoardRaterBoardDominance : BoardRater {
    
    func ratingfor(board: Board, color: Color) -> Double {

        let squareValue = 1.0;
        
        var rating = Double(0)
        
        // Check this color pieces
        for sourcelocation in BoardLocation.all {
            
            guard let piece = board.getPiece(at: sourcelocation) else{
                continue;
            }
            
            for targetLocation in BoardLocation.all {
                if piece.movement.canPieceMove(fromLocation: sourcelocation, toLocation: targetLocation, board: board) {
                    rating += (piece.color == color) ? squareValue : -squareValue;
                }
            }
            
        }
        
        return rating;
    }

}
