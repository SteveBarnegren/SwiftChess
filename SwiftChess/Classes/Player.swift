//
//  Piece.swift
//  Pods
//
//  Created by Steve Barnegren on 04/09/2016.
//
//

import Foundation

public class Player {
   
    let color: Color!
    weak var game: Game!
    
    init(color: Color, game: Game){
        self.color = color
        self.game = game;
    }
    
    func movePiece(fromIndex: Int, toIndex: Int){
        
    }

    
}

