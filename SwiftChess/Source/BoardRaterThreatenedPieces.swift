//
//  BoardRaterThreatenedPieces.swift
//  SwiftChess
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

struct BoardRaterThreatenedPieces : BoardRater {
    
    func ratingfor(board: Board, color: Color) -> Double {
        
        var rating = Double(0)
     
        for location in BoardLocation.all {
            
            guard let piece = board.getPiece(at: location) else {
                continue;
            }
            
            let threatRating = threatRatingForPiece(at: location, board: board)
            
            rating += (piece.color == color) ? -threatRating : threatRating;
        }
        
        return rating
    }
    
    
    func threatRatingForPiece(at location: BoardLocation, board: Board) -> Double {
        
        guard let piece = board.getPiece(at: location) else{
            fatalError()
        }
        
        var rating = Double(0)
        
        for otherPieceLocation in BoardLocation.all {
            
            if otherPieceLocation == location {
                continue
            }
            
            guard let otherPiece = board.getPiece(at: otherPieceLocation) else {
                continue
            }
            
            guard otherPiece.color == piece.color else{
                continue
            }
            
            if otherPiece.movement.canPieceMove(fromLocation: otherPieceLocation, toLocation: location, board: board){
                rating += piece.value()
            }
            
        }
        
        return rating
    }
}
