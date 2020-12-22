//
//  BoardScenarios.swift
//  Example
//
//  Created by Steve Barnegren on 26/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftChess

extension Board {
    
    public static func whiteInStaleMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- - r - r - - k" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "q - - - - - - -" +
                                  "- - - K - - - -" ).board
    }
    
    public static func blackInStaleMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- - R - R - - K" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "Q - - - - - - -" +
                                  "- - - k - - - -" ).board
    }
    
    public static func whiteInCheckMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- p k - - - - N" +
                                  "- - - - - P - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "r - - - - - - -" +
                                  "r - - K - - - -" ).board
    }
    
    public static func blackInCheckMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- - - k - - - R" +
                                  "- - - - - - - R" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- K - - - - - -" ).board
    }
    
}
