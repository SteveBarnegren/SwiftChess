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
    var game: Game!
    
    // MARK - Creation
    
    class func gameViewController() -> GameViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let className = String(GameViewController)
        let gameViewController: GameViewController = storyboard.instantiateViewControllerWithIdentifier(className) as! GameViewController
        return gameViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Board View
        boardView.delegate = self
        
        // Game
        self.game = Game()
        self.game.board.printBoardState()

    }


}

// MARK - Board view delegate

extension GameViewController: BoardViewDelegate{
    
    func touchedSquareAtIndex(boardView: BoardView, index: Int) {
        print("GVC touched square at index \(index)")
        
        
        
        
    }
    
}

