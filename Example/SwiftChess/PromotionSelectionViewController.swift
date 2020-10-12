//
//  PromotionSelectionViewController.swift
//  Example
//
//  Created by Steve Barnegren on 29/12/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftChess

class PromotionSelectionViewController: UIViewController {
    
    // MARK: - Properties (Passed In)
    var pawnLocation: BoardLocation!
    var possibleTypes: [Piece.PieceType]!
    var callback: ((Piece.PieceType) -> Void)!
    
    // MARK: - Properties
    var buttons = [UIButton]()

    // MARK: - Creation
    public static func promotionSelectionViewController(pawnLocation: BoardLocation,
                                                        possibleTypes: [Piece.PieceType],
                                                        callback: @escaping (Piece.PieceType) -> Void)
        -> PromotionSelectionViewController {
        
        let viewController = PromotionSelectionViewController()
        viewController.pawnLocation = pawnLocation
        viewController.possibleTypes = possibleTypes
        viewController.callback = callback
        return viewController
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.orange
        view.layer.cornerRadius = 7

        // Add buttons for types
        for type in possibleTypes {
            
            let typeString = stringFromPieceType(pieceType: type)
            let button = UIButton(type: .system)
            button.setTitle(typeString, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            view.addSubview(button)
            buttons.append(button)
        }
        
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonHeight = view.bounds.size.height / CGFloat(buttons.count)
        
        for (index, button) in buttons.enumerated() {
            
            button.frame = CGRect(x: 0,
                                  y: CGFloat(index) * buttonHeight,
                                  width: view.bounds.size.width,
                                  height: buttonHeight)
        }
    }
    
    // MARK: - Actions
    
    @objc func buttonPressed(sender: UIButton) {
        
        let index = buttons.firstIndex(of: sender)!
        let chosenType = possibleTypes![index]
        callback(chosenType)
    }
    
    // MARK: - Helpers
    func stringFromPieceType(pieceType: Piece.PieceType) -> String {
        
        switch pieceType {
        case .pawn: return "Pawn"
        case .rook: return "Rook"
        case .knight: return "Knight"
        case .bishop: return "Bishop"
        case .queen: return "Queen"
        case .king: return "King"
        }
    }
    
}
