//
//  DotScene.swift
//  EMDR
//
//  Created by Nick Wu on 1/1/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import UIKit
import SpriteKit

class DotScene: SKScene {
    
    let dot = SKSpriteNode(imageNamed: "dot.png")
    
    let leftEar = SKAudioNode(fileNamed: "leftear.mp3")
    let rightEar = SKAudioNode(fileNamed: "rightear.mp3")
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // Set the background colour.
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        setupDot()
    }
    
    func setupDot() {
        addDot()
        waitDot()
        moveDot()
    }
    
    func addDot() {
        let xPosition = self.frame.size.width/2
        
        let yPosition = self.frame.size.height/2
        
        dot.position = CGPoint(x: xPosition, y: yPosition)
        dot.size.height = 30
        dot.size.width = 30
        
        addChild(dot)
    }
    
    func waitDot() {
        dot.run(SKAction.wait(forDuration: 80))
    }
    
    func moveDot() {
        let yPosition = self.frame.size.height/2
        let xPositionInit = self.frame.size.width - dot.size.width/2
        let xPositionFin = dot.size.width/2
        
        let moveLeft = SKAction.move(to: CGPoint(x: xPositionInit, y: yPosition), duration: 0.8)
        let moveRight = SKAction.move(to: CGPoint(x: xPositionFin, y: yPosition), duration: 0.8)
        let playLeft = SKAction.playSoundFileNamed("leftear.mp3", waitForCompletion: false)
        let playRight = SKAction.playSoundFileNamed("rightear.mp3", waitForCompletion: false)
        
        dot.run(SKAction.repeatForever(SKAction.sequence([moveLeft,playRight,moveRight,playLeft])))
    }
    
    func stopDot(){
        dot.removeAllActions()
    }
    
    override func willMove(from view: SKView) {
        dot.removeAllActions()
    }
}
