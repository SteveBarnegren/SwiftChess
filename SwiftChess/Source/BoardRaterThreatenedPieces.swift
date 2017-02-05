//
//  BoardRaterThreatenedPieces.swift
//  SwiftChess
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

// Tendancy to protect own pieces

class BoardRaterThreatenedPieces : BoardRater {
    
    override func ratingfor(board: Board, color: Color) -> Double {
        
        return 0;
        
        let allPieceLocations = board.squares.enumerated().flatMap{ (index, square) -> BoardLocation? in
            if square.piece != nil {
                return BoardLocation(index: index)
            }
            else{
                return nil
            }
        }
        
        for pieceLocation in allPieceLocations {
            
            var rating = 0;
            
            
            
            
            
            
            
            
            
            
        }
        
    }
    
    // MARK: - Helpers
    /*
    func piecesProtectingPiece(atLocation location: BoardLocation) -> [Piece] {
        
        
        
        
        
        
        
        
        
    }
 */
 
    
    
    
    
    

    
}
