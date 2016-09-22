//
//  ViewController.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 09/04/2016.
//  Copyright (c) 2016 Steve Barnegren. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Actions
    
    @IBAction func playerVsAIButtonPressed(_ sender: UIButton){
        print("Player vs AI button pressed")
        
    }
    
    @IBAction func playerVsPlayerButtonPressed(_ sender: UIButton){
        print("Player vs Player button pressed")
        
        let gameViewController = GameViewController.gameViewController()
        self.navigationController?.pushViewController(gameViewController, animated: true)
        
    }
    
    @IBAction func AIvsAIButtonPressed(_ sender: UIButton){
        print("AI vs AI button pressed")
    }

}

