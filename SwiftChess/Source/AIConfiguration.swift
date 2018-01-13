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
    internal var suicideMultipler: ConfigurationValue
    internal var boardRaterCountPiecesWeighting: ConfigurationValue
    internal var boardRaterBoardDominanceWeighting: ConfigurationValue
    internal var boardRaterCenterOwnershipWeighting: ConfigurationValue
    internal var boardRaterCenterDominanceWeighting: ConfigurationValue
    internal var boardRaterThreatenedPiecesWeighting: ConfigurationValue
    internal var boardRaterPawnProgressionWeighting: ConfigurationValue
    internal var boardRaterKingSurroundingPossessionWeighting: ConfigurationValue
    internal var boardRaterCheckMateOpportunityWeighting: ConfigurationValue
    internal var boardRaterCenterFourOccupationWeighting: ConfigurationValue
    
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
    
    internal init() {
        
        let zeroValue = ConfigurationValue(easyValue: 0, difficultValue: 0, multiplier: 0)
        
        difficulty = .easy
        suicideMultipler = zeroValue
        boardRaterCountPiecesWeighting = zeroValue
        boardRaterBoardDominanceWeighting = zeroValue
        boardRaterCenterOwnershipWeighting = zeroValue
        boardRaterCenterDominanceWeighting = zeroValue
        boardRaterThreatenedPiecesWeighting = zeroValue
        boardRaterPawnProgressionWeighting = zeroValue
        boardRaterKingSurroundingPossessionWeighting = zeroValue
        boardRaterCheckMateOpportunityWeighting = zeroValue
        boardRaterCenterFourOccupationWeighting = zeroValue
    }
}

extension AIConfiguration: DictionaryRepresentable {
    
    struct Keys {
        static let difficulty = "difficulty"
    }
    
    init?(dictionary: [String: Any]) {
        
        if let raw = dictionary[Keys.difficulty] as? Int, let difficulty = Difficulty(rawValue: raw) {
            self.init(difficulty: difficulty)
        } else {
            return nil
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary[Keys.difficulty] = difficulty.rawValue
        return dictionary
    }
}

extension AIConfiguration: Equatable {
    public static func == (lhs: AIConfiguration, rhs: AIConfiguration) -> Bool {
        return lhs.difficulty == rhs.difficulty
    }
}
