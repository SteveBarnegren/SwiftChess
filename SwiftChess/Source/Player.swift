//
//  Player.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 24/11/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

protocol PlayerDelegate: class {
    func playerDidMakeMove(player: Player, boardOperations: [BoardOperation])
}

open class Player {
    
    public var color: Color!
    weak var game: Game!
    weak var delegate: PlayerDelegate?
    
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

    public func canMovePieceWithError(fromLocation: BoardLocation, toLocation: BoardLocation) -> (result: Bool, error: MoveError?) {
        
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
