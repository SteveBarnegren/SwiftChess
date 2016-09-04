//
//  BoardView.swift
//  SwiftChess
//
//  Created by Steve Barnegren on 04/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit


protocol BoardViewDelegate {
    func touchedSquareAtIndex(boardView: BoardView, index: Int)
}

class BoardView: UIView {
    
    // Mark - Properties
    public var delegate: BoardViewDelegate?
    
    // MARK - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBoardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBoardView()
    }
    
    func setupBoardView(){
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
    }

    // MARK - Drawing
    
    override func drawRect(rect: CGRect) {
        
        let whiteColor = UIColor.whiteColor()
        let blackColor = UIColor.blackColor()
        
        for i in 0..<64 {
            
            let gridX = i % 8
            let gridY = i / 8
            
            // Color
            let color = ((gridX + gridY) % 2 == 0) ? whiteColor : blackColor
            color.set()
            
            // Rect
            let squareSize = CGSize(width: bounds.size.width/8,
                                    height: bounds.size.height/8)
            
            let rect = CGRect(x: CGFloat(gridX) * squareSize.width,
                              y: CGFloat(gridY) * squareSize.height,
                              width: squareSize.width,
                              height: squareSize.height)
            
            // Draw
            let path = UIBezierPath(rect: rect)
            path.fill()
            
        }
        
    }
    
    // MARK - Touch Handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Get touch location
        let location = touches.first!.locationInView(self)
        print("Touch at x: \(location.x) y: \(location.y)")
        
        let boardIndex = boardIndexForLocation(location)
        print("Board index: \(boardIndex)")
        
        delegate?.touchedSquareAtIndex(self, index: boardIndex)
        
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
    }
    
    func boardIndexForLocation(location: CGPoint) -> Int{

        // Flip y (0 at bottom)
        var location = location
        location.y = bounds.size.height - location.y
        
        // Get Grid coordinates
        var gridX = Int(8.0 * location.x / bounds.size.width)
        var gridY = Int(8.0 * location.y / bounds.size.height)
        gridX = min(7, gridX)
        gridY = min(7, gridY)
        
        // Make board index
        return gridX + (gridY*8)
    }
 

}
