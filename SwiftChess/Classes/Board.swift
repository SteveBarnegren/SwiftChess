//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

// MARK - ****** Square ******

public struct Square {
    
    var piece: Piece?
    
}

// MARK - ****** Board ******

public struct Board {

    var squares = [Square]()
    
    // MARK - Init
    init(){
        
        // Setup squares
        for i in 0..<64 {
            squares.append(Square())
        }
     
        // Setup white bottom row
        self.squares[0].piece = Piece(type: .rook, color: .white)
        self.squares[1].piece = Piece(type: .knight, color: .white)
        self.squares[2].piece = Piece(type: .bishop, color: .white)
        self.squares[3].piece = Piece(type: .queen, color: .white)
        self.squares[4].piece = Piece(type: .king, color: .white)
        self.squares[5].piece = Piece(type: .bishop, color: .white)
        self.squares[6].piece = Piece(type: .knight, color: .white)
        self.squares[7].piece = Piece(type: .rook, color: .white)
        
        // Setup white pawn row
        for i in 8...15 {
            self.squares[i].piece = Piece(type: .pawn, color: .white)
        }
        
        // Setup black bottom row
        self.squares[63].piece = Piece(type: .rook, color: .black)
        self.squares[62].piece = Piece(type: .knight, color: .black)
        self.squares[61].piece = Piece(type: .bishop, color: .black)
        self.squares[60].piece = Piece(type: .queen, color: .black)
        self.squares[59].piece = Piece(type: .king, color: .black)
        self.squares[58].piece = Piece(type: .bishop, color: .black)
        self.squares[57].piece = Piece(type: .knight, color: .black)
        self.squares[56].piece = Piece(type: .rook, color: .black)

        // Setup black pawn row
        for i in 48...55 {
            self.squares[i].piece = Piece(type: .pawn, color: .black)
        }
        
    }
    
    
    
    // MARK - Print
    
    public func printBoardColors() {
        printBoard { (square: Square) -> Character? in
            
            if let piece = square.piece{
                return piece.color == .white ? "W" : "B"
            }
            return nil;
        }
    }
    
    public func printBoardPieces() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece{
                
                switch (piece.type){
                case .rook:
                    character = "R"
                case .knight:
                    character = "K"
                case .bishop:
                    character = "B"
                case .queen:
                    character = "Q"
                case .king:
                    character = "G"
                case .pawn:
                    character = "P"

                }
            }
            return character;
        }
    }
    
    public func printBoardState() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece{
                
                switch (piece.type){
                case .rook:
                    character = piece.color == .white ? "R" : "r"
                case .knight:
                    character = piece.color == .white ? "K" : "k"
                case .bishop:
                    character = piece.color == .white ? "B" : "b"
                case .queen:
                    character = piece.color == .white ? "Q" : "q"
                case .king:
                    character = piece.color == .white ? "K" : "k"
                case .pawn:
                    character = piece.color == .white ? "P" : "p"
                }
                
            }
            return character;
        }
    }


    
    public func printBoard( squarePrinter: (Square) -> Character? ){
        
        var printString = String()
        
        for y in  (0...7).reverse(){
            for x in 0...7 {
                
                let index = y*8 + x
                let character = squarePrinter(squares[index])
                printString.append(character ?? "-")
            }
            
            printString.append(Character("\n"))
        }
        
        print(printString)
    }
    
    
}
