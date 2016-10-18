//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

// MARK: - ****** BoardStride ******

public struct BoardStride {
    
    public var x: Int;
    public var y: Int;
    
    public init(x: Int, y: Int){
        self.x = x;
        self.y = y;
    }

}

// MARK: - ****** BoardLocation ******

public struct BoardLocation : Equatable {
    
    public var index: Int
    
    public var x: Int {
        return index % 8
    }
    
    public var y: Int {
        return index / 8
    }
    
    public init(index: Int) {
        self.index = index
    }
    
    public init(x: Int, y: Int) {
        self.index = x + (y*8)
    }
    
    func isInBounds() -> Bool {
        return (index < 64 && index >= 0)
    }
    
    func incremented(by offset: Int) -> BoardLocation {
        return BoardLocation(index: index + offset)
    }
    
    func incrementedBy(x: Int, y: Int) -> BoardLocation {
        return self + BoardLocation(x: x, y: y)
    }
    
    func incrementedBy(stride: BoardStride) -> BoardLocation {
        
        // TODO: for performance, we should probably only check this if we're in debug mode
        if !canIncrementBy(stride: stride) {
            print("WARNING! BoardLocation is being incremented by a stride that will result in wrapping! call canIncrementBy(stride: BoardStride) first")
        }
        
        return BoardLocation(x: x + stride.x,
                             y: y + stride.y)
    }
    
    func canIncrementBy(stride: BoardStride) -> Bool {
        
        // Check will not wrap to right
        if x + stride.x > 7  {
            return false
        }
        
        // Check will not wrap to left
        if x + stride.x < 0  {
            return false
        }
        
        // Check will not wrap top
        if y + stride.y > 7  {
            return false
        }
        
        // Check will not wrap bottom
        if y + stride.y < 0  {
            return false
        }
        
        return true
    }
}

public func ==(lhs: BoardLocation, rhs: BoardLocation) -> Bool {
    return lhs.index == rhs.index
}

public func +(left: BoardLocation, right: BoardLocation) -> BoardLocation {
    return BoardLocation(index: left.index + right.index)
}

// MARK: - ****** Square ******

public struct Square {
    
    public var piece: Piece?
    
}

// MARK: - ****** Board ******

public struct Board {
    
    public enum InitialState {
        case empty
        case newGame
    }

    public var squares = [Square]()
    
    // MARK: - Init
    public init(state: InitialState) {
        
        // Setup squares
        for i in 0..<64 {
            squares.append(Square())
        }
        
        // Setup for new game?
        if state == .newGame {
            setupForNewGame()
        }
     
    }
    
    mutating func setupForNewGame() {
        
        // Setup white bottom row
        squares[0].piece = Piece(type: .rook, color: .white)
        squares[1].piece = Piece(type: .knight, color: .white)
        squares[2].piece = Piece(type: .bishop, color: .white)
        squares[3].piece = Piece(type: .queen, color: .white)
        squares[4].piece = Piece(type: .king, color: .white)
        squares[5].piece = Piece(type: .bishop, color: .white)
        squares[6].piece = Piece(type: .knight, color: .white)
        squares[7].piece = Piece(type: .rook, color: .white)
        
        // Setup white pawn row
        for i in 8...15 {
            squares[i].piece = Piece(type: .pawn, color: .white)
        }
        
        // Setup black bottom row
        squares[63].piece = Piece(type: .rook, color: .black)
        squares[62].piece = Piece(type: .knight, color: .black)
        squares[61].piece = Piece(type: .bishop, color: .black)
        squares[60].piece = Piece(type: .queen, color: .black)
        squares[59].piece = Piece(type: .king, color: .black)
        squares[58].piece = Piece(type: .bishop, color: .black)
        squares[57].piece = Piece(type: .knight, color: .black)
        squares[56].piece = Piece(type: .rook, color: .black)
        
        // Setup black pawn row
        for i in 48...55 {
            squares[i].piece = Piece(type: .pawn, color: .black)
        }

    }
    
    // MARK: - Manipulate Pieces
    
    public mutating func setPiece(_ piece: Piece, at location: BoardLocation) {
        squares[location.index].piece = piece
    }
    
    public func getPiece(at location: BoardLocation) -> Piece? {
        return squares[location.index].piece
    }
    
    public mutating func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation){
        
        squares[toLocation.index].piece = self.squares[fromLocation.index].piece
        squares[fromLocation.index].piece = nil
        
    }
    
    // MARK: - Get Specific pieces
    
    func getKing(color: Color) -> Piece {
    
        var king: Piece?
    
        for square in squares {
            
            guard let piece = square.piece else{
                continue
            }
            
            if piece == Piece(type: .king, color: color) {
                king = piece
                break
            }
        }
        
        // We'll implitly unwrap this, because there should always be a king for each color on the board. If there isn't, it's an error
        return king!
    }
    
    public func getKingLocation(color: Color) -> BoardLocation {
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else{
                continue
            }
            
            if piece.color == color && piece.type == .king {
                return BoardLocation(index: index)
            }
        }
        
        fatalError("Couldn't find \(color) king. Kings should always exist")
    }
    
    public func getLocationsOfColor(_ color: Color) -> [BoardLocation] {
        
        var locations = [BoardLocation]()
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else {
                continue
            }
            
            if piece.color == color {
                locations.append(BoardLocation(index: index))
            }
        }
        
        return locations
    }
    
    public func getPieces(color: Color) -> [Piece] {
        
        var pieces = [Piece]()
        
        for square in squares {
            
            guard let piece = square.piece else{
                continue
            }
            
            if piece.color == color {
                pieces.append(piece)
            }
        }
        
        return pieces
        
    }
    
    // MARK: - Check / Check mate state
    
    public func isColorInCheck(color: Color) -> Bool {
        
        let kingLocation = getKingLocation(color: color)
        let oppositionLocations = getLocationsOfColor( color.opposite() )
        
        for location in oppositionLocations {
            
            guard let piece = getPiece(at: location) else {
                continue
            }

            if piece.movement.canPieceMove(fromLocation: location, toLocation: kingLocation, board: self) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Print
    
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


    
    func printBoard( _ squarePrinter: (Square) -> Character? ){
        
        var printString = String()
        
        for y in  (0...7).reversed(){
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
