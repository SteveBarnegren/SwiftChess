//
//  BoardRaterCenterDominance.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 13/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

/*
 Rates the board according to which player's pieces are able to move to the squares at the center of the board
 */

class BoardRaterCenterDominance: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        var rating = Double(0)
        
        for sourceLocation in BoardLocation.all {
            
            guard let piece = board.getPiece(at: sourceLocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                if sourceLocation == targetLocation ||
                    piece.movement.canPieceMove(from: sourceLocation,
                                                to: targetLocation,
                                                board: board) {
                    
                    let value = dominanceValueFor(location: targetLocation)
                    rating += (piece.color == color) ? value : -value
                }
                
            }
        }
        
        return rating * configuration.boardRaterCenterDominanceWeighting.value
    }
    
    func dominanceValueFor(location: BoardLocation) -> Double {
        
        let axisMiddle = 3.5
        
        let x = Double(location.x)
        let y = Double(location.y)
        
        let xDiff = abs(axisMiddle - x)
        let yDiff = abs(axisMiddle - y)
        
        let distance = sqrt((xDiff*xDiff)+(yDiff*yDiff))
        return axisMiddle - distance
    }

}
