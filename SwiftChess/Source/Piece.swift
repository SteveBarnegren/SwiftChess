//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public enum Color: String {
    case white = "White"
    case black = "Black"
    
    public var opposite: Color {
        return (self == .white) ? .black : .white
    }
    
    public var string: String {
        return rawValue.lowercased()
    }
    
    public var stringWithCapital: String {
        return rawValue
    }
}

public struct Piece: Equatable {
    
    static private var lastAssignedTag = 0
    
    public enum PieceType: Int {
        case pawn
        case rook
        case knight
        case bishop
        case queen
        case king
        
        var value: Double {
            switch self {
            case .pawn: return 1
            case .rook: return 5
            case .knight: return 3
            case .bishop: return 3
            case .queen: return 9
            case .king: return 0 // King is always treated as a unique case
            }
        }
        
        static func possiblePawnPromotionResultingTypes() -> [PieceType] {
            return [.queen, .knight, .rook, .bishop]
        }
    }
    
    public let type: PieceType
    public let color: Color
    public internal(set) var tag: Int!
    public internal(set) var hasMoved = false
    public internal(set) var canBeTakenByEnPassant = false
    public internal(set) var location = BoardLocation(index: 0)
    
    var movement: PieceMovement! {
        return PieceMovement.pieceMovement(for: self.type)
    }
    
    var withOppositeColor: Piece {
        return Piece(type: type, color: color.opposite)
    }
    
    var value: Double {
        return type.value
    }

    public init(type: PieceType, color: Color) {
        self.type = type
        self.color = color
        
        // assign the next tag
        Piece.lastAssignedTag += 1
        self.tag = Piece.lastAssignedTag
    }
    
    public init(type: PieceType, color: Color, tag: Int) {
        self.type = type
        self.color = color
        self.tag = tag
    }
    
    func byChangingType(newType: PieceType) -> Piece {
        
        let piece = Piece(type: newType, color: color, tag: tag)
        return piece
    }
}

public func == (left: Piece, right: Piece) -> Bool {
    
    if left.type == right.type && left.color == right.color {
        return true
    } else {
        return false
    }
}
