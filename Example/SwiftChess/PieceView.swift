//
//  PieceView.swift
//  Example
//
//  Created by Steve Barnegren on 26/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftChess

class PieceView: UIView {

    public var piece: Piece {
        didSet{
            update()
        }
    }
    
    public var location: BoardLocation
    
    let label = UILabel()
    
    var selected = false {
        didSet{
            update()
        }
    }
    
    // MARK: - Init
    
    init(piece: Piece, location: BoardLocation) {
        
        // Store properties
        self.piece = piece
        self.location = location
        
        // Super init
        super.init(frame: CGRect.zero)
        
        // Setup label
        self.label.textAlignment = .center
        self.label.font = UIFont.systemFont(ofSize: 20, weight: 10)
        self.label.text = "X"
        addSubview(self.label)

        // Update
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not implemented")
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }
    
    // MARK: - Update
    
    func update() {
        
        var string = ""
        
        switch piece.type {
        case .rook:
            string = "R"
        case .knight:
            string = "K"
        case .bishop:
            string = "B"
        case .queen:
            string = "Q"
        case .king:
            string = "G"
        case .pawn:
            string = "P"
        }
        
        label.text = string
        label.textColor = color()
    }
    
    func color() -> UIColor {
    
        if selected {
            return UIColor.red
        }
        else{
            return piece.color == .white ? UIColor.white : UIColor.black
        }
    }
    
    
    

}
