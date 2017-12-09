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
    
    public func occupiesSquare(at location: BoardLocation) -> Bool {
        
        if let piece = self.game.board.getPiece(at: location) {
            if piece.color == self.color {
                return true
            }
        }
        
        return false
    }
    
    public enum MoveError: Int, Error, Equatable {
        case notThisPlayersTurn
        case movingToSameLocation
        case noPieceToMove
        case pieceColorDoesNotMatchPlayerColor
        case pieceUnableToMoveToLocation
        case playerMustMoveOutOfCheck
        case cannotMoveInToCheck
        case gameIsNotInProgress
        
        public static func == (lhs: MoveError, rhs: MoveError) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
    }

    func canMovePiece(from fromLocation: BoardLocation, to toLocation: BoardLocation) throws -> Bool {
        
        // We can't move to our current location
        if fromLocation == toLocation {
            throw MoveError.movingToSameLocation
        }
        
        // Get the piece
        guard let piece = self.game.board.getPiece(at: fromLocation) else {
            throw MoveError.noPieceToMove
        }
        
        // Check that the piece color matches the player color
        if piece.color != self.color {
            throw MoveError.pieceColorDoesNotMatchPlayerColor
        }
        
        // Make sure the piece can move to the location
        if !piece.movement.canPieceMove(from: fromLocation, to: toLocation, board: game.board) {
            throw MoveError.pieceUnableToMoveToLocation
        }
        
        // Move the piece
        let inCheckBeforeMove = self.game.board.isColorInCheck(color: self.color)
        var board = self.game.board
        board.movePiece(from: fromLocation, to: toLocation)
        let inCheckAfterMove = board.isColorInCheck(color: self.color)
        
        // Return
        if inCheckBeforeMove && inCheckAfterMove {
            throw MoveError.playerMustMoveOutOfCheck
        }
        
        if !inCheckBeforeMove && inCheckAfterMove {
            throw MoveError.cannotMoveInToCheck
        }
        
        return true
    }
}
