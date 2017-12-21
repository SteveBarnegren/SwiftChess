//
//  BoardRaterKingSafety.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 29/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

class BoardRaterKingSurroundingPossession: BoardRater {
    
    override func ratingFor(board: Board, color: Color) -> Double {
        
        let squareValue = Double(1)
        var rating = Double(0)
        
        let ownKingLocations = locationsSurroundingKing(color: color, board: board)
        let opponentKingLocations = locationsSurroundingKing(color: color.opposite, board: board)
        
        // The kings will be able to move to their surrounding locations, so remove them from the board
        var noKingsBoard = board
        noKingsBoard.removePiece(at: noKingsBoard.getKingLocation(color: .white))
        noKingsBoard.removePiece(at: noKingsBoard.getKingLocation(color: .black))

        // we don't want to encourage the king to move out in to the open
        rating += Double(8 - ownKingLocations.count) * squareValue * 3

        for location in ownKingLocations {
            
            if noKingsBoard.doesColorOccupyLocation(color: color, location: location) {
                rating += squareValue
                continue
            }
            
            if noKingsBoard.doesColorOccupyLocation(color: color.opposite, location: location) {
                rating -= squareValue
                continue
            }
            
            if  noKingsBoard.canColorMoveAnyPieceToLocation(color: color, location: location) {
                rating += squareValue
            } else if noKingsBoard.canColorMoveAnyPieceToLocation(color: color.opposite, location: location) {
                rating -= squareValue
            }

        }
        
        for location in opponentKingLocations {
            
            if noKingsBoard.doesColorOccupyLocation(color: color, location: location) {
                rating += squareValue
                continue
            }
            
            if noKingsBoard.doesColorOccupyLocation(color: color.opposite, location: location) {
                rating -= squareValue
                continue
            }
            
            if noKingsBoard.canColorMoveAnyPieceToLocation(color: color, location: location) {
                rating += squareValue
            } else if noKingsBoard.canColorMoveAnyPieceToLocation(color: color.opposite, location: location) {
                rating -= squareValue
            }
        }

        return rating * configuration.boardRaterKingSurroundingPossessionWeighting.value
    }
    
    func locationsSurroundingKing(color: Color, board: Board) -> [BoardLocation] {
        
        let kingLocation = board.getKingLocation(color: color)
        
        let strides = [
            BoardStride(x: 0, y: 1),   // N
            BoardStride(x: 1, y: 1),   // NE
            BoardStride(x: 1, y: 0),   // E
            BoardStride(x: 1, y: -1),  // SE
            BoardStride(x: 0, y: -1),  // S
            BoardStride(x: -1, y: -1), // SW
            BoardStride(x: -1, y: 0),  // W
            BoardStride(x: -1, y: 1)   // NW
        ]
        
        var surroundingLocations = [BoardLocation]()
        
        for stride in strides {
            
            if kingLocation.canIncrement(by: stride) {
                let location = kingLocation.incremented(by: stride)
                surroundingLocations.append(location)
            }
        }
        
        return surroundingLocations
    }
    
}
