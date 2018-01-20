//
//  BoardLocation.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 31/01/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import Foundation

public struct BoardLocation: Equatable {
    
    public enum GridPosition: Int {
        case a1; case b1; case c1; case d1; case e1; case f1; case g1; case h1
        case a2; case b2; case c2; case d2; case e2; case f2; case g2; case h2
        case a3; case b3; case c3; case d3; case e3; case f3; case g3; case h3
        case a4; case b4; case c4; case d4; case e4; case f4; case g4; case h4
        case a5; case b5; case c5; case d5; case e5; case f5; case g5; case h5
        case a6; case b6; case c6; case d6; case e6; case f6; case g6; case h6
        case a7; case b7; case c7; case d7; case e7; case f7; case g7; case h7
        case a8; case b8; case c8; case d8; case e8; case f8; case g8; case h8
    }
    
    public var index: Int
    
    private static var allLocationsBacking: [BoardLocation]?
    public static var all: [BoardLocation] {
        
        if let all = allLocationsBacking {
            return all
        } else {
            var locations = [BoardLocation]()
            
            (0..<64).forEach {
                locations.append(BoardLocation(index: $0))
            }
            
            allLocationsBacking = locations
            return allLocationsBacking!
        }
    }
    
    public var isDarkSquare: Bool {
        return (index + y) % 2 == 0
    }
    
    public var x: Int {
        return index % 8
    }
    
    public var y: Int {
        return index / 8
    }
    
    public var gridPosition: GridPosition {
        return GridPosition(rawValue: index)!
    }
    
    public init(index: Int) {
        self.index = index
    }
    
    public init(x: Int, y: Int) {
        self.index = x + (y*8)
    }
    
    public init(gridPosition: GridPosition) {
        self.index = gridPosition.rawValue
    }
    
    func isInBounds() -> Bool {
        return (index < 64 && index >= 0)
    }
    
    func incremented(by offset: Int) -> BoardLocation {
        return BoardLocation(index: index + offset)
    }
    
    func incrementedBy(x: Int, y: Int) -> BoardLocation {
        return self + BoardLocation(x: x, y: y)
    }
    
    func incremented(by stride: BoardStride) -> BoardLocation {
        
        // swiftlint:disable line_length
        assert(canIncrement(by: stride),
               "BoardLocation is being incremented by a stride that will result in wrapping! call canIncrementBy(stride: BoardStride) first")
        // swiftlint:enable line_length
        
        return BoardLocation(x: x + stride.x,
                             y: y + stride.y)
    }
    
    func canIncrement(by stride: BoardStride) -> Bool {
        
        // Check will not wrap to right
        if x + stride.x > 7 {
            return false
        }
        
        // Check will not wrap to left
        if x + stride.x < 0 {
            return false
        }
        
        // Check will not wrap top
        if y + stride.y > 7 {
            return false
        }
        
        // Check will not wrap bottom
        if y + stride.y < 0 {
            return false
        }
        
        return true
    }
    
    func strideTo(location: BoardLocation) -> BoardStride {
        
        return BoardStride(x: location.x - x,
                           y: location.y - y)
    }
    
    func strideFrom(location: BoardLocation) -> BoardStride {
        
        return BoardStride(x: x - location.x,
                           y: y - location.y)
    }
}

public func == (lhs: BoardLocation, rhs: BoardLocation) -> Bool {
    return lhs.index == rhs.index
}

public func + (left: BoardLocation, right: BoardLocation) -> BoardLocation {
    return BoardLocation(index: left.index + right.index)
}

extension BoardLocation: DictionaryRepresentable {
    
    struct Keys {
        static let index = "index"
    }
    
    init?(dictionary: [String: Any]) {
        
        guard let index = dictionary[Keys.index] as? Int else {
            return nil
        }
        
        self.index = index
    }
    
    var dictionaryRepresentation: [String: Any] {
        
        var dictionary = [String: Any]()
        dictionary[Keys.index] = index
        return dictionary
    }
}
