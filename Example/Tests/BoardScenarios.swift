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
        
        return ASCIIBoard(pieces: "- - r - r - - g" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "q - - - - - - -" +
                                  "- - - G - - - -" ).board
    }
    
    public static func blackInStaleMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- - R - R - - G" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "Q - - - - - - -" +
                                  "- - - g - - - -" ).board
    }
    
    public static func whiteInCheckMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- p g - - - - K" +
                                  "- - - - - P - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "r - - - - - - -" +
                                  "r - - G - - - -" ).board
    }
    
    public static func blackInCheckMateScenario() -> Board {
        
        return ASCIIBoard(pieces: "- - - g - - - R" +
                                  "- - - - - - - R" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- - - - - - - -" +
                                  "- G - - - - - -" ).board
    }
    
}
