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
    var touches = false
    var clockwise = Bool()
    
    var level = 1
    var dots = 0
    
    var levelLabel = SKLabelNode()
    var currentScoreLabel = SKLabelNode()
    
    
    override func didMoveToView(view: SKView) {
        layoutGame()
    }
    
    func layoutGame() {
        backgroundColor = SKColor(red: 26.0/255.0, green:188.0/255.0, blue: 156.0/255.0,  alpha: 1.0)
        
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
        
        levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        levelLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 + self.frame.height/3)
        levelLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        levelLabel.text = "Level \(level)"
        
        currentScoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        currentScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        currentScoreLabel.fontColor = SKColor(red: 236.0/255.0, green: 240.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        currentScoreLabel.text = "Tap!"
        
        self.addChild(levelLabel)
        self.addChild(currentScoreLabel)
        
        newDot()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if !started {
            currentScoreLabel.text = "\(level - dots)"
            runClockwise()
            started = true
            clockwise = true
        } else {
            dotTouched()
        }
    }
    
    func runClockwise() {
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        
        let radian = atan2(dx, dy)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI * 2), clockwise: true)
        
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, duration: 5)
        
        needle.runAction(SKAction.repeatActionForever(run).reversedAction()) // .reverseaction just to run to another way
    }

    func runCounterClockwise() {
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        
        let radian = atan2(dx, dy)
        
        path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: radian, endAngle: radian + CGFloat(M_PI * 2), clockwise: true)
        
        let run = SKAction.followPath(path.CGPath, asOffset: false, orientToPath: true, duration: 5)
        
        needle.runAction(SKAction.repeatActionForever(run)) // .reverseaction just to run to another way
    }
    
    func dotTouched(){
        if touches == true {
            touches = false
            dots++
            updateLabel()
            if dots >= level{
                started = false
                completed()
                return
            }
            dot.removeFromParent()
            newDot()
            
            if clockwise {
                runCounterClockwise()
                clockwise = false
            } else {
                runClockwise()
                clockwise = true
            }
        } else {
            started = false
            touches = false
            gameOver()
        }
    }

    
    func newDot(){
        dot = SKShapeNode(circleOfRadius: 15.0)
        dot.fillColor = SKColor(red: 31.0/255.0, green: 150.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        dot.strokeColor = SKColor.clearColor()
        
        let dx = needle.position.x - self.frame.width/2
        let dy = needle.position.y - self.frame.height/2
        
        let radian = atan2(dx, dy)
        
        if clockwise {
            let tempAngle = CGFloat.random(radian + 1.0, max: radian - 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 2), clockwise: true)
            
            dot.position = tempPath.currentPoint

        } else {
            let tempAngle = CGFloat.random(radian - 1.0, max: radian - 2.5)
            let tempPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 2), clockwise: true)
            
            dot.position = tempPath.currentPoint

        }
        
        self.addChild(dot)
    }
    
    func completed(){
        needle.removeFromParent()
                currentScoreLabel.text = "Won!"
        
        let actionRed = SKAction.colorizeWithColor(UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.waitForDuration(0.5)
        
        self.scene?.runAction(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.level++
            self.layoutGame() // start a new game
            
        })
    }

    
    func gameOver(){
        needle.removeFromParent()
        currentScoreLabel.text = "Fail!"
        
        let actionRed = SKAction.colorizeWithColor(UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.25)
        let actionBack = SKAction.waitForDuration(0.5)
        
        self.scene?.runAction(SKAction.sequence([actionRed, actionBack]), completion: { () -> Void in
            self.removeAllChildren()
            self.clockwise = false
            self.dots = 0
            self.layoutGame() // start a new game
            
        })
    }
    
    func updateLabel(){
        currentScoreLabel.text = "\(level - dots)"
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if started {
            if needle.intersectsNode(dot){
                touches = true
            } else {
                if touches == true {
                    if !needle.intersectsNode(dot){
                        started = false
                        touches = false
                        gameOver()
                    }
                    
                }
            }
        
        }
        
        
        
        
        
        
        
    }
}
