//
//  GameScene.swift
//  Pop A Lock
//
//  Created by Alex Lima Lopes Cancado on 13/02/16.
//  Copyright (c) 2016 Alex Lima Lopes Cancado. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var lock = SKShapeNode()
    var needle = SKShapeNode()
    var dot = SKShapeNode()
    
    
    var path = UIBezierPath()
    
    let zeroAngle: CGFloat = 0.0
    
    var started = false
    
    override func didMoveToView(view: SKView) {
        layoutGame()
    }
    
    func layoutGame() {
        backgroundColor = SKColor.whiteColor()
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width/2, y: self.frame.height/2), radius: 120, startAngle: zeroAngle, endAngle: zeroAngle + CGFloat(M_PI * 2), clockwise: true)
        
        lock = SKShapeNode(path: path.CGPath)
        lock.strokeColor = SKColor.grayColor()
        lock.lineWidth = 40.0
        self.addChild(lock)
        
        
        needle = SKShapeNode(rectOfSize: CGSize(width: 40.0 - 7.0, height: 7.0), cornerRadius: 3.5)
        needle.fillColor = SKColor.whiteColor()
        needle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + 120)
        needle.zRotation = 3.14 / 2 //90 degrees
        needle.zPosition = 2.0 //top of the circle
        self.addChild(needle)
        
        newDot()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if !started {
            runClockwise()
            started = true
        }
    }
    
    func runClockwise(){
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        
        let radian = atan2(dx, dy)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI * 2), clockwise: true)
        
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, duration: 5)
        
        needle.runAction(SKAction.repeatActionForever(run).reversedAction()) // .reverseaction just to run to another way
    }
    
    func newDot(){
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clearColor()
        
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        
        let radian = atan2(dx, dy)
        
        let tempAngle = CGFloat.random(radian + 1.0, max: radian - 2.5)
        let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 2), clockwise: true)
        
        dot.position = tempPath.currentPoint
        self.addChild(dot)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
