//
//  File.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 27/11/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

/*
Rates the board according to which player's pieces are occupying the center of the board
 */

class BoardRaterCenterOwnership: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        var rating = Double(0)
    
        for location in BoardLocation.all {
            
            guard let piece = board.getPiece(at: location) else {
                continue
            }
            
            let distance = dominanceValueFor(location: location)
            
            rating += (piece.color == color) ? distance : -distance
        }
        
        return rating * configuration.boardRaterCenterOwnershipWeighting.value
    
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
