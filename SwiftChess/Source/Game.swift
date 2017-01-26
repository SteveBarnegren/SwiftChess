//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Game {
    
    // MARK: Types
    public enum State: Equatable {
        case inProgress
        case staleMate(color: Color)
        case won(color: Color)
        
        public static func ==(lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.inProgress, .inProgress):
                return true
            case (let .staleMate(color1), let staleMate(color2)):
                return color1 == color2
            case (let .won(color1), let won(color2)):
                return color1 == color2
            default:
                return false
            }
        }
    }

    // MARK: Properties
    open var board = Board(state: .newGame)
    open var whitePlayer: Player!
    open var blackPlayer: Player!
    open var currentPlayer: Player!
    open var state = Game.State.inProgress
    open weak var delegate: GameDelegate?
    
    // MARK: Init
    public init(firstPlayer: Player, secondPlayer: Player, board: Board = Board(state: .newGame), colorToMove: Color = .white){
        
        self.board = board
        
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
        self.currentPlayer = (colorToMove == .white ? self.whitePlayer : self.blackPlayer)
    }
    
    
}

// MARK: - Game : PlayerDelegate
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
            state = .won(color: currentPlayer.color)
            delegate?.gameWonByPlayer(game: self, player: currentPlayer)
            return
        }
        
        // Check for stalemate
        if board.isColorInStalemate(color: currentPlayer.color.opposite()) {
            state = .staleMate(color: currentPlayer.color.opposite())
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
                self.delegate?.gameDidTransformPiece(game: self, piece: boardOperation.piece, location: boardOperation.location)
            }
            
        }
   
    }
    
}

// MARK: - GameDelegate
public protocol GameDelegate: class {
    
    // State changes
    func gameDidChangeCurrentPlayer(game: Game)
    func gameWonByPlayer(game: Game, player: Player)
    func gameEndedInStaleMate(game: Game)
    
    // Piece adding / removing / modifying
    func gameWillBeginUpdates(game: Game) // Updates will begin
    func gameDidAddPiece(game: Game) // A new piece was added to the board (do we actually need to include this functionality?)
    func gameDidRemovePiece(game: Game, piece: Piece, location: BoardLocation) // A piece was removed from the board
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation) // A piece was moved on the board
    func gameDidTransformPiece(game: Game, piece: Piece, location: BoardLocation) // A piece was transformed (eg. pawn was promoted to another piece)
    func gameDidEndUpdates(game: Game) // Updates will end
    
    // Callbacks from player
    func promotedTypeForPawn(location: BoardLocation, player: Human, possiblePromotions: [Piece.PieceType], callback: @escaping (Piece.PieceType) -> Void )
}
