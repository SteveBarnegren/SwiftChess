//
//  Swiftchess.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public final class Game {
    
    // MARK: Types
    public enum State: Equatable {
        case inProgress
        case staleMate(color: Color)
        case won(color: Color)
        
        public static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.inProgress, .inProgress):
                return true
            case (let .staleMate(color1), let staleMate(color2)):
                return color1 == color2
            case (let .won(color1), let won(color2)):
                return color1 == color2
            default:
                return false
            }
        }
    }
    
    public enum GameType: Int {
        case humanVsHuman
        case humanVsComputer
        case computerVsComputer
    }

    // MARK: Properties
    public internal(set) var board: Board
    public let whitePlayer: Player!
    public let blackPlayer: Player!
    public internal(set) var currentPlayer: Player!
    public internal(set) var state = Game.State.inProgress
    public weak var delegate: GameDelegate?
    
    public var gameType: GameType {
    
        switch (self.whitePlayer, self.blackPlayer) {
        case (is Human, is Human):
            return .humanVsHuman
        case (is AIPlayer, is AIPlayer):
            return .computerVsComputer
        default:
            return .humanVsComputer
        }
    }
    
    // MARK: Init
    public init(firstPlayer: Player,
                secondPlayer: Player,
                board: Board = Board(state: .newGame),
                colorToMove: Color = .white) {
        
        self.board = board
        
        // Assign to correct colors
        if firstPlayer.color == secondPlayer.color {
            fatalError("Both players cannot have the same color")
        }
        
        self.whitePlayer = firstPlayer.color == .white ? firstPlayer : secondPlayer
        self.blackPlayer = firstPlayer.color == .black ? firstPlayer : secondPlayer
        
        // Setup Players
        self.whitePlayer.delegate = self
        self.blackPlayer.delegate = self
        self.whitePlayer.game = self
        self.blackPlayer.game = self
        self.currentPlayer = (colorToMove == .white ? self.whitePlayer : self.blackPlayer)
    }
    
}

// MARK: - Game : PlayerDelegate
extension Game: PlayerDelegate {

    func playerDidMakeMove(player: Player, boardOperations: [BoardOperation]) {
        
        // This shouldn't happen, but we'll print a message in case it does
        if player !== currentPlayer {
            print("Warning - Wrong player took turn")
        }
        
        // Tell delegate we will begin updates
        delegate?.gameWillBeginUpdates(game: self)
        
        // Process board operations
        processBoardOperations(boardOperations: boardOperations)
        
        // Check for game ended
        if board.isColorInCheckMate(color: currentPlayer.color.opposite) {
            state = .won(color: currentPlayer.color)
            delegate?.gameWonByPlayer(game: self, player: currentPlayer)
            return
        }
        
        // Check for stalemate
        if board.isColorInStalemate(color: currentPlayer.color.opposite) {
            state = .staleMate(color: currentPlayer.color.opposite)
            delegate?.gameEndedInStaleMate(game: self)
            return
        }
        
        // Tell the delegate that we've ended updates
        delegate?.gameDidEndUpdates(game: self)
        
        // Switch to the other player
        if player === whitePlayer {
            currentPlayer = blackPlayer
        } else {
            currentPlayer = whitePlayer
        }
        
        self.delegate?.gameDidChangeCurrentPlayer(game: self)
        
    }
    
    func processBoardOperations(boardOperations: [BoardOperation]) {
        
        for boardOperation in boardOperations {
            
            switch boardOperation.type! {
            case .movePiece:
                self.delegate?.gameDidMovePiece(game: self,
                                                piece: boardOperation.piece,
                                                toLocation: boardOperation.location)
            case .removePiece:
                self.delegate?.gameDidRemovePiece(game: self,
                                                  piece: boardOperation.piece,
                                                  location: boardOperation.location)
            case .transformPiece:
                self.delegate?.gameDidTransformPiece(game: self,
                                                     piece: boardOperation.piece,
                                                     location: boardOperation.location)
            }
            
        }
   
    }
    
}

// MARK: - DictionaryRepresentable

extension Game.State: DictionaryRepresentable {
    
    struct Keys {
        static let type = "type"
        static let type_inProgress = "inProgress"
        static let type_stalemate = "stalemate"
        static let type_won = "won"
        static let color = "color"
    }
    
    init?(dictionary: [String: Any]) {
        
        guard let type = dictionary[Keys.type] as? String else {
            return nil
        }
        
        switch type {
        case Keys.type_inProgress:
            self = .inProgress
        case Keys.type_stalemate:
            guard let raw = dictionary[Keys.color] as? String, let color = Color(rawValue: raw) else {
                return nil
            }
            self = .staleMate(color: color)
        case Keys.type_won:
            guard let raw = dictionary[Keys.color] as? String, let color = Color(rawValue: raw) else {
                return nil
            }
            self = .won(color: color)
        default:
            return nil
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        
        switch self {
        case .inProgress:
            dictionary[Keys.type] = Keys.type_inProgress
        case .staleMate(let color):
            dictionary[Keys.type] = Keys.type_stalemate
            dictionary[Keys.color] = color.rawValue
        case .won(let color):
            dictionary[Keys.type] = Keys.type_won
            dictionary[Keys.color] = color.rawValue
        }
        
        return dictionary
    }
}

extension Game: DictionaryRepresentable {
    
    struct Keys {
        static let state = "state"
        static let gameType = "gameType"
        static let board = "board"
        static let whitePlayerType = "whitePlayerType"
        static let blackPlayerType = "blackPlayerType"
        static let playerType_human = "playerType_human"
        static let playerType_ai = "playerType_ai"
        static let whitePlayer = "PlayerOne"
        static let blackPlayer = "PlayerTwo"
        static let currentPlayerColor = "currentPlayerColor"
    }

    public convenience init?(dictionary: [String: Any]) {
        
        // State
        guard let stateDict = dictionary[Keys.state] as? [String: Any],
            let state = State(dictionary: stateDict),
            let gameTypeRaw = dictionary[Keys.gameType] as? Int,
            let gameType = GameType(rawValue: gameTypeRaw),
            let boardDict = dictionary[Keys.board] as? [String: Any],
            let board = Board(dictionary: boardDict),
            let currentPlayerColorRaw = dictionary[Keys.currentPlayerColor] as? String,
            let currentPlayerColor = Color(rawValue: currentPlayerColorRaw)
            else {
                print("Unable to recreate game, missing values")
                return nil
        }
        
        func makePlayer(type: String, dictionary: [String: Any]) -> Player? {
            
            switch type {
            case Keys.playerType_human:
                return Human(dictionary: dictionary)
            case Keys.playerType_ai:
                return AIPlayer(dictionary: dictionary)
            default:
                return nil
            }
        }
        
        // White Player
        guard let whitePlayerType = dictionary[Keys.whitePlayerType] as? String,
            let whitePlayerDict = dictionary[Keys.whitePlayer] as? [String: Any],
            let whitePlayer = makePlayer(type: whitePlayerType, dictionary: whitePlayerDict) else {
            return nil
        }
        
        // Black Player
        guard let blackPlayerType = dictionary[Keys.blackPlayerType] as? String,
            let blackPlayerDict = dictionary[Keys.blackPlayer] as? [String: Any],
            let blackPlayer = makePlayer(type: blackPlayerType, dictionary: blackPlayerDict) else {
                return nil
        }
        
        self.init(firstPlayer: whitePlayer,
                  secondPlayer: blackPlayer,
                  board: board,
                  colorToMove: currentPlayerColor)
    }
    
    public var dictionaryRepresentation: [String: Any] {

        var dictionary = [String: Any]()
        dictionary[Keys.state] = state.dictionaryRepresentation
        dictionary[Keys.gameType] = gameType.rawValue
        dictionary[Keys.board] = board.dictionaryRepresentation
        
        // White Player
        if let whiteHuman = self.whitePlayer as? Human {
            dictionary[Keys.whitePlayerType] = Keys.playerType_human
            dictionary[Keys.whitePlayer] = whiteHuman.dictionaryRepresentation
        } else if let whiteAI = self.whitePlayer as? AIPlayer {
            dictionary[Keys.whitePlayerType] = Keys.playerType_ai
            dictionary[Keys.whitePlayer] = whiteAI.dictionaryRepresentation
        } else {
            fatalError("Cannot determine white player type")
        }
        
        // Black Player
        if let blackHuman = self.blackPlayer as? Human {
            dictionary[Keys.blackPlayerType] = Keys.playerType_human
            dictionary[Keys.blackPlayer] = blackHuman.dictionaryRepresentation
        } else if let blackAI = self.blackPlayer as? AIPlayer {
            dictionary[Keys.blackPlayerType] = Keys.playerType_ai
            dictionary[Keys.blackPlayer] = blackAI.dictionaryRepresentation
        } else {
            fatalError("Cannot determine black player type")
        }
        
        dictionary[Keys.currentPlayerColor] = currentPlayer.color.rawValue
        return dictionary
    }
}

extension Game: Equatable {
    public static func == (lhs: Game, rhs: Game) -> Bool {
        
        func arePlayersEqual(p1: Player, p2: Player) -> Bool {
            
            if let h1 = p1 as? Human, let h2 = p2 as? Human {
                return h1 == h2
            } else if let ai1 = p1 as? AIPlayer, let ai2 = p2 as? AIPlayer {
                return ai1 == ai2
            } else {
                return false
            }
        }
        
        if arePlayersEqual(p1: lhs.whitePlayer, p2: rhs.whitePlayer)
            && arePlayersEqual(p1: lhs.blackPlayer, p2: rhs.blackPlayer)
            && arePlayersEqual(p1: lhs.currentPlayer, p2: rhs.currentPlayer)
            && lhs.board == rhs.board
            && lhs.state == rhs.state {
            return true
        } else {
            return false
        }
    }
}

// MARK: - GameDelegate
public protocol GameDelegate: class {
    
    // State changes
    func gameDidChangeCurrentPlayer(game: Game)
    func gameWonByPlayer(game: Game, player: Player)
    func gameEndedInStaleMate(game: Game)
    
    // Piece adding / removing / modifying
    
    // Updates will begin
    func gameWillBeginUpdates(game: Game)
    // A new piece was added to the board
    func gameDidAddPiece(game: Game)
    // A piece was removed from the board
    func gameDidRemovePiece(game: Game, piece: Piece, location: BoardLocation)
    // A piece was moved on the board
    func gameDidMovePiece(game: Game, piece: Piece, toLocation: BoardLocation)
    // A piece was transformed (eg. pawn was promoted to another piece)
    func gameDidTransformPiece(game: Game, piece: Piece, location: BoardLocation)
    // Updates will end)
    func gameDidEndUpdates(game: Game)
    
    // Callbacks from player
    func promotedTypeForPawn(location: BoardLocation,
                             player: Human,
                             possiblePromotions: [Piece.PieceType],
                             callback: @escaping (Piece.PieceType) -> Void )
}
