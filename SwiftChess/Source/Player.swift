//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

open class Player {
   
    let color: Color!
    weak var game: Game!
    weak var delegate: PlayerDelegate?
    
    init(color: Color, game: Game){
        self.color = color
        self.game = game;
    }
    
    // MARK: - Public
    
    public func occupiesSquareAt(location: BoardLocation) -> Bool{
        
        if let piece = self.game.board.getPiece(at: location){
            if piece.color == self.color {
                return true
            }
        }
        
        return false
    }
    
    public func canMovePiece(fromLocation: BoardLocation, toLocation: BoardLocation) -> Bool {
        return canMovePieceWithError(fromLocation: fromLocation, toLocation: toLocation).result
    }
    
    public enum MoveError : Error {
        case notThisPlayersTurn
        case movingToSameLocation
        case noPieceToMove
        case pieceColorDoesNotMatchPlayerColor
        case pieceUnableToMoveToLocation
        case playerMustMoveOutOfCheck
        case cannotMoveInToCheck
    }
    
    public func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation) throws {
        
        // Check that we're the current player
        guard game.currentPlayer === self else {
            throw MoveError.notThisPlayersTurn
        }
        
        // Check if move is allowed
        let canMove = canMovePieceWithError(fromLocation: fromLocation, toLocation: toLocation)
        if let error = canMove.error {
            throw error
        }
        
        // Move the piece
        game.board.movePiece(fromLocation: fromLocation, toLocation: toLocation)
        
        // Inform the delegate that we made a move
        delegate?.playerDidMakeMove(player: self)
    }
    
   
    // MARK: - Private
    private func canMovePieceWithError(fromLocation: BoardLocation, toLocation: BoardLocation) -> (result: Bool, error: MoveError?) {
        
        // We can't move to our current location
        if fromLocation == toLocation {
            return (false, .movingToSameLocation)
        }
        
        // Get the piece
        guard let piece = self.game.board.getPiece(at: fromLocation) else {
            return (false, .noPieceToMove)
        }
        
        // Check that the piece color matches the player color
        if piece.color != self.color {
            return (false, .pieceColorDoesNotMatchPlayerColor)
        }
        
        // Make sure the piece can move to the location
        if !piece.movement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: game.board) {
            return (false, .pieceUnableToMoveToLocation)
        }
        
        // Make sure we are not leaving the board state in check
        let inCheckBeforeMove = self.game.board.isColorInCheck(color: self.color)
        
        var board = self.game.board
        board.movePiece(fromLocation: fromLocation, toLocation: toLocation)
        let inCheckAfterMove = board.isColorInCheck(color: self.color)
        
        if inCheckBeforeMove && inCheckAfterMove {
            return (false, .playerMustMoveOutOfCheck)
        }
        
        if !inCheckBeforeMove && inCheckAfterMove {
            return (false, .cannotMoveInToCheck)
        }
        
        return (true, nil)
    }

}

protocol PlayerDelegate: class {
    func playerDidMakeMove(player: Player)
}

