//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Game {
    
    open var board = Board(state: .newGame)
    
    open var whitePlayer: Player!
    open var blackPlayer: Player!
    open var currentPlayer: Player!
    
    open weak var delegate: GameDelegate?

    public init(){
        
        // Setup Players
        self.whitePlayer = Human(color: .white, game: self)
        self.whitePlayer.delegate = self
        self.blackPlayer = AIPlayer(color: .black, game: self)
        self.blackPlayer.delegate = self
        self.currentPlayer = self.whitePlayer
    }

    
}

extension Game : PlayerDelegate {

    func playerDidMakeMove(player: Player, boardOperations: [BoardOperation]) {
        
        // This shouldn't happen, but we'll print a message in case it does
        if player !== currentPlayer {
            print("Warning - Wrong player took turn")
        }
        
        // Switch to the other player
        if player === whitePlayer {
            currentPlayer = blackPlayer
        }
        else{
            currentPlayer = whitePlayer
        }
        
        // Process board operations
        processBoardOperations(boardOperations: boardOperations)
        
        // Inform the delegate
        self.delegate?.gameDidChangeCurrentPlayer(game: self)
    }
    
    func processBoardOperations(boardOperations: [BoardOperation]) {
        
        for boardOperation in boardOperations {
            
            switch boardOperation.type! {
            case .movePiece:
                self.delegate?.gameDidMovePiece(game: self, piece: boardOperation.piece, toLocation: boardOperation.location)
            case .removePiece:
                self.delegate?.gameDidRemovePiece(game: self, piece: boardOperation.piece, location: boardOperation.location)
            case .transformPiece:
                fatalError()
                //self.delegate?.gameDidMovePiece(game: self, piece: boardOperation.piece, toLocation: boardOperation.location)
            }
            
        }
        
        
        
        
    }
    
    

}

public protocol GameDelegate: class {
    func gameDidChangeCurrentPlayer(game: Game)
    
    func gameWillBeginUpdates(game: Game) // Updates will begin
    func gameDidAddPiece(game: Game) // A new piece was added to the board (do we catually need to include this functionality?)
    func gameDidRemovePiece(game: Game, piece: Piece, location: BoardLocation) // A piece was removed from the board
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) // A piece was moved on the board
    func gameDidTransformPiece(game: Game) // A piece was transformed (eg. pawn was promoted to another piece)
    func gameDidEndUpdates(game: Game) // Updates will end
}
