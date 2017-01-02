//
//  AIConfiguration.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

class AIConfiguration {

    // BoardRater -  Count Pieces
    let boardRaterCountPiecesWeighting = Double(1)
    
    // BoardRater - Board Dominance
    let boardRaterBoardDominanceWeighting = Double(1)
    
    // BoardRater - Center Ownership
    let boardRaterCenterOwnershipWeighting = Double(1)
    
    // BoardRater - Center Dominance
    let boardRaterCenterDominanceWeighting = Double(1)
    
    // BoardRater - Threatened Pieces
    let boardRaterThreatenedPiecesWeighting = Double(1)
    let boardRaterThreatenedPiecesOwnPiecesMultiplier = Double(2)

    // BoardRater - Pawn Progression
    let boardRaterPawnProgressionWeighting = Double(1)
    
    // BoardRater - King Surrounding Possession
    let boardRaterKingSurroundingPossessionRating = Double(1)
    
    // BoardRater - Check Mate Opportunity
    let boardRaterCheckMateOpportunityRating = Double(2)
    
    
}
