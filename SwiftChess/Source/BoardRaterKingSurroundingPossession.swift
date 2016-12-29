//
//  BoardRaterKingSafety.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 29/12/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

struct BoardRaterKingSurroundingPossession : BoardRater {
    
    func ratingfor(board: Board, color: Color) -> Double {
        
        let squareValue = Double(1)
        var rating = Double(0)
        
        let ownKingLocations = locationsSurroundingKing(color: color, board: board)
        let opponentKingLocations = locationsSurroundingKing(color: color.opposite(), board: board)
        
        // The kings will be able to move to their surrounding locations, so remove them from the board
        var noKingsBoard = board
        noKingsBoard.squares[noKingsBoard.getKingLocation(color: .white).index].piece = nil
        noKingsBoard.squares[noKingsBoard.getKingLocation(color: .black).index].piece = nil

        for location in ownKingLocations {
            
            if noKingsBoard.doesColorOccupyLocation(color: color, location: location) {
                rating += squareValue
                continue;
            }
            
            if noKingsBoard.doesColorOccupyLocation(color: color.opposite(), location: location) {
                rating -= squareValue
                continue
            }
            
            if  noKingsBoard.canColorMoveAnyPieceToLocation(color: color, location: location) {
                rating += squareValue
            }
            
            if noKingsBoard.canColorMoveAnyPieceToLocation(color: color.opposite(), location: location) {
                rating -= squareValue
            }

        }
        
        for location in opponentKingLocations {
            
            if noKingsBoard.doesColorOccupyLocation(color: color, location: location) {
                rating += squareValue
                continue;
            }
            
            if noKingsBoard.doesColorOccupyLocation(color: color.opposite(), location: location) {
                rating -= squareValue
                continue
            }
            
            if noKingsBoard.canColorMoveAnyPieceToLocation(color: color, location: location) {
                rating += squareValue
            }
            
            if noKingsBoard.canColorMoveAnyPieceToLocation(color: color.opposite(), location: location) {
                rating -= squareValue
            }
        }

        return rating
    }
    
    func locationsSurroundingKing(color: Color, board: Board) -> [BoardLocation] {
        
        let kingLocation = board.getKingLocation(color: color)
        
        let strides = [
            BoardStride(x: 0, y: 1), // N
            BoardStride(x: 1, y: 1), // NE
            BoardStride(x: 1, y: 0), // E
            BoardStride(x: 1, y: -1), // SE
            BoardStride(x: 0, y: -1), // S
            BoardStride(x: -1, y: -1), // SW
            BoardStride(x: -1, y: 0), // W
            BoardStride(x: -1, y: 1), // NW
        ]
        
        var surroundingLocations = [BoardLocation]()
        
        for stride in strides {
            
            if kingLocation.canIncrementBy(stride: stride) {
                let location = kingLocation.incrementedBy(stride: stride)
                surroundingLocations.append(location)
            }
        }
        
        return surroundingLocations
    }
    
}
