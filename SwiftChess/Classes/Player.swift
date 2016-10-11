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
    
    init(color: Color, game: Game){
        self.color = color
        self.game = game;
    }
    
    // MARK: - Public
    
    public func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation) {
        
        // Check if move is allowed
        let canMove = canMovePieceWithError(fromLocation: fromLocation, toLocation: toLocation)
        
        if let error = canMove.error {
            error.printDescription()
            print("To avoid seeing these errors, call canMovePiece(fromLocation:toLocation) first")
            return
        }
        
        // Move the piece
        game.board.movePiece(fromLocation: fromLocation, toLocation: toLocation)
    }
    
    public func canMovePiece(fromLocation: BoardLocation, toLocation: BoardLocation) -> Bool {
        return canMovePieceWithError(fromLocation: fromLocation, toLocation: toLocation).result
    }

    // MARK: - Private
    
    enum PieceMoveError : Error {
        case movingToSameLocation(description: String)
        case noPieceToMove(description: String)
        case pieceColorDoesNotMatchPlayerColor(description: String)
        case pieceUnableToMoveToLocation(description: String)
        
        func printDescription() {
            
            switch self {
            case .movingToSameLocation(let description):
                print(description)
            case .noPieceToMove(let description):
                print(description)
            case .pieceColorDoesNotMatchPlayerColor(let description):
                print(description)
            case .pieceUnableToMoveToLocation(let description):
                print(description)
            }
        }
    }
    
    private func canMovePieceWithError(fromLocation: BoardLocation, toLocation: BoardLocation) -> (result: Bool, error: PieceMoveError?) {
        
        // We can't move to our current location
        if fromLocation == toLocation {
            return (false, .movingToSameLocation(description: "Cannot move piece to its current location"))
        }
        
        // Get the piece
        guard let piece = self.game.board.getPiece(at: fromLocation) else {
            return (false, .noPieceToMove(description: "There isn't a piece of color \(color) at \(fromLocation)"))
        }
        
        // Check that the piece color matches the player color
        if piece.color != self.color {
            return (false, .pieceColorDoesNotMatchPlayerColor(description: "Player color \(color) cannot move piece of color \(piece.color)"))
        }
        
        // Make sure the piece can move to the location
        if !piece.movement.canPieceMove(fromLocation: fromLocation, toLocation: toLocation, board: game.board) {
            return (false, .pieceUnableToMoveToLocation(description: "Piece at \(fromLocation) cannot move to \(toLocation)"))
        }

        return (true, nil)
    }

}

