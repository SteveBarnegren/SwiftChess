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

    public init(firstPlayer: Player, secondPlayer: Player){
        
        // Assign to correct colors
        if firstPlayer.color == secondPlayer.color {
            fatalError("Both players cannot have the same color")
        }
        
        self.whitePlayer = firstPlayer.color == .white ? firstPlayer : secondPlayer
        self.blackPlayer = firstPlayer.color == .black ? firstPlayer : secondPlayer
        
        // Setup Players
        self.whitePlayer.delegate = self
        self.blackPlayer.delegate = self
        self.whitePlayer.game = self
        self.blackPlayer.game = self
        self.currentPlayer = self.whitePlayer
    }
}

extension Game : PlayerDelegate {

    func playerDidMakeMove(player: Player, boardOperations: [BoardOperation]) {
        
        // This shouldn't happen, but we'll print a message in case it does
        if player !== currentPlayer {
            print("Warning - Wrong player took turn")
        }
        
        // Process board operations
        processBoardOperations(boardOperations: boardOperations)
        
        // Check for game ended
        if board.isColorInCheckMate(color: currentPlayer.color.opposite()) {
            delegate?.gameWonByPlayer(game: self, player: currentPlayer)
            return
        }
        
        // Check for stalemate
        if board.isColorInStalemate(color: currentPlayer.color.opposite()) {
            delegate?.gameEndedInStaleMate(game: self)
            return
        }
        
        // Switch to the other player
        if player === whitePlayer {
            currentPlayer = blackPlayer
        }
        else{
            currentPlayer = whitePlayer
        }
        
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
    func gameWonByPlayer(game: Game, player: Player)
    func gameEndedInStaleMate(game: Game)
    
    func gameWillBeginUpdates(game: Game) // Updates will begin
    func gameDidAddPiece(game: Game) // A new piece was added to the board (do we actually need to include this functionality?)
    func gameDidRemovePiece(game: Game, piece: Piece, location: BoardLocation) // A piece was removed from the board
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) // A piece was moved on the board
    func gameDidTransformPiece(game: Game) // A piece was transformed (eg. pawn was promoted to another piece)
    func gameDidEndUpdates(game: Game) // Updates will end
}
