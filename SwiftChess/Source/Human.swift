//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

//swiftlint:disable line_length

import Foundation

public final class Human: Player {
   
    public init(color: Color) {
        super.init()
        self.color = color
    }
    
    // MARK: - Public
    
    public func movePiece(from fromLocation: BoardLocation, to toLocation: BoardLocation) throws {
        
        // Check that the game is in progress
        guard game.state == .inProgress else {
            throw MoveError.gameIsNotInProgress
        }
        
        // Check that we're the current player
        guard game.currentPlayer === self else {
            throw MoveError.notThisPlayersTurn
        }
        
        // Check if move is allowed
        do {
            _ = try canMovePiece(from: fromLocation, to: toLocation)
        } catch let error {
            throw error
        }
        
        // Move the piece
        var operations = game.board.movePiece(from: fromLocation, to: toLocation)
        
        // Make pawn promotions
        let promotablePawnLocations = game.board.getLocationsOfPromotablePawns(color: color)
        assert(promotablePawnLocations.count < 2, "There should only be one pawn available for promotion at a time")
        if promotablePawnLocations.count > 0 {
            
            let pawnLocation = promotablePawnLocations.first!
            
            self.game.delegate?.promotedTypeForPawn(location: pawnLocation,
                                                    player: self,
                                                    possiblePromotions: Piece.PieceType.possiblePawnPromotionResultingTypes(),
                                                    callback: {
                                                        
                                                        // Change the piece
                                                        let newPiece = self.game.board.squares[pawnLocation.index].piece?.byChangingType(newType: $0)
                                                        self.game.board.setPiece(newPiece!, at: pawnLocation)
                                                        
                                                        // Add a transform piece operation
                                                        let modifyOperation = BoardOperation(type: .transformPiece, piece: newPiece!, location: pawnLocation)
                                                        operations.append(modifyOperation)
                                                        
                                                        // Inform the delegate that we've finished
                                                        self.delegate?.playerDidMakeMove(player: self, boardOperations: operations)
            })
        }
        // ... Or if no pawn promotions, end move
        else {
            // Inform the delegate that we made a move
            delegate?.playerDidMakeMove(player: self, boardOperations: operations)

        }
        
    }
    
    public func performCastleMove(side: CastleSide) {

        // Check that we're the current player
        guard game.currentPlayer === self else {
            return
        }
        
        // Check that the castling move can be performed
        if game.board.canColorCastle(color: color, side: side) == false {
            return
        }
        
        // Make the move
        let operations = game.board.performCastle(color: color, side: side)
        
        // Inform the delegate that we made a move
        delegate?.playerDidMakeMove(player: self, boardOperations: operations)
    }
    
}

extension Human: Equatable {
    public static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.color == rhs.color
    }
}

extension Human: DictionaryRepresentable {
    
    struct Keys {
        static let color = "color"
    }
    
    convenience init?(dictionary: [String: Any]) {

        if let raw = dictionary[Keys.color] as? String, let color = Color(rawValue: raw) {
            self.init(color: color)
        } else {
            return nil
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary[Keys.color] = color.rawValue
        return dictionary
    }
}
