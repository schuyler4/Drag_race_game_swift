//
//  GameScene.swift
//  DragRacer
//
//  Created by Marek Newton on 6/8/16.
//  Copyright (c) 2016 Marek Newton. All rights reserved.
//

import SpriteKit

struct pysics {
    static let car1 : UInt32 = 0x1 << 1
    static let car2 : UInt32 = 0x1 << 2
    static let finishNode1 : UInt32 = 0x1 << 3
    static let finishNode2 : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
        var car1 = SKSpriteNode()
        var car2 = SKSpriteNode()
        var track1 = SKSpriteNode()
        var track2 = SKSpriteNode()
        var redLight = SKSpriteNode()
        var yellowLight = SKSpriteNode()
        var greenLight = SKSpriteNode()
        var finishNode1 = SKSpriteNode()
        var finishNode2 = SKSpriteNode()
    
        var raceGoing = false
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        self.backgroundColor = SKColor.greenColor()
        
        finishNode1.size = CGSize(width: 150, height: 100)
        finishNode1.position = CGPoint(x: frame.width / 2.5, y: frame.height + 5)
        finishNode1.physicsBody = SKPhysicsBody(rectangleOfSize: finishNode1.size)
        finishNode1.physicsBody?.affectedByGravity = false
        finishNode1.physicsBody?.dynamic = false
        finishNode1.physicsBody?.categoryBitMask = pysics.finishNode1
        finishNode1.physicsBody?.contactTestBitMask = pysics.car1
        finishNode1.color = SKColor.clearColor()
        finishNode1.zPosition = 5
        
        finishNode2.size = CGSize(width: 150, height: 100)
        finishNode2.position = CGPoint(x: frame.width / 1.7, y: frame.height + 5)
        finishNode2.physicsBody = SKPhysicsBody(rectangleOfSize: finishNode2.size)
        finishNode2.physicsBody?.affectedByGravity = false
        finishNode2.physicsBody?.dynamic = false
        finishNode2.physicsBody?.categoryBitMask = pysics.finishNode2
        finishNode2.physicsBody?.collisionBitMask = 0
        finishNode2.color = SKColor.clearColor()
        finishNode2.zPosition = 5
        
        track1 = SKSpriteNode(imageNamed: "track")
        track1.setScale(2)
        track1.position = CGPoint(x: frame.width / 2.5, y: frame.height / 2)
        track1.zPosition = 1
        
        track2 = SKSpriteNode(imageNamed: "track")
        track2.setScale(2)
        track2.position = CGPoint(x:frame.width / 1.7, y: frame.height / 2)
        track2.zPosition = 1
        
        car1 = SKSpriteNode(imageNamed: "car1")
        car1.position = CGPoint(x: frame.width / 2.5, y: 0 + car1.frame.height / 2)
        car1.zPosition = 6
        car1.physicsBody = SKPhysicsBody(rectangleOfSize: car1.size)
        car1.physicsBody?.categoryBitMask = pysics.car1
        car1.physicsBody?.affectedByGravity = false
        car1.physicsBody?.collisionBitMask = 0
        
        car2 = SKSpriteNode(imageNamed: "car2")
        car2.position = CGPoint(x: frame.width / 1.7, y: 0 + car2.frame.height / 2)
        car2.zPosition = 6
        car2.physicsBody = SKPhysicsBody(rectangleOfSize: car2.size)
        car2.physicsBody?.categoryBitMask = pysics.car2
        car2.physicsBody?.affectedByGravity = false
        car2.physicsBody?.dynamic = true
        car2.physicsBody?.contactTestBitMask = pysics.finishNode2
        car2.physicsBody?.collisionBitMask = 0
        
        redLight = SKSpriteNode(imageNamed: "emtyLight")
        redLight.position = CGPoint(x: frame.width / 2, y: frame.height - 270)
        redLight.zPosition = 5
        
        yellowLight = SKSpriteNode(imageNamed: "emtyLight")
        yellowLight.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        yellowLight.zPosition = 5

        greenLight = SKSpriteNode(imageNamed: "emtyLight")
        greenLight.position = CGPoint(x: frame.width / 2, y: frame.height / 2.8)
        greenLight.zPosition = 5
        
        self.addChild(finishNode1)
        self.addChild(finishNode2)
        
        self.addChild(car1)
        self.addChild(car2)
        
        self.addChild(track1)
        self.addChild(track2)
        
        self.addChild(redLight)
        self.addChild(yellowLight)
        self.addChild(greenLight)
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secoundBody = contact.bodyB
        
        if firstBody.categoryBitMask == pysics.car1 && secoundBody.categoryBitMask == pysics.finishNode1 || firstBody.categoryBitMask == pysics.finishNode1 && secoundBody.categoryBitMask == pysics.car1 {
            print("hll0")
        }
        if firstBody.categoryBitMask == pysics.car2 && secoundBody.categoryBitMask == pysics.finishNode2 || firstBody.categoryBitMask == pysics.finishNode2 && secoundBody.categoryBitMask == pysics.car2 {
            print("hello")
        }
    }
    func startRace(){
        
        let changeRed = SKAction.setTexture(SKTexture(imageNamed:"redLight"))
        let changeYellow = SKAction.setTexture(SKTexture(imageNamed:"yellowLight"))
        let changeGreen = SKAction.setTexture(SKTexture(imageNamed: "greenLight"))
        let delay = SKAction.waitForDuration(1.0)
        let redLightSequence = SKAction.sequence([delay,changeRed])
        let yellowLightSequence = SKAction.sequence([delay,delay,changeYellow])
        let greenLightSequence = SKAction.sequence([delay,delay,delay,changeGreen,])
        
        redLight.runAction(redLightSequence)
        yellowLight.runAction(yellowLightSequence)
        greenLight.runAction(greenLightSequence, completion: {() in
                self.raceGoing = true
        })
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        startRace()
        let moveForward = SKAction.moveBy(CGVectorMake(0, 100), duration: 1.0)
        if(raceGoing == true){
            if let touch = touches.first {
                let location = touch.locationInNode(self)
                if location.x > frame.width / 2 {
                    car2.runAction(moveForward)
                }
                else {
                    car1.runAction(moveForward)
                }
            }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
