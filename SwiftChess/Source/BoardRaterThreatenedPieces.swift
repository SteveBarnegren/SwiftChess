//
//  BoardRaterThreatenedPieces.swift
//  SwiftChess
//
//  Created by Steven Barnegren on 14/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterThreatenedPieces : BoardRater {
    
    override func ratingfor(board: Board, color: Color) -> Double {
        
        var rating = Double(0)
     
        for location in BoardLocation.all {
            
            guard let piece = board.getPiece(at: location) else {
                continue;
            }
            
            let threatRating = threatRatingForPiece(at: location, board: board, color: color)
            
            // For a same color, subtract the threat rating (less preferrable move)
            if piece.color == color {
                rating -= threatRating
            }
            // For opposite color, add the treat rating (more preferable move)
            else{
                rating += threatRating
            }
            
            rating += (piece.color == color) ? -threatRating : threatRating;
        }
        
        return rating * configuration.boardRaterThreatenedPiecesWeighting
    }
    
    
    // Returns a more positive rating the more the piece is threatened
    func threatRatingForPiece(at location: BoardLocation, board: Board, color: Color) -> Double {
        
        guard let piece = board.getPiece(at: location) else{
            fatalError()
        }
        
        var rating = Double(0)
        
        let threateningPieceLocations = threateningPiecesLocationsforPiece(at: location, on: board)
        let isBeingThreatened = threateningPieceLocations.isEmpty ? false : true

        let protectingPieceLocations = protectingPiecesLocationsforPiece(at: location, on: board)
        let isBeingProtected = protectingPieceLocations.isEmpty ? false : true
        
        for threateningPieceLocation in threateningPieceLocations {
            
            guard let threateningPiece = board.getPiece(at: threateningPieceLocation) else {
                continue
            }
            
            let pieceIsProtected = (isBeingProtected && piece.value() < threateningPiece.value())
            
            if !pieceIsProtected {
                rating += piece.color == color ? piece.value() * configuration.boardRaterThreatenedPiecesOwnPiecesMultiplier : piece.value()
            }
        }
        
        return rating
    }
    
    // MARK - Get protecting / Threatening pieces
    
    func protectingPiecesLocationsforPiece(at location: BoardLocation, on board: Board) -> [BoardLocation] {
        
        var newBoard = board
        
        guard let protectedPiece = board.getPiece(at: location) else {
            fatalError("Expected board location to contain piece")
        }
        
        // Change the piece color to be opposite, to simulate if the piece was taken
        let oppositeColorPiece = Piece(type: protectedPiece.type, color: protectedPiece.color.opposite())
        newBoard.setPiece(oppositeColorPiece, at: location)
        
        var pieces = [BoardLocation]()
        
        for sourceLocation in BoardLocation.all {
            
            guard let protectingPiece = newBoard.getPiece(at: sourceLocation) else{
                continue
            }
            
            guard protectingPiece.color == protectedPiece.color else{
                continue
            }
            
            if protectingPiece.movement.canPieceMove(fromLocation: sourceLocation, toLocation: location, board: newBoard) {
                pieces.append(sourceLocation)
            }
        }
        
        return pieces
    }
    
    func threateningPiecesLocationsforPiece(at location: BoardLocation, on board: Board) -> [BoardLocation] {
        
        guard let threatenedPiece = board.getPiece(at: location) else {
            fatalError("Expected board location to contain piece")
        }
        
        let threatenedColor = threatenedPiece.color
        
        var pieces = [BoardLocation]()
        
        for sourceLocation in BoardLocation.all {
            
            guard let threateningPiece = board.getPiece(at: sourceLocation) else{
                continue
            }
            
            guard threateningPiece.color == threatenedColor.opposite() else{
                continue
            }
            
            if threateningPiece.movement.canPieceMove(fromLocation: sourceLocation, toLocation: location, board: board) {
                pieces.append(sourceLocation)
            }
        }
        
        return pieces
    }
    
}
