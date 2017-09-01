//
//  GameScene.swift
//  WhackANaknik
//
//  Created by neemdor semel on 18/08/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var viewController: GameViewController?
    private var tiles = [Tile]()
    private var gameScore : SKLabelNode!
    private var gameTime : SKLabelNode!
    private var score : Int = 0{
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    private var popupTime = 0.85
    private var time = 30{
        didSet {
            gameTime.text = "Time: \(time)"
        }
    }
    private var w = UIScreen.main.bounds.size.width
    private var h = UIScreen.main.bounds.size.height
    
       
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "party")
        background.blendMode = .replace
        background.anchorPoint = CGPoint(x:0.5,y: 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPoint(x: self.frame.midX , y: self.frame.midY)
        
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "ChalkDuster")
        gameScore.text = "Score: 0"
        gameScore.fontSize = 48
        gameScore.zPosition = 1
        gameScore.position = CGPoint(x: self.frame.midX - (w/1.5), y: self.frame.maxY-(h/3))
        addChild(gameScore)
        
        gameTime = SKLabelNode(fontNamed: "ChalkDuster")
        gameTime.text = "Time: 30"
        gameTime.fontSize = 48
        gameTime.zPosition = 1
        gameTime.position = CGPoint(x: self.frame.midX + (w/1.5), y: self.frame.maxY-(h/3))
        addChild(gameTime)
        
        for j in 0..<6 {
            if(j%2 == 0){
                for i in 0..<5 {
                    createTileAt(pos: CGPoint(x: -210+(i*170),y:410-(j*90)))
                }
            }else{
                for i in 0..<4 {
                    createTileAt(pos: CGPoint(x: -280+(i*170),y:410-(j*90)))
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [unowned self] in
            self.createCharacter()
        }
        
    }
    func createTileAt(pos: CGPoint){
        let tile = Tile()
        tile.configAtPosition(pos: pos)
        addChild(tile)
        tiles.append(tile)
        
    }
    func createCharacter(){
        //game ends here//
        time-=1;
        
        if (time <= 0){
            for tile in tiles{
                tile.hide()
            }
            let gameOver = SKSpriteNode(imageNamed:"gameOver")
            gameOver.position = CGPoint(x: self.frame.midX, y : self.frame.midY)
            gameOver.zPosition = 2
            addChild(gameOver)
            
           //Switch Scenes
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [unowned self] in
                self.viewController?.endGame(score: self.score)

            }
            return
        }
        
        
        
        popupTime *= 0.991
        
        tiles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: tiles) as! [Tile]
        tiles[0].show(hideTime: popupTime)
        
        if RandomInt(min: 0, max: 12) > 4 { tiles[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 {  tiles[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { tiles[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { tiles[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = RandomDouble(min: minDelay, max: maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
            self.createCharacter()
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
      
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "charGood" {
                    
                    let tile = node.parent!.parent as! Tile
                    if !tile.visible { continue }
                    if tile.isHit { continue }
                    
                    tile.hit()
                    score -= 5
                    
                    if let soundURL = Bundle.main.url(forResource: "whackBad", withExtension: "caf") {
                        var mySound: SystemSoundID = 0
                        AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
                        // Play
                        AudioServicesPlaySystemSound(mySound);
                    }
                    
                } else if node.name == "charEvil" {
                    
                    let tile = node.parent!.parent as! Tile
                    if !tile.visible { continue }
                    if tile.isHit { continue }
                    
                    tile.charNode.xScale = 0.65
                    tile.charNode.yScale = 0.65
                    
                    tile.hit()
                    score += 1
                    if let soundURL = Bundle.main.url(forResource: "whack", withExtension: "caf") {
                        var mySound: SystemSoundID = 0
                        AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
                        // Play
                        AudioServicesPlaySystemSound(mySound);
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        tile.charNode.xScale = 1
                        tile.charNode.yScale = 1
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
