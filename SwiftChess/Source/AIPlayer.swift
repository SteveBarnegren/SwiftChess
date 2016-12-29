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
        
        self.boardRaters = [
            BoardRaterCountPieces(),
            BoardRaterCenterOwnership(),
            BoardRaterBoardDominance(),
            BoardRaterCenterDominance(),
            BoardRaterThreatenedPieces(),
            BoardRaterPawnProgression(),
        ]
        
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
                
                // Make move
                var resultBoard = board
                resultBoard.movePiece(fromLocation: sourceLocation, toLocation: targetLocation)
                
                // Promote pawns
                let pawnsToPromoteLocations = resultBoard.getLocationsOfPromotablePawns(color: color)
                assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
                if pawnsToPromoteLocations.count > 0 {
                    resultBoard = promotePawnsOnBoard(resultBoard)
                }
                
                // Rate
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
        var operations = game.board.movePiece(fromLocation: highestRatedMove.sourceLocation, toLocation: highestRatedMove.targetLocation)
        
        // Promote pawns
        let pawnsToPromoteLocations = game.board.getLocationsOfPromotablePawns(color: color)
        assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
        if pawnsToPromoteLocations.count > 0 {
            game.board = promotePawnsOnBoard(game.board)
            
            let location = pawnsToPromoteLocations.first!
            let transformOperation = BoardOperation(type: .transformPiece, piece: game.board.getPiece(at: location)!, location: location)
            operations.append(transformOperation)
        }
        
        self.game.playerDidMakeMove(player: self, boardOperations: operations)
    }
    
    func ratingForBoard(_ board: Board) -> Double {
        
        var rating: Double = 0;
        
        for boardRater in boardRaters {
            rating += boardRater.ratingfor(board: board, color: color)
        }
        
        return rating
    }
    
 
    func promotePawnsOnBoard(_ board: Board) -> Board {
        
        let pawnsToPromoteLocations = board.getLocationsOfPromotablePawns(color: color)

        guard pawnsToPromoteLocations.count > 0 else {
            return board
        }
        
        assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
        
        let location = pawnsToPromoteLocations.first!
        
        guard let piece = board.getPiece(at: location) else {
            return board
        }
        
        // Get the ratings
        var bestType = Piece.PieceType.possiblePawnPromotionResultingTypes().first
        var bestRating = -Double.greatestFiniteMagnitude
        var promotedBoard: Board!
        
        
        for pieceType in Piece.PieceType.possiblePawnPromotionResultingTypes() {
            
            var newBoard = board
            
            guard let piece = newBoard.getPiece(at: location) else {
                return board
            }
            
            let newPiece = newBoard.getPiece(at: location)?.byChangingType(newType: pieceType)
            newBoard.squares[location.index].piece = newPiece
            
            let rating = ratingForBoard(newBoard)
            
            if rating > bestRating {
                bestRating = rating
                bestType = pieceType
                promotedBoard = newBoard
            }
            
        }
        
        return promotedBoard
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
 


