//
//  File.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 08/10/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation
import SwiftChess

func transformASCIIBoardInput(_ input: String) -> String{
    
    let boardArt = input.replacingOccurrences(of: " ", with: "")
    
    var transformedArt = String()
    
    for y in  (0...7).reversed(){
        for x in 0...7 {
            
            let index = y*8 + x
            transformedArt.append(boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: index)])
        }
    }
    
    return transformedArt
    
}

public struct ASCIIBoard {
    
    let artString: String
    var stringContainsColors: Bool!
    
    public init(
        // Row 8
        _ a8: Character,
        _ b8: Character,
        _ c8: Character,
        _ d8: Character,
        _ e8: Character,
        _ f8: Character,
        _ g8: Character,
        _ h8: Character,
        // Row 7
        _ a7: Character,
        _ b7: Character,
        _ c7: Character,
        _ d7: Character,
        _ e7: Character,
        _ f7: Character,
        _ g7: Character,
        _ h7: Character,
        // Row 6
        _ a6: Character,
        _ b6: Character,
        _ c6: Character,
        _ d6: Character,
        _ e6: Character,
        _ f6: Character,
        _ g6: Character,
        _ h6: Character,
        
        // Row 5
        _ a5: Character,
        _ b5: Character,
        _ c5: Character,
        _ d5: Character,
        _ e5: Character,
        _ f5: Character,
        _ g5: Character,
        _ h5: Character,
        // Row 4
        _ a4: Character,
        _ b4: Character,
        _ c4: Character,
        _ d4: Character,
        _ e4: Character,
        _ f4: Character,
        _ g4: Character,
        _ h4: Character,
        // Row 3
        _ a3: Character,
        _ b3: Character,
        _ c3: Character,
        _ d3: Character,
        _ e3: Character,
        _ f3: Character,
        _ g3: Character,
        _ h3: Character,
        // Row 2
        _ a2: Character,
        _ b2: Character,
        _ c2: Character,
        _ d2: Character,
        _ e2: Character,
        _ f2: Character,
        _ g2: Character,
        _ h2: Character,
        // Row 1
        _ a1: Character,
        _ b1: Character,
        _ c1: Character,
        _ d1: Character,
        _ e1: Character,
        _ f1: Character,
        _ g1: Character,
        _ h1: Character
        ){
        
        var inputAsString =
        "\(a8) \(b8) \(c8) \(d8) \(e8) \(f8) \(g8) \(h8)" +
        "\(a7) \(b7) \(c7) \(d7) \(e7) \(f7) \(g7) \(h7)" +
        "\(a6) \(b6) \(c6) \(d6) \(e6) \(f6) \(g6) \(h6)" +
        "\(a5) \(b5) \(c5) \(d5) \(e5) \(f5) \(g5) \(h5)" +
        "\(a4) \(b4) \(c4) \(d4) \(e4) \(f4) \(g4) \(h4)" +
        "\(a3) \(b3) \(c3) \(d3) \(e3) \(f3) \(g3) \(h3)" +
        "\(a2) \(b2) \(c2) \(d2) \(e2) \(f2) \(g2) \(h2)" +
        "\(a1) \(b1) \(c1) \(d1) \(e1) \(f1) \(g1) \(h1)";

        // Transform
        inputAsString = transformASCIIBoardInput(inputAsString)
        
        // Check string format
        assert(inputAsString.characters.count == 64, "ASCII board art must be 128 characters long")
        
        self.artString = inputAsString
        self.stringContainsColors = false
        
    }
    
    public init(pieces artString: String) {

        var artString = artString
        
        // Transform
        artString = transformASCIIBoardInput(artString)
        
        // Check string format
        assert(artString.characters.count == 64, "ASCII board art must be 128 characters long")
        
        self.artString = artString
        self.stringContainsColors = false
        
    }
    
    public init(colors artString: String) {
        
        self.init(pieces: artString)
        self.stringContainsColors = true
    }
    
    public var board: Board {
        
        var boardArt = artString
        
        // We only care about colours, not piece types, so just make pawns
        if stringContainsColors == true {
            boardArt = boardArt.replacingOccurrences(of: "B", with: "p")
            boardArt = boardArt.replacingOccurrences(of: "W", with: "P")
        }
        
        var board = Board(state: .empty)
        
        // Clear all pieces on the board
        (0..<64).forEach{
            board.squares[$0].piece = nil;
        }
        
        // Setup pieces from ascii art
        (0..<64).forEach{
            let character = boardArt[boardArt.characters.index(boardArt.startIndex, offsetBy: $0)]
            board.squares[$0].piece = pieceFromCharacter(character)
        }
        
        return board
    }

    
    func pieceFromCharacter(_ character: Character) -> Piece? {
        
        var piece: Piece?
        
        switch character {
        case "R":
            piece = Piece(type: .rook, color: .white)
        case "K":
            piece = Piece(type: .knight, color: .white)
        case "B":
            piece = Piece(type: .bishop, color: .white)
        case "Q":
            piece = Piece(type: .queen, color: .white)
        case "G":
            piece = Piece(type: .king, color: .white)
        case "P":
            piece = Piece(type: .pawn, color: .white)
        case "r":
            piece = Piece(type: .rook, color: .black)
        case "k":
            piece = Piece(type: .knight, color: .black)
        case "b":
            piece = Piece(type: .bishop, color: .black)
        case "q":
            piece = Piece(type: .queen, color: .black)
        case "g":
            piece = Piece(type: .king, color: .black)
        case "p":
            piece = Piece(type: .pawn, color: .black)
        default:
            piece = nil
        }
        
        return piece
    }
    
    public func indexOfCharacter(_ character: Character) -> Int{
        
        var index: Int?
        
        if let idx = artString.characters.index(of: character) {
            index = artString.characters.distance(from: artString.startIndex, to: idx)
        }
        
        assert(index != nil, "Unable to find index of character: \(character)")
        return index!
    }
    
    public func locationOfCharacter(_ character: Character) -> BoardLocation {
        
        let index = indexOfCharacter(character)
        return BoardLocation(index: index)
    }
    
    public func indexesWithCharacter(_ character: Character) -> [Int]{
        
        var indexes = [Int]()
        
        (0..<64).forEach{
            let aCharacter = artString[artString.characters.index(artString.startIndex, offsetBy: $0)]
            if character == aCharacter {
                indexes.append($0)
            }
        }
        
        return indexes
    }

    public func locationsWithCharacter(_ character: Character) -> [BoardLocation] {
        
        let indexes = indexesWithCharacter(character)
        
        var locations = [BoardLocation]()
        
        indexes.forEach{
            let location = BoardLocation(index: $0)
            locations.append(location)
        }
        
        return locations
    }

}
