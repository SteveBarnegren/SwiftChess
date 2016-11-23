//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public enum Color {
    case white
    case black
    
    func opposite() -> Color {
        return (self == .white) ? .black : .white
    }
}

open class Piece {
    
    public enum PieceType {
        case pawn
        case rook
        case knight
        case bishop
        case queen
        case king
    }
    
    open let type: PieceType
    open let color: Color
    
    lazy var movement : PieceMovement = PieceMovement.pieceMovementForPieceType(pieceType: self.type)

    public init(type: PieceType, color: Color){
        self.type = type
        self.color = color
    }
}

public func == (left: Piece, right: Piece) -> Bool {
    
    if left.type == right.type && left.color == right.color {
        return true
    }
    else{
        return false
    }
}
