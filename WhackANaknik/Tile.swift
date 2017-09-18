//
//  Tile.swift
//  WhackANaknik
//
//  Created by neemdor semel on 18/08/2017.
//  Copyright © 2017 naknik inc. All rights reserved.
//

import UIKit
import SpriteKit

class Tile: SKNode {
    var charNode: SKSpriteNode!
    var visible = false
    var isHit = false
    
    func configAtPosition(pos: CGPoint){
        position = pos
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        sprite.zPosition = 0.5
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x:0,y:15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "characterGood")
        charNode.position = CGPoint(x:0,y:-90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        addChild(cropNode)
        
    }
    func show(hideTime: Double){
        if(visible){
            return
        }
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        visible = true
        isHit = false
        
        if(RandomInt(min: 0, max: 2) == 0){
            charNode.texture = SKTexture(imageNamed: "steck")
            charNode.name = "charGood"
        }else{
            charNode.texture = SKTexture(imageNamed: "sausage")
            charNode.name = "charEvil"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5, execute: { [unowned self] in
            self.hide()
        })
    }
    func hide(){
        if(!visible){
            return
        }
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        visible = false
    }
    func hit(){
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.run{ [unowned self] in self.hide()}
        let sequence = SKAction.sequence([delay,hide])
        charNode.run(sequence)
    }
}
