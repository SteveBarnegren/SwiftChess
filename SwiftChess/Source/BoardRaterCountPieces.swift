//
//  BoardRaterCountPieces.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 24/11/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterCountPieces: BoardRater {
        
    override func ratingFor(board: Board, color: Color) -> Double {
        
        var rating: Double = 0
        
        for square in board.squares {
            
            guard let piece = square.piece else {
                continue
            }
            
            rating += piece.color == color ? piece.value : -piece.value
        }
        
        return rating * configuration.boardRaterCountPiecesWeighting.value
    }
    
}
