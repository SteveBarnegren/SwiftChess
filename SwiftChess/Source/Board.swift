//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

// swiftlint:disable file_length
// swiftlint:disable type_body_length

import Foundation

public enum CastleSide {
    case kingSide
    case queenSide
}

// MARK: - ****** Square ******

public struct Square: Equatable {
    
    public var piece: Piece?

}

public func == (lhs: Square, rhs: Square) -> Bool {
    
    switch (lhs.piece, rhs.piece) {
    case (.none, .none):
        return true
    case (.some(let rp), .some(let lp)):
        return rp.isSameTypeAndColor(asPiece: lp)
    default:
        return false
    }
}

extension Square: DictionaryRepresentable {
    
    struct Keys {
        static let piece = "piece"
    }
    
    init?(dictionary: [String: Any]) {
        
        if let dict = dictionary[Keys.piece] as? [String: Any], let piece = Piece(dictionary: dict) {
            self.piece = piece
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        
        if let piece = self.piece {
            dictionary[Keys.piece] = piece.dictionaryRepresentation
        }
        
        return dictionary
    }
}

// MARK: - ****** Board ******

public struct Board: Equatable {
        
    public enum InitialState {
        case empty
        case newGame
    }

    public private(set) var squares = [Square]()
    private var lastAssignedPieceTag = 0
    
    // MARK: - Init
    public init(state: InitialState) {
        
        // Setup squares
        for _ in 0..<64 {
            squares.append(Square())
        }
        
        // Setup for new game?
        if state == .newGame {
            setupForNewGame()
        }
    }
    
    mutating func setupForNewGame() {
        
        let pieces: [Piece.PieceType] = [.rook, .knight, .bishop, .queen, .king, .bishop, .knight, .rook]
        
        func makePiece(type: Piece.PieceType, color: Color) -> Piece {
            lastAssignedPieceTag += 1
            return Piece(type: type, color: color, tag: lastAssignedPieceTag)
        }

        // Setup white bottom row
        for i in 0...7 {
            setPiece(makePiece(type: pieces[i], color: .white), at: BoardLocation(index: i))
        }

        // Setup white pawn row
        for i in 8...15 {
            setPiece(makePiece(type: .pawn, color: .white), at: BoardLocation(index: i))
        }
        
        // Setup black bottom row
        for i in 56...63 {
            setPiece(makePiece(type: pieces[i-56], color: .black), at: BoardLocation(index: i))
        }
        
        // Setup black pawn row
        for i in 48...55 {
            setPiece(makePiece(type: .pawn, color: .black), at: BoardLocation(index: i))
        }
    }
    
    // MARK: - Manipulate Pieces
    
    public mutating func setPiece(_ piece: Piece, at location: BoardLocation) {
        squares[location.index].piece = piece
        squares[location.index].piece?.location = location
    }
    
    public func getPiece(at location: BoardLocation) -> Piece? {
        return squares[location.index].piece
    }
    
    public mutating func removePiece(at location: BoardLocation) {
        squares[location.index].piece = nil
    }
    
    @discardableResult internal mutating func movePiece(from fromLocation: BoardLocation,
                                                        to toLocation: BoardLocation) -> [BoardOperation] {
        
        if toLocation == fromLocation {
            return []
        }
    
        var operations = [BoardOperation]()
        
        guard let movingPiece = getPiece(at: fromLocation) else {
            fatalError("There is no piece on at (\(fromLocation.x),\(fromLocation.y))")
        }
        
        let operation = BoardOperation(type: .movePiece, piece: movingPiece, location: toLocation)
        operations.append(operation)

        if let targetPiece = getPiece(at: toLocation) {
            let operation = BoardOperation(type: .removePiece, piece: targetPiece, location: toLocation)
            operations.append(operation)
        }
        
        squares[toLocation.index].piece = self.squares[fromLocation.index].piece
        squares[toLocation.index].piece?.location = toLocation
        squares[toLocation.index].piece?.hasMoved = true
        squares[fromLocation.index].piece = nil
        
        // If the moving piece is a pawn, check whether it just made an en passent move, and remove the passed piece
        IF_EN_PASSANT: if movingPiece.type == .pawn {
        
            let stride = fromLocation.strideTo(location: toLocation)
            let enPassentStride = BoardStride(x: stride.x, y: 0)
            let enPassentLocation = fromLocation.incremented(by: enPassentStride)
            
            guard let enPassentPiece = getPiece(at: enPassentLocation) else {
                break IF_EN_PASSANT
            }
            
            if enPassentPiece.canBeTakenByEnPassant && enPassentPiece.color == movingPiece.color.opposite {
                squares[enPassentLocation.index].piece = nil
                let operation = BoardOperation(type: .removePiece, piece: enPassentPiece, location: enPassentLocation)
                operations.append(operation)
            }
        }
        
        // Reset en passant flags
        resetEnPassantFlags()
        
        // If pawn has moved two squares, then need to update the en passant flag
        if movingPiece.type == .pawn {
            
            let startingRow = (movingPiece.color == .white ? 1 : 6)
            let twoAheadRow = (movingPiece.color == .white ? 3 : 4)
            
            if fromLocation.y == startingRow && toLocation.y == twoAheadRow {
                squares[toLocation.index].piece?.canBeTakenByEnPassant = true
            }
        }
        
        return operations
    }
    
    mutating func resetEnPassantFlags() {
        
        for i in 0..<squares.count {
            squares[i].piece?.canBeTakenByEnPassant = false
        }
    }
    
    // MARK: - Get Specific pieces
    
    func getKing(color: Color) -> Piece {
    
        var king: Piece?
    
        for square in squares {
            
            guard let piece = square.piece else {
                continue
            }
            
            if piece.isSameTypeAndColor(asPiece: Piece(type: .king, color: color)) {
                king = piece
                break
            }
        }
        
        // We'll implicitly unwrap this, because there should always be a king for each color on the board.
        // If there isn't, it's an error
        return king!
    }
    
    public func getKingLocation(color: Color) -> BoardLocation {
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else {
                continue
            }
            
            if piece.color == color && piece.type == .king {
                return BoardLocation(index: index)
            }
        }
        
        fatalError("Couldn't find \(color) king. Kings should always exist")
    }
    
    public func getLocations(of color: Color) -> [BoardLocation] {
        
        var locations = [BoardLocation]()
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else {
                continue
            }
            
            if piece.color == color {
                locations.append(BoardLocation(index: index))
            }
        }
        
        return locations
    }
    
    public func getPieces(color: Color) -> [Piece] {
        
        var pieces = [Piece]()
        
        for square in squares {
            
            guard let piece = square.piece else {
                continue
            }
            
            if piece.color == color {
                pieces.append(piece)
            }
        }
        
        return pieces
        
    }
    
    public func getLocationsOfPromotablePawns(color: Color) -> [BoardLocation] {
        
        var promotablePawnLocations = [BoardLocation]()
        
        let y: Int = (color == .white ? 7 : 0)
        
        for x in 0...7 {
        
            let location = BoardLocation(x: x, y: y)
            
            guard let piece = self.getPiece(at: location) else {
                continue
            }
            
            if piece.color == color && piece.type == .pawn {
                promotablePawnLocations.append(location)
            }
        }
        
        return promotablePawnLocations
    }
    
    // MARK: - Check / Check mate state
    
    public func isColorInCheck(color: Color) -> Bool {
        
        // Get the King location
        var kingLocation: BoardLocation?
        for location in BoardLocation.all {
            
            guard let piece = getPiece(at: location) else {
                continue
            }

            if piece.color == color && piece.type == .king {
                kingLocation = location
                break
            }
        }
        
        // If there is no king, then return false (some tests will be run without a king)
        if kingLocation == nil {
            return false
        }
        
        // Work out if we're in check
        let oppositionLocations = getLocations(of: color.opposite)
        
        // Pieces will not move to take the king, so change it for a pawn of the same color
        var noKingBoard = self
        noKingBoard.squares[kingLocation!.index].piece = Piece(type: .pawn, color: color)
        
        for location in oppositionLocations {
            
            guard let piece = getPiece(at: location) else {
                continue
            }
            
            if piece.movement.canPieceMove(from: location, to: kingLocation!, board: noKingBoard) {
                return true
            }
        }
        
        return false
    }
    
    public func isColorInCheckMate(color: Color) -> Bool {
        
        if !isColorInCheck(color: color) {
            return false
        }
        
        for pieceLocation in getLocations(of: color) {
            
            guard let piece = getPiece(at: pieceLocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                let canMove = piece.movement.canPieceMove(from: pieceLocation, to: targetLocation, board: self)
                
                if canMove {
                    var resultBoard = self
                    resultBoard.movePiece(from: pieceLocation, to: targetLocation)
                    if resultBoard.isColorInCheck(color: color) == false {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    public func isColorInStalemate(color: Color) -> Bool {
        
        if !isColorAbleToMove(color: color) && !isColorInCheckMate(color: color) {
            return true
        } else {
            return false
        }
    }
    
    func isColorAbleToMove(color: Color) -> Bool {
        
        for pieceLocation in getLocations(of: color) {
            
            guard let piece = getPiece(at: pieceLocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                let canMove = piece.movement.canPieceMove(from: pieceLocation, to: targetLocation, board: self)

                guard canMove == true else {
                    continue
                }
                
                var resultBoard = self
                resultBoard.movePiece(from: pieceLocation, to: targetLocation)
                if resultBoard.isColorInCheck(color: color) == false {
                    return true
                }
            }
        }
        
        return false
    }
    
    // MARK: - Possession
    
    func canColorMoveAnyPieceToLocation(color: Color, location: BoardLocation) -> Bool {
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else {
                continue
            }

            if piece.color != color {
                continue
            }
            
            if piece.movement.canPieceMove(from: BoardLocation(index: index), to: location, board: self) {
                return true
            }
        }
 
        return false
    }
    
    func doesColorOccupyLocation(color: Color, location: BoardLocation) -> Bool {
        
        guard let piece = getPiece(at: location) else {
            return false
        }

        return (piece.color == color ? true : false)
    }
    
    public func possibleMoveLocationsForPiece(atLocation location: BoardLocation) -> [BoardLocation] {
        
        guard let piece = squares[location.index].piece else {
            return []
        }
        
        var locations = [BoardLocation]()
        
        BoardLocation.all.forEach {
            if piece.movement.canPieceMove(from: location, to: $0, board: self) {
                locations.append($0)
            }
        }
        
        return locations
    }
    
    // MARK: - Castling
    
    struct CastleMove {
        let yPos: Int
        let kingStartXPos: Int
        let rookStartXPos: Int
        let kingEndXPos: Int
        let rookEndXPos: Int
        
        var kingStartLocation: BoardLocation {
            return BoardLocation(x: kingStartXPos, y: yPos)
        }
        
        var kingEndLocation: BoardLocation {
            return BoardLocation(x: kingEndXPos, y: yPos)
        }
        
        var rookStartLocation: BoardLocation {
            return BoardLocation(x: rookStartXPos, y: yPos)
        }
        
        var rookEndLocation: BoardLocation {
            return BoardLocation(x: rookEndXPos, y: yPos)
        }
        
        init(color: Color, side: CastleSide) {
            
            switch (color, side) {
            case (.white, .kingSide):
                yPos = 0
                kingStartXPos = 4
                rookStartXPos = 7
                kingEndXPos = 6
                rookEndXPos = 5
            case (.white, .queenSide):
                yPos = 0
                kingStartXPos = 4
                rookStartXPos = 0
                kingEndXPos = 2
                rookEndXPos = 3
            case (.black, .kingSide):
                yPos = 7
                kingStartXPos = 4
                rookStartXPos = 7
                kingEndXPos = 6
                rookEndXPos = 5
            case (.black, .queenSide):
                yPos = 7
                kingStartXPos = 4
                rookStartXPos = 0
                kingEndXPos = 2
                rookEndXPos = 3
            }
        }
    }

    public func canColorCastle(color: Color, side: CastleSide) -> Bool {
        
       // Get the correct castle move
        let castleMove = CastleMove(color: color, side: side)
        
        // Get the pieces
        guard let kingPiece = getPiece(at: castleMove.kingStartLocation) else {
            return false
        }

        guard let rookPiece = getPiece(at: castleMove.rookStartLocation) else {
            return false
        }
        
        // Check that the pieces are of the correct types
        guard kingPiece.type == .king else {
            return false
        }
        
        guard rookPiece.type == .rook else {
            return false
        }
        
        // Check that neither of the pieces have moved yet
        if kingPiece.hasMoved == true || rookPiece.hasMoved == true {
            return false
        }
        
        // Check that there are no pieces between the king and the rook
        let rStart = min(castleMove.kingStartXPos, castleMove.rookStartXPos)
        let rEnd = max(castleMove.kingStartXPos, castleMove.rookStartXPos)
        for xPos in rStart..<rEnd {
            
            if xPos == castleMove.kingStartXPos || xPos == castleMove.rookStartXPos {
                continue
            }
            
            let location = BoardLocation(x: xPos, y: castleMove.yPos)
            
            if getPiece(at: location) != nil {
                return false
            }
            
        }
        
        // Check that king is not currently in check
        if isColorInCheck(color: color) {
            return false
        }    
  
        // Check that the king will not end up in, or move through check
        let kStart = min(castleMove.kingEndXPos, castleMove.kingStartXPos)
        let kEnd = max(castleMove.kingEndXPos, castleMove.kingStartXPos)
        for xPos in kStart...kEnd {
            
            if xPos == castleMove.kingStartXPos {
                continue
            }
            
            var newBoard = self
            let newLocation = BoardLocation(x: xPos, y: castleMove.yPos)
            newBoard.movePiece(from: castleMove.kingStartLocation, to: newLocation)
            if newBoard.isColorInCheck(color: color) {
                return false
            }
        }
        
        return true
    }
    
    @discardableResult internal mutating func performCastle(color: Color, side: CastleSide) -> [BoardOperation] {
        
        assert(canColorCastle(color: color, side: side) == true,
               "\(color) is unable to castle on side \(side). Call canColorCastle(color: side:) first")
        
        let castleMove = CastleMove(color: color, side: side)
    
        let moveKingOperations = self.movePiece(from: castleMove.kingStartLocation,
                                                to: castleMove.kingEndLocation)
        let moveRookOperations = self.movePiece(from: castleMove.rookStartLocation,
                                                to: castleMove.rookEndLocation)
        
        return moveKingOperations + moveRookOperations
    }
    
    // MARK: - Print
    
    public func printBoardColors() {
        printBoard { (square: Square) -> Character? in
            
            if let piece = square.piece {
                return piece.color == .white ? "W" : "B"
            }
            return nil
        }
    }
    
    public func printBoardPieces() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece {
                
                switch piece.type {
                case .rook:
                    character = "R"
                case .knight:
                    character = "K"
                case .bishop:
                    character = "B"
                case .queen:
                    character = "Q"
                case .king:
                    character = "G"
                case .pawn:
                    character = "P"

                }
            }
            return character
        }
    }
    
    public func printBoardState() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece {
                
                switch piece.type {
                case .rook:
                    character = piece.color == .white ? "R" : "r"
                case .knight:
                    character = piece.color == .white ? "K" : "k"
                case .bishop:
                    character = piece.color == .white ? "B" : "b"
                case .queen:
                    character = piece.color == .white ? "Q" : "q"
                case .king:
                    character = piece.color == .white ? "G" : "g"
                case .pawn:
                    character = piece.color == .white ? "P" : "p"
                }
                
            }
            return character
        }
    }
    
    func printBoard( _ squarePrinter: (Square) -> Character? ) {
        
        var printString = String()
        
        for y in  (0...7).reversed() {
            for x in 0...7 {
                
                let index = y*8 + x
                let character = squarePrinter(squares[index])
                printString.append(character ?? "-")
            }
            
            printString.append(Character("\n"))
        }
        
        print(printString)
    }
}

public func == (lhs: Board, rhs: Board) -> Bool {
    return lhs.squares == rhs.squares
}

extension Board: DictionaryRepresentable {
    
    struct Keys {
        static let squares = "squares"
    }
    
    init?(dictionary: [String: Any]) {
        
        guard let squaresDicts = dictionary[Keys.squares] as? [[String: Any]] else {
            return nil
        }
        
        let squares = squaresDicts.compactMap { Square(dictionary: $0) }
        if squares.count == 64 {
            self.squares = squares
        } else {
            return nil
        }
        
        lastAssignedPieceTag = squares.compactMap { $0.piece }.map { $0.tag }.max() ?? 0
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        let squares = self.squares.map { $0.dictionaryRepresentation }
        dictionary[Keys.squares] = squares
        return dictionary
    }
    
}
