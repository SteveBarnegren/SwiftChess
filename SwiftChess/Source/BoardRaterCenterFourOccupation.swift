//
//  BoardRaterCenterFourOccupation.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 03/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterCenterFourOccupation: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        let value = Double(1)
        var rating = Double(0)
        
        let locations = [
            BoardLocation(x: 4, y: 4), // NE
            BoardLocation(x: 4, y: 3), // SE
            BoardLocation(x: 3, y: 3), // SW
            BoardLocation(x: 3, y: 4)  // NW
                         ]
        
        for location in locations {
            
            guard let piece = board.getPiece(at: location) else {
                continue
            }
            
            rating += piece.color == color ? value : -value
        }
        
        return rating * configuration.boardRaterCenterFourOccupationWeighting.value
    }
}
