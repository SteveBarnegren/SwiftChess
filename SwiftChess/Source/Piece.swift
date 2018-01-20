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
    
    public init(type: PieceType, color: Color, tag: Int = 0) {
        self.type = type
        self.color = color
        self.tag = tag
    }
    
    func byChangingType(newType: PieceType) -> Piece {
        
        let piece = Piece(type: newType, color: color, tag: tag)
        return piece
    }
    
    func isSameTypeAndColor(asPiece other: Piece) -> Bool {
        
        if self.type == other.type && self.color == other.color {
            return true
        } else {
            return false
        }
    }
}

public func == (left: Piece, right: Piece) -> Bool {
    
    if left.type == right.type
        && left.color == right.color
        && left.tag == right.tag
        && left .hasMoved == right.hasMoved
        && left.canBeTakenByEnPassant == right.canBeTakenByEnPassant
        && left.location == right.location {
        return true
    } else {
        return false
    }
}

extension Piece: DictionaryRepresentable {
    
    private struct Keys {
        static let type = "type"
        static let color = "color"
        static let tag = "tag"
        static let hasMoved = "hasMoved"
        static let canBeTakenByEnPassant = "canBeTakenByEnPassant"
        static let location = "location"
    }
    
    init?(dictionary: [String: Any]) {
        
        // Type
        if let raw = dictionary[Keys.type] as? Int, let type = PieceType(rawValue: raw) {
            self.type = type
        } else {
            return nil
        }
        
        // Color
        if let raw = dictionary[Keys.color] as? String, let color = Color(rawValue: raw) {
            self.color = color
        } else {
            return nil
        }
        
        // Tag
        if let tag = dictionary[Keys.tag] as? Int {
            self.tag = tag
        }
        
        // Has Moved
        if let hasMoved = dictionary[Keys.hasMoved] as? Bool {
            self.hasMoved = hasMoved
        } else {
            return nil
        }
        
        // Can be taken by en passent
        if let canBeTakenByEnPassent = dictionary[Keys.canBeTakenByEnPassant] as? Bool {
            self.canBeTakenByEnPassant = canBeTakenByEnPassent
        } else {
            return nil
        }
        
        // Location
        if let dict = dictionary[Keys.location] as? [String: Any], let location = BoardLocation(dictionary: dict) {
            self.location = location
        } else {
            return nil
        }
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary[Keys.type] = type.rawValue
        dictionary[Keys.color] = color.rawValue
        if let tag = self.tag { dictionary[Keys.tag] = tag }
        dictionary[Keys.hasMoved] = hasMoved
        dictionary[Keys.canBeTakenByEnPassant] = canBeTakenByEnPassant
        dictionary[Keys.location] = location.dictionaryRepresentation
        return dictionary
    }
}
