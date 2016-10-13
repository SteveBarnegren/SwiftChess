//
//  GameViewController.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 04/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SwiftChess

class GameViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    var pieceLabels = [UILabel]()
    var game: Game!
    var selectedIndex: Int?
    
    // MARK: - Creation
    
    class func gameViewController(game: Game) -> GameViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = "GameViewController"
        let gameViewController: GameViewController = storyboard.instantiateViewController(withIdentifier: className) as! GameViewController
        gameViewController.game = game;
        return gameViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Board View
        boardView.delegate = self
        
        // Game
        self.game.board.printBoardState()
        
        // Piece labels
        for _ in 0..<64 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 30)
            self.boardView.addSubview(label)
            self.pieceLabels.append(label)
        }
        
        // Update
        self.update()

    }
    
    override func viewDidLayoutSubviews() {
        
        for (index, label) in pieceLabels.enumerated() {
            
            let gridX = index % 8
            let gridY = (63 - index) / 8
            
            let labelWidth = boardView.bounds.size.width / 8
            let labelHeight = boardView.bounds.size.height / 8
            
            label.frame = CGRect(x: CGFloat(gridX) * labelWidth,
                                 y: CGFloat(gridY) * labelHeight,
                                 width: labelWidth,
                                 height: labelHeight)
            
        }
        
    }
    
    func update(){
        
        for (index, label) in pieceLabels.enumerated() {
            
            let piece = self.game.board.getPiece(at: BoardLocation(index: index))
            
            var string = ""
            
            if let piece = piece{
                
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
                    string = "K"
                case .pawn:
                    string = "P"
                }
            }
            
            label.text = string
            
            if let piece = piece{
                label.textColor = piece.color == .white ? UIColor.white : UIColor.black
                
                if selectedIndex == index {
                    label.textColor = UIColor.magenta
                }
            }
        }
    }
    
    
}

// MARK: - Board view delegate

extension GameViewController: BoardViewDelegate {
    
    func touchedSquareAtIndex(_ boardView: BoardView, index: Int) {
        
        // Update once we're done
        defer {
            update()
        }
        
        print("GVC touched square at index \(index)")
        let location = BoardLocation(index: index)
        
        // If there is a selected piece, see if it can move to the new location
        if let selectedIndex = selectedIndex {
            
            let selectedLocation = BoardLocation(index: selectedIndex)
            
            let canMove = self.game.currentPlayer.canMovePiece(fromLocation: selectedLocation,
                                                               toLocation: location)
            if canMove {
                self.game.currentPlayer.movePiece(fromLocation: selectedLocation,
                                                  toLocation: location)
                self.selectedIndex = nil
                return
            }
        }
        
        // Clear selected index
        selectedIndex = nil;
        
        // Select new piece if possible
        if self.game.currentPlayer.occupiesSquareAt(location: location) {
            selectedIndex = index
        }
        
    }
    
}

extension GameViewController: GameDelegate {
    
    func gameDidChangeCurrentPlayer(game: Game) {
        // Do nothing for now
        print("GameViewController - game did change current player")
    }
}

