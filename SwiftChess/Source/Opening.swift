//
//  Opening.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 31/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

struct OpeningMove {
    let board: Board
    let fromLocation: BoardLocation
    let toLocation: BoardLocation
    
    init(board: Board, from fromLocation: BoardLocation, to toLocation: BoardLocation) {
        self.board = board
        self.fromLocation = fromLocation
        self.toLocation = toLocation
    }
}

class Opening {

    static func allOpenings() -> [Opening] {
        return [
            RuyLopez(),
            ItalianGame(),
            SicilianDefense(),
            QueensGambit(),
            KingsGambit()
        ]
    }
    
    static func allOpeningMoves(for color: Color) -> [OpeningMove] {
        
        var openingMoves = [OpeningMove]()
        
        allOpenings().forEach {
            openingMoves += $0.moves(for: color)
        }
        
        return openingMoves
    }
    
    public func moves(for color: Color) -> [OpeningMove] {
    
        var moves = [OpeningMove]()
        
        var board = Board(state: .newGame)
        for locations in moveLocations() {
            
            let move = OpeningMove(board: board,
                                   from: locations.fromLocation,
                                   to: locations.toLocation)
            moves.append(move)
            
            board.movePiece(from: locations.fromLocation, to: locations.toLocation)
            
            //move.board.printBoardPieces()
            
        }
        
        // Filter for color
        return moves.enumerated().compactMap { (index, value) in
            index % 2 == (color == .white ? 0 : 1) ? value : nil
        }
    }

    func moveLocations() -> [(fromLocation: BoardLocation, toLocation: BoardLocation)] {
        
        return moveGridPositions().map {
            (BoardLocation(gridPosition: $0), BoardLocation(gridPosition: $1))
        }
    }
    
    func moveGridPositions() -> [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        fatalError("Must override")
    }

}

// MARK: - Ruy Lopez

class RuyLopez: Opening {
    
    override func moveGridPositions() ->
        [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        
        let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
            (.e2, .e4), // white moves pawn to e4
            (.e7, .e5), // black moves pawn to e5
            (.g1, .f3), // white moves knight to f3
            (.b8, .c6), // black moves knight to c6
            (.f1, .b5)  // white moves bishop to b5
        ]
        
        return moves
    }
}

// MARK: - Italian Game

class ItalianGame: Opening {
    
    override func moveGridPositions() ->
        [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        
        let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
            (.e2, .e4), // white moves pawn to e4
            (.e7, .e5), // black moves pawn to e5
            (.g1, .f3), // white moves knight to f3
            (.b8, .c6), // black moves knight to c6
            (.f1, .c4)  // white moves bishop to c4
        ]
        
        return moves
    }
}

// MARK: - Sicilian Defense

class SicilianDefense: Opening {
    
    override func moveGridPositions() ->
        [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        
        let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
            (.e2, .e4), // white moves pawn to e4
            (.c7, .c5)  // black moves pawn to c5
        ]
        
        return moves
    }
}

// MARK: - Queens Gambit

class QueensGambit: Opening {
    
    override func moveGridPositions() ->
        [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        
        let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
            (.d2, .d4), // white moves pawn to d4
            (.d7, .d5), // black moves pawn to d5
            (.c2, .c4)  // white moves pawn to c4
        ]
        
        return moves
    }
}

// MARK: - King's Gambit

class KingsGambit: Opening {
    
    override func moveGridPositions() ->
        [(fromPosition: BoardLocation.GridPosition, toPosition: BoardLocation.GridPosition)] {
        
        let moves: [(BoardLocation.GridPosition, BoardLocation.GridPosition)] = [
            (.e2, .e4), // white moves pawn to e4
            (.e7, .e5), // black moves pawn to e5
            (.f2, .f4)  // white moves pawn to f4
        ]
        
        return moves
    }
}
