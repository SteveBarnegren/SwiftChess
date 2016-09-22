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
    
    // MARK - Creation
    
    class func gameViewController() -> GameViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = "GameViewController"
        let gameViewController: GameViewController = storyboard.instantiateViewController(withIdentifier: className) as! GameViewController
        return gameViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Board View
        boardView.delegate = self
        
        // Game
        self.game = Game()
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
        self.update(self.game.board)

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
    
    func update(_ board: Board){
        
        for (index, label) in pieceLabels.enumerated() {
            
            let piece = board.pieceAtIndex(index)
            
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
            }
        }
    }
    
    
}

// MARK - Board view delegate

extension GameViewController: BoardViewDelegate{
    
    func touchedSquareAtIndex(_ boardView: BoardView, index: Int) {
        print("GVC touched square at index \(index)")
        
        
        
        
    }
    
}

