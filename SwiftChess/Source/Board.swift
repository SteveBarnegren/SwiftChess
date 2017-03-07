//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public enum CastleSide {
    case kingSide
    case queenSide
}

// MARK: - ****** Square ******

public struct Square : Equatable {
    
    public var piece: Piece?

}

public func ==(lhs: Square, rhs: Square) -> Bool {
    
    switch (lhs.piece, rhs.piece) {
    case (.none, .none):
        return true
    case (.some, .none):
        return false
    case (.none, .some):
        return false
    case (.some(let rp), .some(let lp)):
        return rp == lp
    }
}

// MARK: - ****** Board ******

public struct Board : Equatable {
        
    public enum InitialState {
        case empty
        case newGame
    }

    public private(set) var squares = [Square]()
    
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
        
        func setPieceAtIndex(_ piece: Piece, _ index: Int){
            setPiece(piece, at: BoardLocation(index: index))
        }
        
        // Setup white bottom row
        setPieceAtIndex(Piece(type: .rook, color: .white), 0)
        setPieceAtIndex(Piece(type: .knight, color: .white), 1)
        setPieceAtIndex(Piece(type: .bishop, color: .white), 2)
        setPieceAtIndex(Piece(type: .queen, color: .white), 3)
        setPieceAtIndex(Piece(type: .king, color: .white), 4)
        setPieceAtIndex(Piece(type: .bishop, color: .white), 5)
        setPieceAtIndex(Piece(type: .knight, color: .white), 6)
        setPieceAtIndex(Piece(type: .rook, color: .white), 7)

        // Setup white pawn row
        for i in 8...15 {
            setPieceAtIndex(Piece(type: .pawn, color: .white), i)
        }
        
        // Setup black bottom row
        setPieceAtIndex(Piece(type: .rook, color: .black), 63)
        setPieceAtIndex(Piece(type: .knight, color: .black), 62)
        setPieceAtIndex(Piece(type: .bishop, color: .black), 61)
        setPieceAtIndex(Piece(type: .king, color: .black), 60)
        setPieceAtIndex(Piece(type: .queen, color: .black), 59)
        setPieceAtIndex(Piece(type: .bishop, color: .black), 58)
        setPieceAtIndex(Piece(type: .knight, color: .black), 57)
        setPieceAtIndex(Piece(type: .rook, color: .black), 56)
        
        // Setup black pawn row
        for i in 48...55 {
            setPieceAtIndex(Piece(type: .pawn, color: .black), i)
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
    
    public mutating func removePiece(atLocation location: BoardLocation) {
        squares[location.index].piece = nil
    }
    
    @discardableResult internal mutating func movePiece(fromLocation: BoardLocation, toLocation: BoardLocation) -> [BoardOperation] {
        
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
        squares[toLocation.index].piece?.location = toLocation;
        squares[toLocation.index].piece?.hasMoved = true
        squares[fromLocation.index].piece = nil
        
        // If the moving piece is a pawn, check whether it just made an en passent move, and remove the passed piece
        IF_EN_PASSANT: if movingPiece.type == .pawn {
        
            let stride = fromLocation.strideTo(location: toLocation)
            let enPassentStride = BoardStride(x: stride.x, y: 0)
            let enPassentLocation = fromLocation.incrementedBy(stride: enPassentStride)
            
            guard let enPassentPiece = getPiece(at: enPassentLocation) else {
                break IF_EN_PASSANT
            }
            
            if enPassentPiece.canBeTakenByEnPassant && enPassentPiece.color == movingPiece.color.opposite() {
                squares[enPassentLocation.index].piece = nil;
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
            
            guard let piece = square.piece else{
                continue
            }
            
            if piece == Piece(type: .king, color: color) {
                king = piece
                break
            }
        }
        
        // We'll implicitly unwrap this, because there should always be a king for each color on the board. If there isn't, it's an error
        return king!
    }
    
    public func getKingLocation(color: Color) -> BoardLocation {
        
        for (index, square) in squares.enumerated() {
            
            guard let piece = square.piece else{
                continue
            }
            
            if piece.color == color && piece.type == .king {
                return BoardLocation(index: index)
            }
        }
        
        fatalError("Couldn't find \(color) king. Kings should always exist")
    }
    
    public func getLocationsOfColor(_ color: Color) -> [BoardLocation] {
        
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
            
            guard let piece = square.piece else{
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
        let oppositionLocations = getLocationsOfColor( color.opposite() )
        
        // Pieces will not move to take the king, so change it for a pawn of the same color
        var noKingBoard = self
        noKingBoard.squares[kingLocation!.index].piece = Piece(type: .pawn, color: color)
        
        for location in oppositionLocations {
            
            guard let piece = getPiece(at: location) else {
                continue
            }
            
            if piece.movement.canPieceMove(fromLocation: location, toLocation: kingLocation!, board: noKingBoard) {
                return true
            }
        }
        
        return false
    }
    
    public func isColorInCheckMate(color: Color) -> Bool {
        
        if !isColorInCheck(color: color) {
            return false
        }
        
        for pieceLocation in getLocationsOfColor( color ) {
            
            guard let piece = getPiece(at: pieceLocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                let canMove = piece.movement.canPieceMove(fromLocation: pieceLocation,
                                                          toLocation: targetLocation,
                                                          board: self)
                
                if canMove {
                    var resultBoard = self
                    resultBoard.movePiece(fromLocation: pieceLocation, toLocation: targetLocation)
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
        }
        else{
            return false
        }
    }
    
    func isColorAbleToMove(color: Color) -> Bool {
        
        for pieceLocation in getLocationsOfColor(color) {
            
            guard let piece = getPiece(at: pieceLocation) else {
                continue
            }
            
            for targetLocation in BoardLocation.all {
                
                let canMove = piece.movement.canPieceMove(fromLocation: pieceLocation,
                                                          toLocation: targetLocation,
                                                          board: self)

                guard canMove == true else {
                    continue
                }
                
                var resultBoard = self
                resultBoard.movePiece(fromLocation: pieceLocation, toLocation: targetLocation)
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
            
            if piece.movement.canPieceMove(fromLocation: BoardLocation(index: index), toLocation: location, board: self) {
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
        
        guard let piece = squares[location.index].piece else{
            return []
        }
        
        var locations = [BoardLocation]()
        
        BoardLocation.all.forEach{
            if piece.movement.canPieceMove(fromLocation: location, toLocation: $0, board: self){
                locations.append($0)
            }
        }
        
        return locations
    }
    
    // MARK: - Castling
    
    struct CastleMove{
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
                kingStartXPos = 3
                rookStartXPos = 0
                kingEndXPos = 1
                rookEndXPos = 2
            case (.black, .queenSide):
                yPos = 7
                kingStartXPos = 3
                rookStartXPos = 7
                kingEndXPos = 5
                rookEndXPos = 4
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
        for xPos in min(castleMove.kingStartXPos, castleMove.rookStartXPos)..<max(castleMove.kingStartXPos, castleMove.rookStartXPos) {
            
            if xPos == castleMove.kingStartXPos || xPos == castleMove.rookStartXPos {
                continue
            }
            
            let location = BoardLocation(x: xPos, y: castleMove.yPos)
            
            if let piece = getPiece(at: location) {
                return false
            }
            
        }
        
        // Check that king is not currently in check
        if isColorInCheck(color: color) {
            return false
        }    
  
        // Check that the king will not end up in, or move through check
        for xPos in min(castleMove.kingEndXPos, castleMove.kingStartXPos)...max(castleMove.kingEndXPos, castleMove.kingStartXPos) {
            
            if xPos == castleMove.kingStartXPos {
                continue
            }
            
            var newBoard = self
            let newLocation = BoardLocation(x: xPos, y: castleMove.yPos)
            newBoard.movePiece(fromLocation: castleMove.kingStartLocation, toLocation: newLocation)
            if newBoard.isColorInCheck(color: color) {
                return false
            }
        }
        
        return true
    }
    
    @discardableResult internal mutating func performCastle(color: Color, side: CastleSide) -> [BoardOperation] {
        
        assert(canColorCastle(color: color, side: side) == true, "\(color) is unable to castle on side \(side). Call canColorCastle(color: side:) first")
        
        let castleMove = CastleMove(color: color, side: side)
    
        let moveKingOperations = self.movePiece(fromLocation: castleMove.kingStartLocation, toLocation: castleMove.kingEndLocation)
        let moveRookOperations = self.movePiece(fromLocation: castleMove.rookStartLocation, toLocation: castleMove.rookEndLocation)
        
        return moveKingOperations + moveRookOperations
    }
    
    // MARK: - Print
    
    public func printBoardColors() {
        printBoard { (square: Square) -> Character? in
            
            if let piece = square.piece{
                return piece.color == .white ? "W" : "B"
            }
            return nil;
        }
    }
    
    public func printBoardPieces() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece{
                
                switch (piece.type){
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
            return character;
        }
    }
    
    public func printBoardState() {
        printBoard { (square: Square) -> Character? in
            
            var character: Character?
            
            if let piece = square.piece{
                
                switch (piece.type){
                case .rook:
                    character = piece.color == .white ? "R" : "r"
                case .knight:
                    character = piece.color == .white ? "K" : "k"
                case .bishop:
                    character = piece.color == .white ? "B" : "b"
                case .queen:
                    character = piece.color == .white ? "Q" : "q"
                case .king:
                    character = piece.color == .white ? "K" : "k"
                case .pawn:
                    character = piece.color == .white ? "P" : "p"
                }
                
            }
            return character;
        }
    }


    
    func printBoard( _ squarePrinter: (Square) -> Character? ){
        
        var printString = String()
        
        for y in  (0...7).reversed(){
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

public func ==(lhs: Board, rhs: Board) -> Bool {
    return lhs.squares == rhs.squares
}
