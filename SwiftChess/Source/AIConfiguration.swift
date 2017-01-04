//
//  AIConfiguration.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

struct AIConfiguration {

    // BoardRater -  Count Pieces
    var boardRaterCountPiecesWeighting: Double!
    
    // BoardRater - Board Dominance
    var boardRaterBoardDominanceWeighting: Double!
    
    // BoardRater - Center Ownership
    var boardRaterCenterOwnershipWeighting: Double!
    
    // BoardRater - Center Dominance
    var boardRaterCenterDominanceWeighting: Double!
    
    // BoardRater - Threatened Pieces
    var boardRaterThreatenedPiecesWeighting: Double!
    var boardRaterThreatenedPiecesOwnPiecesMultiplier: Double!

    // BoardRater - Pawn Progression
    var boardRaterPawnProgressionWeighting: Double!
    
    // BoardRater - King Surrounding Possession
    var boardRaterKingSurroundingPossessionWeighting: Double!
    
    // BoardRater - Check Mate Opportunity
    var boardRaterCheckMateOpportunityWeighting: Double!
    
    // BoardRater - Center Four Occupation
    var boardRaterCenterFourOccupationWeighting: Double!
    
    init() {
        setDefualtValues()
    }
    
    mutating func setDefualtValues() {
        boardRaterCountPiecesWeighting = 1
        boardRaterBoardDominanceWeighting = 1
        boardRaterCenterOwnershipWeighting = 1
        boardRaterCenterDominanceWeighting = 1
        boardRaterThreatenedPiecesWeighting = 1
        boardRaterThreatenedPiecesOwnPiecesMultiplier = 2
        boardRaterPawnProgressionWeighting = 1
        boardRaterKingSurroundingPossessionWeighting = 1
        boardRaterCheckMateOpportunityWeighting = 2
        boardRaterCenterFourOccupationWeighting = 1
    }
    
}
