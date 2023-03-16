//
//  CaptureScene.swift
//  pokemongo
//
//  Created by Brian Nguyen on 3/12/23.
//  Copyright © 2023 Brian Nguyen. All rights reserved.
//

import SpriteKit
import UIKit

class CaptureScene: SKScene, SKPhysicsContactDelegate{
    var pokemon: Pokemon!
    var pokemonsprite: SKSpriteNode!
    var pokeballsprite: SKSpriteNode!
    
    //constants
    let kpokesize = CGSize(width: 60, height: 60)
    let kpokename = "pokemon"
    
    //bit categories
    let kpokemoncategory: UInt32 = 0x1 << 0
    let kballcategory: UInt32 = 0x1 << 1
    let kedgecategory: UInt32 = 0x1 << 2
    
    var velocity: CGPoint = CGPoint.zero
    var touchpoint: CGPoint = CGPoint()
    var ballthrow = false
    
    var countdown = true
    var maxtime = 60
    var time = 60
    var timelabel = SKLabelNode(fontNamed: "arial")
    var caught = false
    
    override func didMove(to view: SKView) {
        let battlebg = SKSpriteNode(imageNamed: "background")
        //print("encounter start")
        battlebg.size = self.size
        battlebg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        battlebg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battlebg.zPosition = -1
        
        self.addChild(battlebg)
        
        self.messageimage(imageName: "pogo")
        
        self.perform(#selector(pokemonSetup), with: nil, afterDelay: 1.0)
        self.perform(#selector(ballSetup), with: nil, afterDelay: 1.0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kedgecategory
        self.physicsWorld.contactDelegate = self
        
        self.timelabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.9)
        self.addChild(self.timelabel)
        
        //math text 
        let labelrect = CGRect(x: 50, y: 100, width: 400, height: 200)
        let label = UILabel(frame: labelrect)
        label.text = "What is 1+1?"
        view.addSubview(label)
        
    }
    
    @objc func pokemonSetup(){
        self.pokemonsprite = SKSpriteNode(imageNamed: pokemon.imageFileName!)
        self.pokemonsprite.size = kpokesize
        self.pokemonsprite.name = kpokename
        self.pokemonsprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        // beast physics
        self.pokemonsprite.physicsBody = SKPhysicsBody(rectangleOf: kpokesize)
        self.pokemonsprite.physicsBody!.isDynamic = false
        self.pokemonsprite.physicsBody!.affectedByGravity = false
        self.pokemonsprite.physicsBody!.mass = 1.0
        
        //beastie bitmax
        self.pokemonsprite.physicsBody!.categoryBitMask = kpokemoncategory
        self.pokemonsprite.physicsBody!.contactTestBitMask = kballcategory
        self.pokemonsprite.physicsBody!.collisionBitMask = kedgecategory
        
        //beast movement
        let right = SKAction.moveBy(x: 150, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([right, right.reversed(), right.reversed(), right])
        
        self.pokemonsprite.run(SKAction.repeatForever(sequence))
        
        self.addChild(self.pokemonsprite)
    }
    
    @objc func ballSetup(){
        self.pokeballsprite = SKSpriteNode(imageNamed:"pokeball")
        self.pokeballsprite.size = kpokesize
        self.pokeballsprite.name = kpokename
        self.pokeballsprite.position = CGPoint(x: self.size.width/2, y: 100)
        
        //ball physics
        self.pokeballsprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballsprite.frame.size.width/2)
        self.pokeballsprite.physicsBody!.isDynamic = true
        self.pokeballsprite.physicsBody!.affectedByGravity = true
        self.pokeballsprite.physicsBody!.mass = 0.1
        
        //ball bitmask
        self.pokeballsprite.physicsBody!.categoryBitMask = kballcategory
        self.pokeballsprite.physicsBody!.contactTestBitMask = kpokemoncategory
        self.pokeballsprite.physicsBody!.collisionBitMask = kpokemoncategory | kedgecategory
        
        self.addChild(self.pokeballsprite)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        
        if self.pokeballsprite.frame.contains(location!){
            self.ballthrow = true
            self.touchpoint = location!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchpoint = location!
        
        if self.ballthrow{
            throwpokeball()
        }
    }
    
    func throwpokeball(){
        self.ballthrow = false
        
        let dt: CGFloat = 1.0/50
        let distance = CGVector(dx: self.touchpoint.x - self.pokeballsprite.position.x, dy: self.touchpoint.y - self.pokeballsprite.position.y)
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy/dt)
        self.pokeballsprite.physicsBody!.velocity = velocity
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask{
        case kpokemoncategory | kballcategory:
            print("captured")
            self.caught = true
            end()
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.countdown {
            self.maxtime = Int(currentTime) + self.maxtime
            self.countdown = false
        }
        
        self.time = self.maxtime - Int(currentTime)
        self.timelabel.text = "\(self.time)"
        
        if self.time <= 0 {
            end()
        }
    }
    //end encounters
    func end(){
        
        self.pokeballsprite.removeFromParent()
        self.pokemonsprite.removeFromParent()
        
        //display caught indicator
        if caught{
            self.messageimage(imageName: "caught")
            //print("caught")
            self.pokemon.timesCaught += 1
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else{
            print("time ran out")
        }
        self.perform(#selector(self.endcapture), with: nil, afterDelay: 1.0)
        
    }
    
    @objc func endcapture(){
        NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
    }
    
    func messageimage(imageName: String ){
        let text = SKSpriteNode(imageNamed: imageName)
        text.size = CGSize(width: 150, height: 150)
        text.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        self.addChild(text)
        
        text.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
}
