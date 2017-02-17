//
//  AIConfiguration.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 02/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public struct AIConfiguration {
    
    public enum Difficulty: Int {
        case easy
        case medium
        case hard
    }
    
    struct ConfigurationValue {
        let easyValue: Double
        let difficultValue: Double
        let multiplier: Double
        
        var value: Double {
            return easyValue + ((difficultValue - easyValue) * multiplier)
        }
    }
    
    public let difficulty: Difficulty!
    var suicideMultipler: ConfigurationValue!
    var boardRaterCountPiecesWeighting: ConfigurationValue!
    var boardRaterBoardDominanceWeighting: ConfigurationValue!
    var boardRaterCenterOwnershipWeighting: ConfigurationValue!
    var boardRaterCenterDominanceWeighting: ConfigurationValue!
    var boardRaterThreatenedPiecesWeighting: ConfigurationValue!
    var boardRaterPawnProgressionWeighting: ConfigurationValue!
    var boardRaterKingSurroundingPossessionWeighting: ConfigurationValue!
    var boardRaterCheckMateOpportunityWeighting: ConfigurationValue!
    var boardRaterCenterFourOccupationWeighting: ConfigurationValue!
    
    public init(difficulty: Difficulty) {
        
        self.difficulty = difficulty
        
        let multiplier: Double

        switch difficulty {
        case .easy: multiplier = 0
        case .medium: multiplier = 0.5
        case .hard: multiplier = 1
        }
        
        func makeValue(_ easyValue: Double, _ hardValue: Double) -> ConfigurationValue {
            return ConfigurationValue(easyValue: easyValue, difficultValue: hardValue, multiplier: multiplier)
        }
        
        suicideMultipler = makeValue(0, 0)
        boardRaterCountPiecesWeighting = makeValue(3, 3)
        boardRaterBoardDominanceWeighting = makeValue(0, 0.1)
        boardRaterCenterOwnershipWeighting = makeValue(0.1, 0.3)
        boardRaterCenterDominanceWeighting = makeValue(0, 0.3)
        boardRaterThreatenedPiecesWeighting = makeValue(0, 1.5)
        boardRaterPawnProgressionWeighting = makeValue(0.1, 1)
        boardRaterKingSurroundingPossessionWeighting = makeValue(0, 0.3)
        boardRaterCheckMateOpportunityWeighting = makeValue(0, 2)
        boardRaterCenterFourOccupationWeighting = makeValue(0.1, 0.3)
    }
    
}
