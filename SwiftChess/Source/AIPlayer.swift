//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//


import Foundation

open class AIPlayer : Player {
    
    let boardRaters : [BoardRater]!
   
    public init(color: Color){
        
        self.boardRaters = [BoardRaterCountPieces(), BoardRaterCenterOwnership(), BoardRaterBoardDominance(), BoardRaterCenterDominance()]
        
        super.init()
        self.color = color
    }
    
    public func makeMove() {
        
        let board = game.board
        
        // Build list of possible moves with ratings
        
        var possibleMoves = [Move]()
        
        for sourceLocation in BoardLocation.all {
            
            guard let piece = board.getPiece(at: sourceLocation) else {
                continue
            }
            
            if piece.color != color {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                guard canMovePiece(fromLocation: sourceLocation, toLocation: targetLocation) else {
                    continue
                }
                
                var resultBoard = board
                resultBoard.movePiece(fromLocation: sourceLocation, toLocation: targetLocation)
                let rating = ratingForBoard(resultBoard)
                let move = Move(sourceLocation: sourceLocation, targetLocation: targetLocation, rating: rating)
                possibleMoves.append(move)
            }
        }
        
        print("Found \(possibleMoves.count) possible moves")
        
        // If there are no possible moves, we must be in stale mate
        if possibleMoves.count == 0 {
            print("There are no possible moves!!!!");
        }
    
        // Choose move with highest rating
        var highestRating = possibleMoves.first!.rating
        var highestRatedMove = possibleMoves.first!
        
        for move in possibleMoves {
            
            if move.rating > highestRating {
                highestRating = move.rating
                highestRatedMove = move;
            }
            
            print("rating: \(move.rating)")
        }
        
        print("HIGHEST MOVE RATING: \(highestRating)")
        
        // Make move
        let operations = game.board.movePiece(fromLocation: highestRatedMove.sourceLocation, toLocation: highestRatedMove.targetLocation)
        self.game.playerDidMakeMove(player: self, boardOperations: operations)
    }
    
    func ratingForBoard(_ board: Board) -> Double {
        
        var rating: Double = 0;
        
        for boardRater in boardRaters {
            rating += boardRater.ratingfor(board: board, color: color)
        }
        
        return rating
    }
    
    
}

struct Move {
    let sourceLocation: BoardLocation
    let targetLocation: BoardLocation
    let rating: Double
}

// MARK - BoardRater

internal protocol BoardRater {
    func ratingfor(board: Board, color: Color) -> Double;
}

extension BoardRater {
    func ratingfor(board: Board, color: Color) -> Double {
        return 0;
    }
}
 


