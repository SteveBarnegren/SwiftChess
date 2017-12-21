//
//  BoardRaterBoardDominance.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterBoardDominance: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {

        let squareValue = Double(1)
        
        var rating = Double(0)
        
        // Check this color pieces
        for sourcelocation in BoardLocation.all {
            
            guard let piece = board.getPiece(at: sourcelocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                if piece.movement.canPieceMove(from: sourcelocation, to: targetLocation, board: board) {
                    rating += (piece.color == color) ? squareValue : -squareValue
                }
            }
            
        }
        
        return rating * configuration.boardRaterBoardDominanceWeighting.value
    }

}
