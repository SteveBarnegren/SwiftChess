//
//  BoardRaterPawnProgression.swift
//  SwiftChess
//
//  Created by Steven Barnegren on 16/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterPawnProgression: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        var rating = Double(0)
     
        for location in BoardLocation.all {
         
            guard let piece = board.getPiece(at: location) else {
                continue
            }
            
            guard piece.type == .pawn else {
                continue
            }
            
            let pawnRating = progressionRatingForPawn(at: location, color: piece.color)
            rating += (piece.color == color) ? pawnRating : -pawnRating
        }
        
        return rating
    }
    
    func progressionRatingForPawn(at location: BoardLocation, color: Color) -> Double {
        
        var squaresAdvanced = Int(0)
        
        if color == .white {
            
            if location.y < 2 {
                return 0
            }
            
            squaresAdvanced = location.y - 2
        } else {
            
            if location.y > 5 {
                return 0
            }
            
            squaresAdvanced = 7 - (location.y + 2)
        }
        
        return Double(squaresAdvanced) * configuration.boardRaterPawnProgressionWeighting.value
    }
    
}
