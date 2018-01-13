//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

// swiftlint:disable for_where
import Foundation

public final class AIPlayer: Player {
    
    let boardRaters: [BoardRater]!
    public let configuration: AIConfiguration!
    var openingMoves = [OpeningMove]()
    
    public init(color: Color, configuration: AIConfiguration) {
        
        self.configuration = configuration
        
        self.boardRaters = [
            BoardRaterCountPieces(configuration: configuration),
            BoardRaterCenterOwnership(configuration: configuration),
            BoardRaterBoardDominance(configuration: configuration),
            BoardRaterCenterDominance(configuration: configuration),
            BoardRaterThreatenedPieces(configuration: configuration),
            BoardRaterPawnProgression(configuration: configuration),
            BoardRaterKingSurroundingPossession(configuration: configuration),
            BoardRaterCheckMateOpportunity(configuration: configuration),
            BoardRaterCenterFourOccupation(configuration: configuration)
        ]
        
        openingMoves = Opening.allOpeningMoves(for: color)
        
        super.init()
        self.color = color
    }
    
    public func makeMoveAsync() {
        
        DispatchQueue.global(qos: .background).async {
            self.makeMoveSync()
        }
    }
    
    public func makeMoveSync() {
        
        //print("\n\n****** Make Move ******");
        
        // Check that the game is in progress
        guard game.state == .inProgress else {
            return
        }
        
        let board = game.board
                
        var move: Move!
        
        // Get an opening move
        if let openingMove = openingMove(for: board) {
            //print("Playing opening move")
            move = openingMove
        }
        // Or, get the Highest rated move
        else {
            move = highestRatedMove(on: board)
        }
        
        // Make move
        var operations = [BoardOperation]()
        
        switch move.type {
        case .singlePiece(let sourceLocation, let targetLocation):
            operations = game.board.movePiece(from: sourceLocation, to: targetLocation)
        case .castle(let color, let side):
            operations = game.board.performCastle(color: color, side: side)
        }
        
        // Promote pawns
        let pawnsToPromoteLocations = game.board.getLocationsOfPromotablePawns(color: color)
        assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
        if pawnsToPromoteLocations.count > 0 {
            game.board = promotePawns(on: game.board)
            
            let location = pawnsToPromoteLocations.first!
            let transformOperation = BoardOperation(type: .transformPiece,
                                                    piece: game.board.getPiece(at: location)!,
                                                    location: location)
            operations.append(transformOperation)
        }
        
        let strongGame = self.game!
        DispatchQueue.main.async {
            strongGame.playerDidMakeMove(player: self, boardOperations: operations)
        }
    }
    
    func openingMove(for board: Board) -> Move? {
        
        let possibleMoves = openingMoves.filter {
            $0.board == board
        }
        
        guard possibleMoves.count > 0 else {
            return nil
        }
        
        let index = Int(arc4random_uniform(UInt32(possibleMoves.count)))
        let openingMove = possibleMoves[index]
        
        return Move(type: .singlePiece(from: openingMove.fromLocation,
                                       to: openingMove.toLocation),
                                       rating: 0)
    }
    
    func highestRatedMove(on board: Board) -> Move {
        
        var possibleMoves = [Move]()
        
        for sourceLocation in BoardLocation.all {
            
            guard let piece = board.getPiece(at: sourceLocation) else {
                continue
            }
            
            if piece.color != color {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                guard canAIMovePiece(from: sourceLocation, to: targetLocation) else {
                    continue
                }
                
                // Make move
                var resultBoard = board
                resultBoard.movePiece(from: sourceLocation, to: targetLocation)
                
                // Promote pawns
                let pawnsToPromoteLocations = resultBoard.getLocationsOfPromotablePawns(color: color)
                assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
                if pawnsToPromoteLocations.count > 0 {
                    resultBoard = promotePawns(on: resultBoard)
                }
                
                // Rate
                var rating = ratingForBoard(resultBoard)
                
                // reduce rating if suicide
                if resultBoard.canColorMoveAnyPieceToLocation(color: color.opposite, location: targetLocation) {
                    rating -= (abs(rating) * configuration.suicideMultipler.value)
                }
                
                let move = Move(type: .singlePiece(from: sourceLocation, to: targetLocation),
                                rating: rating)
                possibleMoves.append(move)
               // print("Rating: \(rating)")
            }
        }
        
        // Add castling moves
        let castleSides: [CastleSide] = [.kingSide, .queenSide]
        for side in castleSides {
            
            guard game.board.canColorCastle(color: color, side: side) else {
                continue
            }
            
            // Perform the castling move
            var resultBoard = board
            resultBoard.performCastle(color: color, side: side)
            
            // Rate
            let rating = ratingForBoard(resultBoard)
            let move = Move(type: .castle(color: color, side: side), rating: rating)
            possibleMoves.append(move)
        }
        
        //print("Found \(possibleMoves.count) possible moves")
        
        // If there are no possible moves, we must be in stale mate
        if possibleMoves.count == 0 {
            print("There are no possible moves!!!!")
        }
        
        // Choose move with highest rating
        var highestRating = possibleMoves.first!.rating
        var highestRatedMove = possibleMoves.first!
        
        for move in possibleMoves {
            
            if move.rating > highestRating {
                highestRating = move.rating
                highestRatedMove = move
            }
            
            //print("rating: \(move.rating)")
        }
        
        return highestRatedMove
    }
    
    func canAIMovePiece(from fromLocation: BoardLocation, to toLocation: BoardLocation) -> Bool {
        
        // This is a stricter version of the canMove function, used by the AI, that returns false for errors
        
        do {
            return try canMovePiece(from: fromLocation, to: toLocation)
        } catch {
            return false
        }
    }

    func ratingForBoard(_ board: Board) -> Double {
        
        var rating: Double = 0
        
        for boardRater in boardRaters {
            
            let result = boardRater.ratingFor(board: board, color: color)
            
            //let className = "\(boardRater)"
            //print("\t\(className): \(result)")
            rating += result
        }
        
        // If opponent is in check mate, set the maximum rating
        if board.isColorInCheckMate(color: color.opposite) {
            rating = Double.greatestFiniteMagnitude
        }
        
        return rating
    }
    
    func promotePawns(on board: Board) -> Board {
        
        let pawnsToPromoteLocations = board.getLocationsOfPromotablePawns(color: color)

        guard pawnsToPromoteLocations.count > 0 else {
            return board
        }
        
        assert(pawnsToPromoteLocations.count < 2, "There should only ever be one pawn to promote at any time")
        
        let location = pawnsToPromoteLocations.first!
        
        guard board.getPiece(at: location) != nil else {
            return board
        }
        
        // Get the ratings
        var highestRating = -Double.greatestFiniteMagnitude
        var promotedBoard: Board!
        
        for pieceType in Piece.PieceType.possiblePawnPromotionResultingTypes() {
            
            var newBoard = board
            
            guard newBoard.getPiece(at: location) != nil else {
                return board
            }
            
            let newPiece = newBoard.getPiece(at: location)?.byChangingType(newType: pieceType)
            newBoard.setPiece(newPiece!, at: location)

            let rating = ratingForBoard(newBoard)
            
            if rating > highestRating {
                highestRating = rating
                promotedBoard = newBoard
            }
            
        }
        
        return promotedBoard
    }
}

extension AIPlayer: Equatable {
    public static func == (lhs: AIPlayer, rhs: AIPlayer) -> Bool {
        return lhs.color == rhs.color && lhs.configuration == rhs.configuration
    }
}

extension AIPlayer: DictionaryRepresentable {
    
    struct Keys {
        static let color = "color"
        static let configuration = "configuration"
    }
    
    convenience init?(dictionary: [String: Any]) {
        
        guard
            let colorRaw = dictionary[Keys.color] as? String,
            let color = Color(rawValue: colorRaw),
            let configurationDict = dictionary[Keys.configuration] as? [String: Any],
            let configuration = AIConfiguration(dictionary: configurationDict) else {
                return nil
        }
        
        self.init(color: color, configuration: configuration)
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary[Keys.color] = color.rawValue
        dictionary[Keys.configuration] = configuration.dictionaryRepresentation
        return dictionary
    }
}

struct Move {
    
    enum MoveType {
        case singlePiece(from: BoardLocation, to: BoardLocation)
        case castle(color: Color, side: CastleSide)
    }
    
    let type: MoveType
    let rating: Double
}

// MARK: - BoardRater

internal class BoardRater {
    
    let configuration: AIConfiguration
    
    init(configuration: AIConfiguration) {
        self.configuration = configuration
    }

    func ratingFor(board: Board, color: Color) -> Double {
        fatalError("Override ratingFor method in subclasses")
    }
}
