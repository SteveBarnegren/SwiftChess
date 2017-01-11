//
//  KingsGambit.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 09/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

struct KingsGambit: Opening {
    
    let name = "Kings Gambit"
    
    var introStates: [Board] {
        
        var states = [Board]()
        
        // White moves pawn to (4, 3)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p p p p p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P - - -" +
                                        "- - - - - - - -" +
                                        "P P P P - P P P" +
                                        "R K B Q G B K R" ).board)
        
        // Black moves pawn to (4, 4)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - p - - -" +
                                        "- - - - P - - -" +
                                        "- - - - - - - -" +
                                        "P P P P - P P P" +
                                        "R K B Q G B K R" ).board)
        
        // White offers sacrifice pawn at (5, 1) (Gambit)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - p - - -" +
                                        "- - - - P P - -" +
                                        "- - - - - - - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B K R" ).board)
        
        return states
    }
    
    // MARK: - ****** Black accepts gambit ******
    
    func branchOne() -> [Board] {
        
        var states = [Board]()
        
        // Black accepts gambit, takes pawn at (5, 3)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - - - - - - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B K R" ).board)
        
        // White moves knight to (5, 2)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - - - - K - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B - R" ).board)
        
        // Black moves pawn to (6, 4) to protect centre pawn
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p - p" +
                                        "- - - - - - - -" +
                                        "- - - - - - p -" +
                                        "- - - - P p - -" +
                                        "- - - - - K - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B - R" ).board)
        
        // White moves pawn to (7, 3) to attack black's pawn
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p - p" +
                                        "- - - - - - - -" +
                                        "- - - - - - p -" +
                                        "- - - - P p - P" +
                                        "- - - - - K - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)
        
        // Black attacks white knight by moving pawn to (6, 3)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p - p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p p P" +
                                        "- - - - - K - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)
        
        // White moves knight to (6, 4)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p - p" +
                                        "- - - - - - - -" +
                                        "- - - - - - K -" +
                                        "- - - - P p p P" +
                                        "- - - - - - - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)

        // Black attacks knight with pawn to (7, 2)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p - -" +
                                        "- - - - - - - p" +
                                        "- - - - - - K -" +
                                        "- - - - P p p P" +
                                        "- - - - - - - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)
        
        // White sacrifices knight by moving to (5, 6)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - K - -" +
                                        "- - - - - - - p" +
                                        "- - - - - - - -" +
                                        "- - - - P p p P" +
                                        "- - - - - - - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)
        
        // Black captures knight with king to (5, 6)
        states.append(ASCIIBoard(pieces:"r k b q - b k r" +
                                        "p p p p - g - -" +
                                        "- - - - - - - p" +
                                        "- - - - - - - -" +
                                        "- - - - P p p P" +
                                        "- - - - - - - -" +
                                        "P P P P - - P -" +
                                        "R K B Q G B - R" ).board)
        
        // White attacks black with queen to (6, 3)
        states.append(ASCIIBoard(pieces:"r k b q - b k r" +
                                        "p p p p - g - -" +
                                        "- - - - - - - p" +
                                        "- - - - - - - -" +
                                        "- - - - P p Q P" +
                                        "- - - - - - - -" +
                                        "P P P P - - P -" +
                                        "R K B - G B - R" ).board)

        
        return states
    }
    
    func branchTwo() -> [Board] {
        
        var states = [Board]()
        
        // Black accepts gambit, takes pawn at (5, 3)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - - - - - - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B K R" ).board)
        
        // White moves knight to (5, 2)
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p p - p p p" +
                                        "- - - - - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - - - - K - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B - R" ).board)
        
        // Black moves pawn to d6
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p - - p p p" +
                                        "- - - p - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - - - - K - -" +
                                        "P P P P - - P P" +
                                        "R K B Q G B - R" ).board)
        
        // White develops knight to c3
        states.append(ASCIIBoard(pieces:"r k b q g b k r" +
                                        "p p p - - p p p" +
                                        "- - - p - - - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - K - - K - -" +
                                        "P P P P - - P P" +
                                        "R - B Q G B - R" ).board)
        
        // Black develops knight to f6
        states.append(ASCIIBoard(pieces:"r k b q g b - r" +
                                        "p p p - - p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - - - P p - -" +
                                        "- - K - - K - -" +
                                        "P P P P - - P P" +
                                        "R - B Q G B - R" ).board)
        
        // White pawn to d4
        states.append(ASCIIBoard(pieces:"r k b q g b - r" +
                                        "p p p - - p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - - P P p - -" +
                                        "- - K - - K - -" +
                                        "P P P - - - P P" +
                                        "R - B Q G B - R" ).board)
        
        // Black bishop to e7
        states.append(ASCIIBoard(pieces:"r k b q g - - r" +
                                        "p p p - b p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - - P P p - -" +
                                        "- - K - - K - -" +
                                        "P P P - - - P P" +
                                        "R - B Q G B - R" ).board)
        
        // White bishop to c4
        states.append(ASCIIBoard(pieces:"r k b q g - - r" +
                                        "p p p - b p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - B P P p - -" +
                                        "- - K - - K - -" +
                                        "P P P - - - P P" +
                                        "R - B Q G - - R" ).board)
        
        // Black castles
        states.append(ASCIIBoard(pieces:"r k b q - r g -" +
                                        "p p p - b p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - B P P p - -" +
                                        "- - K - - K - -" +
                                        "P P P - - - P P" +
                                        "R - B Q G - - R" ).board)
        
        // White castles
        states.append(ASCIIBoard(pieces:"r k b q - r g -" +
                                        "p p p - b p p p" +
                                        "- - - p - k - -" +
                                        "- - - - - - - -" +
                                        "- - B P P p - -" +
                                        "- - K - - K - -" +
                                        "P P P - - - P P" +
                                        "R - B Q - R G -" ).board)

        return states
    }

    
    
    
    
    
    
    
    
}
