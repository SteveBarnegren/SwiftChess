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
        game.delegate = self
        
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
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Board view delegate

extension GameViewController: BoardViewDelegate {
    
    func touchedSquareAtIndex(_ boardView: BoardView, index: Int) {
        
        print("GVC touched square at index \(index)")
        
        // Get the player (must be human)
        guard let player = game.currentPlayer as? Human else {
            return;
        }
        
        // Update once we're done
        defer {
            update()
        }
        
        let location = BoardLocation(index: index)
        
        // If has tapped the same piece again, deselect it
        if let selectedIndex = selectedIndex {
            if location == BoardLocation(index: selectedIndex) {
                self.selectedIndex = nil
                return
            }
        }
        
        // Select new piece if possible
        if player.occupiesSquareAt(location: location) {
            selectedIndex = index
        }
        
        // If there is a selected piece, see if it can move to the new location
        if let selectedIndex = selectedIndex {
            
            do {
                try player.movePiece(fromLocation: BoardLocation(index: selectedIndex),
                                     toLocation: location)
                
            } catch Player.MoveError.pieceUnableToMoveToLocation {
                print("Piece is unable to move to this location")
                
            } catch Player.MoveError.cannotMoveInToCheck{
                print("Player cannot move in to check")
                showAlert(title: "😜", message: "Player cannot move in to check")
                
            } catch Player.MoveError.playerMustMoveOutOfCheck{
                print("Player must move out of check")
                showAlert(title: "🙃", message: "Player must move out of check")
                
            } catch {
                print("Something went wrong!")
                return
            }
            
        }
        
    }
    
}

extension GameViewController: GameDelegate {
    
    func gameDidChangeCurrentPlayer(game: Game) {
        // Do nothing for now
        print("GameViewController - game did change current player")
        
        if let _ = game.currentPlayer as? AIPlayer {
            perform(#selector(tellAIToTakeGo), with: nil, afterDelay: 3)
        }
    }
    
    func tellAIToTakeGo() {
        
        if let player =  game.currentPlayer as? AIPlayer {
            player.makeMove()
            self.update()
        }
    }
    
    
}



