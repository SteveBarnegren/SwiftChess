//
//  BoardOperation.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 27/11/2016.
//  Copyright © 2016 Steve Barnegren. All rights reserved.
//

import Foundation

struct BoardOperation {
    
    internal enum OperationType {
        case movePiece
        case removePiece
        case transformPiece
    }
    
    internal let type: OperationType!
    internal let piece: Piece!
    internal let location: BoardLocation!
    
    init(type: OperationType, piece: Piece, location: BoardLocation) {
        
        self.type = type
        self.piece = piece
        self.location = location
    }
}
